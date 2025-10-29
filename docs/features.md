# Документация по фичам

## Авторизация (`lib/src/features/auth`)
- **Назначение**: двухшаговый вход по номеру телефона и OTP-коду.
- **Data**:
  - `AuthRemoteDataSource` — отправляет номер на `/auth/request-otp` и подтверждает код через `/auth/verify-otp`.
  - `AuthLocalDataSource` — сохраняет и читает текущую сессию в `SharedPreferences`.
  - `AuthSessionModel` — адаптер между JSON и доменной сущностью.
- **Domain**:
  - `AuthSession` — доменная модель с access/refresh токенами и телефоном.
  - `AuthRepository` — контракт, который реализует `AuthRepositoryImpl`.
- **Presentation**:
  - `AuthController` (`ChangeNotifier`) — управляет шагами (`phoneInput → otpInput → authenticated`) и хранит состояние.
  - `AuthPage` — экран с формами ввода телефона и OTP, отображает ошибки/индикатор загрузки.
- **DI**: регистрируется в `App` через `ProxyProvider`/`ChangeNotifierProvider`; после успешной верификации приложение переключается на `HomePage`.

## Домашние заметки (`lib/src/features/home`)
- **Назначение**: CRUD для локальных заметок пользователя.
- **Data**:
  - `NoteLocalDataSource` — хранит заметки в `SharedPreferences` (список JSON-строк).
  - `NoteModel` — модель для сериализации заметок.
- **Domain**:
  - `Note` — доменная сущность заметки.
  - `NoteRepository` — контракт, реализованный в `NoteRepositoryImpl`.
- **Presentation**:
  - `HomeController` — управляет загрузкой/добавлением/удалением заметок.
  - `HomePage` — список заметок и диалог создания новой записи.
  - `HomeEmptyState` — заглушка при отсутствии заметок.
- **Особенности**: данные хранятся локально; интеграция выполняется через DI в `App`.

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
