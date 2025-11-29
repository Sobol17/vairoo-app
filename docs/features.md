# Документация по фичам

## Авторизация (`lib/src/features/auth`)
- **Назначение**: двухшаговый вход по номеру телефона и OTP-коду.
- **Data**:
  - `AuthRemoteDataSource` — отправляет номер на `/api/client/auth/request_code` и подтверждает код через `/api/client/auth/verify_code` (в ответ приходит `access_token`, `token_type` и булево поле `is_new_user`, которое определяет нужду в продолжении онбординга).
  - `AuthLocalDataSource` — сохраняет и читает текущую сессию в `SharedPreferences`.
  - `AuthSessionModel` — адаптер между JSON и доменной сущностью.
- **Domain**:
  - `AuthSession` — доменная модель с access токеном, типом токена и телефоном.
  - `AuthRepository` — контракт, который реализует `AuthRepositoryImpl`.
- **Presentation**:
  - `AuthController` (`ChangeNotifier`) — управляет шагами (`phoneInput → otpInput → authenticated`) и хранит состояние.
  - `AuthPage` — экран с формами ввода телефона и OTP, отображает ошибки/индикатор загрузки.
  - Во время онбординга `BirthdateStep`, `GoalStep` и `HabitSpendingStep` вызывают `/api/client/profile/me` с полями `date_of_birth`, `goal` и `habit_spending` соответственно, чтобы синхронизировать профиль пользователя.
- **DI**: регистрируется в `App` через `ProxyProvider`/`ChangeNotifierProvider`; после успешной верификации приложение переключается на `HomePage`.

## Профиль (`lib/src/features/profile`)
- **Назначение**: загрузка и обновление пользовательских данных с сервера.
- **Data**:
  - `ProfileRemoteDataSource` — ходит на `GET /api/client/profile/me` и `PATCH /api/client/profile/me`, синхронизируя `name`, `date_of_birth`, `email`, `sobriety_goal`, `daily_spending`, `goal`, `habit_spending`, `daily_calories` и флаги уведомлений.
  - `ProfileLocalDataSource` — хранит последнюю копию профиля в `SharedPreferences`.
  - `ProfileRepositoryImpl` — сначала пытается загрузить профиль из API и сохраняет его локально, а обновления (в т.ч. дата рождения, цель и траты) шлёт через `PATCH`, синхронизируя кэш.
- **Domain**:
  - `Profile` — содержит `id`, персональные метрики (дата рождения, цель, траты, информация по уведомлениям) и временные метки `created_at`/`updated_at`.
  - `ProfileRepository` — контракт с методами `loadProfile`, `saveProfile`, `updateBirthdate`, `updateGoal` и `updateHabitSpending`.
- **Presentation**:
  - `ProfileController` — использует репозиторий; `loadProfile` скачивает свежие данные, `update...` отправляют соответствующие `PATCH` и обновляют локальный кэш.

## Главная страница (`lib/src/features/home`)
- **Назначение**: отображение мотивационного блока и плана дня, полученного с сервера.
- **Data**:
  - `HomeRemoteDataSource` — ходит на `GET /api/client/home` и преобразует ответ (quote, sobriety, plan, savings, achievements, knowledge, calories, notifications_unread, total_saved) в модели, включая теги/checklist/cta/cover_image_url для каждого пункта плана.
  - `HomeRepositoryImpl` — адаптирует источник данных под доменный контракт.
  - `NoteLocalDataSource` и `NoteModel` пока остаются в проекте, но не используются в текущем процессе авторизации.
- **Domain**:
  - `HomeData` — агрегирует данные для мотивационного и планового блоков.
  - `HomePlanEntry`, `HomeQuote`, `HomeSobriety` и другие вспомогательные сущности описывают структуру ответа.
  - `HomeRepository` — контракт для получения `HomeData`.
- **Presentation**:
  - `HomeController` — загружает `HomeData`, строит `HomeRoutinePlan` из серийного плана и подготавливает карточки инсайтов (сумму “сэкономлено”, достижения, знания и категорию `calories`), а также хранит состояние загрузки/ошибок.
  - `HomePage` — отображает мотивационную карточку, `HomeDailyPlanSection` и `HomeInsightsSection`, используя данные контроллера и переход на `/home/plan`/`/articles`.
- **Особенности**: `App` инжектирует `HomeController` через DI (`HomeRepository` -> `HomeRemoteDataSource`); все запросы выполняются с заголовком `Authorization: Bearer <token>`.

## Дисклеймеры (`lib/src/features/disclaimer`)
- **Назначение**: отображение обязательных предупреждений перед доступом к разделам приложения и хранение факта принятия пользователем.
- **Data**:
  - `DisclaimerLocalDataSource` — сохраняет флаг согласия в `SharedPreferences`.
  - `DisclaimerRepositoryImpl` — адаптирует источник данных под доменный контракт.
- **Domain**:
  - `DisclaimerType` — перечисление доступных дисклеймеров (`main`, `chat`).
  - `DisclaimerRepository` — контракт для чтения/сохранения согласий.
- **Presentation**:
  - `DisclaimerController` — кэширует состояние согласий и уведомляет UI о изменениях.
  - `MainDisclaimerDialog` и `ChatDisclaimerDialog` — виджеты модальных окон.
  - Интеграция: `HomePage` автоматически показывает дисклеймер главного экрана и проверяет согласие перед переходом в чат.

## Статьи (`lib/src/features/articles`)
- **Назначение**: загрузка образовательных материалов из API и повторное использование их в разных разделах приложения.
- **Data**:
  - `ArticlesRemoteDataSource` — обёртка над `ApiClient`, делает `GET /api/client/articles` и `GET /api/client/articles/{id}` и преобразует ответы (`id`, `title`, `subtitle`, `author`, `created_at`, `content`) в модели.
  - `ArticleModel` — сериализатор/десериализатор, расширяющий доменную сущность.
  - `ArticlesRepositoryImpl` — адаптирует remote data source к доменному контракту.
- **Domain**:
  - `Article` — значение статьи с метаданными (описание, содержимое, дата публикации и теги).
  - `ArticlesRepository` — контракт c двумя методами: `fetchArticles()` и `fetchArticleById(id)`.
- **Presentation**:
  - `ArticlesController` — `ChangeNotifier`, умеет лениво подгружать список статей, подгружать отдельную статью и кэшировать результат.
- **DI**: в `App` зарегистрированы `ProxyProvider` для data source и репозитория, что позволяет инжектировать их в контроллеры и виджеты по мере появления UI.

## Уведомления (`lib/src/features/notifications`)
- **Назначение**: отображение системных сообщений и советов от сервиса.
- **Data**:
  - `NotificationRemoteDataSource` — делает `GET /api/client/notifications`, возвращая массив `{id,title,message,is_read,created_at}`.
  - `NotificationLocalDataSource` — кеширует результат и снова отдаёт его при отсутствии сети.
  - `NotificationRepositoryImpl` — слушает удалённый источник, сохраняет кеш и отдает данные контроллеру.
  - `NotificationRemoteDataSource.deleteAllNotifications` — `DELETE /api/client/notifications/all` обнуляет весь список на сервере.
- **Domain**:
  - `UserNotification` — доменная модель с заголовком, текстом, датой и статусом прочитано.
  - `NotificationRepository` — контракт `fetchNotifications`/`saveNotifications`.
- **Presentation**:
  - `NotificationsController` — загружает уведомления, сортирует по дате, управляет выбором и удалением.
  - `NotificationsPage` — показывает список `NotificationTile` из контроллера, обновляется после синхронизации.
