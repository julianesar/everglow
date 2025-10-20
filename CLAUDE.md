# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

### Clean Architecture (Feature-First)

This project follows **Clean Architecture** with a **Feature-First** approach. Each feature is self-contained with its own layers.

**CRITICAL: This is the ACTUAL project structure. ALWAYS follow this exact structure:**

```
lib/
├── core/                           # Shared infrastructure across features
│   ├── database/                   # Database providers (Isar)
│   │   └── isar_provider.dart
│   ├── network/                    # Network clients and API services
│   │   ├── dio_provider.dart
│   │   ├── api_keys.dart
│   │   ├── ai_report_service.dart
│   │   └── ai_report_service_provider.dart
│   ├── router/                     # App routing configuration
│   │   └── app_router.dart
│   ├── services/                   # Shared services
│   │   ├── audio_player_service.dart
│   │   └── notification_service.dart
│   ├── theme/                      # App theme and styling
│   │   └── app_theme.dart
│   ├── widgets/                    # Shared UI components
│   │   ├── completion_chip.dart
│   │   └── confetti_celebration.dart
│   ├── error/                      # Error handling utilities
│   ├── utils/                      # General utilities
│   └── constants/                  # App-wide constants
│
├── features/                       # Feature modules (Feature-First)
│   ├── journal/                    # Journal and daily log feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── daily_log_model.dart
│   │   │   │   └── journal_entry_model.dart
│   │   │   └── repositories/
│   │   │       └── journal_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── journal_repository.dart
│   │   └── presentation/          # (empty - no UI specific to journal)
│   │
│   ├── user/                       # User entity and management
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── user_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── user_repository.dart
│   │   └── presentation/          # (empty for now)
│   │
│   ├── user_profile/               # Medical and concierge profiles
│   │   ├── data/
│   │   │   └── models/
│   │   │       └── user_profile_model.dart
│   │   └── presentation/          # (empty for now)
│   │
│   ├── daily_journey/              # Daily itineraries and practices
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── daily_journey_models.dart
│   │   │   └── repositories/
│   │   │       └── daily_journey_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── daily_journey_repository.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── daily_journey_controller.dart
│   │       ├── pages/
│   │       │   └── day_screen.dart
│   │       └── widgets/
│   │           ├── guided_practice_widget.dart
│   │           ├── journal_prompt_dialog.dart
│   │           └── timeline_navigator.dart
│   │
│   ├── onboarding/                 # User onboarding flow
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       ├── onboarding_repository_impl.dart
│   │   │       └── onboarding_repository_provider.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── onboarding_question.dart
│   │   │   │   └── onboarding_section.dart
│   │   │   └── repositories/
│   │   │       └── onboarding_repository.dart
│   │   └── presentation/
│   │       └── pages/
│   │           └── onboarding_screen.dart
│   │
│   ├── report/                     # AI-generated reports
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── ai_report_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── ai_report_repository.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── report_controller.dart
│   │       └── pages/
│   │           └── report_screen.dart
│   │
│   ├── hub/                        # Transformation hub screen
│   │   └── presentation/
│   │       └── pages/
│   │           └── hub_screen.dart
│   │
│   └── splash/                     # Splash screen and progress tracking
│       ├── data/
│       │   └── repositories/
│       │       └── progress_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── journey_status.dart
│       │   └── repositories/
│       │       └── progress_repository.dart
│       └── presentation/
│           └── pages/
│               └── splash_screen.dart
│
└── main.dart                       # App entry point
```

### Layer Responsibilities

- **Domain Layer** (innermost): Pure Dart, no Flutter dependencies. Contains business logic, entities, and repository contracts (interfaces).
- **Data Layer**: Implements domain repositories. Handles data from APIs, databases, or local storage. Models are used for serialization (Isar, JSON).
- **Presentation Layer**: Flutter widgets, state management (Riverpod), and UI logic. Depends on domain layer only.

### Dependency Rule

**CRITICAL**: Dependencies flow inward: `Presentation → Domain ← Data`. Domain layer has NO dependencies on outer layers.

**Import Guidelines:**
- Presentation layer CAN import from: `domain/repositories`, `domain/entities`, BUT NEVER from `data/`
- Data layer CAN import from: `domain/repositories`, `domain/entities`, `core/`
- Domain layer CANNOT import from: `data/`, `presentation/`, feature-specific code
- Use repository interfaces (domain) in presentation, NOT implementations (data)

### State Management

This project uses **Riverpod** for state management:
- Use `@riverpod` annotation for providers
- Controllers use `AsyncNotifier` or `Notifier` classes
- Repository providers use `@riverpod Future<Repository>`

### Database

This project uses **Isar** for local persistence:
- Models are Isar collections (annotated with `@collection`)
- All Isar schemas are registered in `core/database/isar_provider.dart`
- Models include both the entity logic and persistence annotations (pragmatic approach)

## Common Commands

### Development
- **Run the app**: `flutter run`
- **Run on specific device**: `flutter run -d <device_id>`
- **List available devices**: `flutter devices`
- **Hot reload**: Press `r` in terminal while app is running
- **Hot restart**: Press `R` in terminal while app is running

### Code Generation
- **Generate code**: `dart run build_runner build --delete-conflicting-outputs`
- **Watch mode**: `dart run build_runner watch --delete-conflicting-outputs`

### Building
- **Build for Android**: `flutter build apk` or `flutter build appbundle`
- **Build for iOS**: `flutter build ios`
- **Build for Web**: `flutter build web`
- **Build for Windows**: `flutter build windows`
- **Build for macOS**: `flutter build macos`
- **Build for Linux**: `flutter build linux`

### Testing
- **Run all tests**: `flutter test`
- **Run specific test file**: `flutter test test/path/to/test_file.dart`
- **Run tests with coverage**: `flutter test --coverage`
- **Run integration tests**: `flutter test integration_test`

### Code Quality
- **Analyze code**: `flutter analyze`
- **Format code**: `flutter format .`
- **Format specific file**: `flutter format lib/path/to/file.dart`

### Dependencies
- **Get dependencies**: `flutter pub get`
- **Upgrade dependencies**: `flutter pub upgrade`
- **Add new package**: `flutter pub add <package_name>`
- **Add dev dependency**: `flutter pub add -d <package_name>`

### Clean Build
- **Clean build artifacts**: `flutter clean`
- **Full rebuild**: `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs && flutter run`

## Development Guidelines

### Code Style & Documentation

1. **All comments and documentation MUST be in English**
2. **Document all public APIs** with dartdoc comments (`///`)
3. **Use meaningful variable and function names** that are self-documenting
4. **Follow Flutter/Dart style guide** (enforced by flutter_lints)

### Always Act as a Flutter Senior Developer

When working in this codebase:

- **Think architecture-first**: Consider how changes fit into Clean Architecture layers
- **Respect the Feature-First structure**: Keep features self-contained
- **Prioritize testability**: Write testable code with proper dependency injection
- **Consider performance**: Be mindful of rebuilds, memory usage, and async operations
- **Use best practices**:
  - Const constructors where possible
  - Proper error handling with try-catch and meaningful error messages
  - Immutable entities and models where appropriate
  - Repository pattern for ALL data access
  - Riverpod for state management and dependency injection
  - Always use repository interfaces (domain) in presentation, NOT implementations
- **Write production-ready code**: Handle edge cases, null safety, and error states
- **Review before committing**: Ensure code is clean, tested, and follows architecture

### Always Act as a UI/UX Expert

When creating or modifying any user interface:

- **Follow the App Theme**: ALWAYS reference and strictly follow the design system defined in `lib/core/theme/app_theme.dart`
- **Maintain visual coherence and professionalism**:
  - Use only the defined color palette (Deep Charcoal, Subtle Gold, Soft Cream, Muted Grey)
  - Apply the correct typography (Lora for headlines/titles, Satoshi for body/labels)
  - Follow the established spacing, border radius, and elevation patterns
  - Use theme-defined component styles (buttons, cards, inputs, etc.)
- **Never hardcode colors or typography**: Always use `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`
- **Apply "Silent Luxury" aesthetic**:
  - Minimalist, refined, and sophisticated design
  - Subtle interactions and transitions
  - Generous whitespace and breathing room
  - No bright or garish colors
  - Elegant animations with appropriate durations (200-300ms for subtle effects)
- **Ensure accessibility**:
  - Sufficient color contrast (already handled by theme)
  - Appropriate touch targets (minimum 48x48 logical pixels)
  - Semantic widgets and screen reader support
  - Support for different text scaling factors
- **Responsive design**: Consider different screen sizes and orientations
- **Consistency is paramount**: Every screen should feel like part of the same cohesive application

### Creating a New Feature

When adding a new feature, **ALWAYS** follow this exact structure:

1. **Create feature folder**: `lib/features/feature_name/`

2. **Create domain layer first** (pure business logic):
   ```
   lib/features/feature_name/domain/
   ├── entities/              # Business objects (if needed)
   ├── repositories/          # Repository interfaces (contracts)
   └── usecases/              # Business logic (if complex enough)
   ```

3. **Create data layer** (implementation):
   ```
   lib/features/feature_name/data/
   ├── models/                # Data models (Isar collections, JSON serialization)
   ├── datasources/           # Remote/Local data sources (if needed)
   └── repositories/          # Repository implementations (suffix: _impl.dart)
   ```

4. **Create presentation layer** (UI):
   ```
   lib/features/feature_name/presentation/
   ├── controllers/           # Riverpod controllers/notifiers
   ├── pages/                 # Full screen widgets
   └── widgets/               # Reusable feature-specific widgets
   ```

5. **Generate code**: Run `dart run build_runner build --delete-conflicting-outputs`

6. **Write tests** for each layer

7. **Dependencies are auto-registered** via Riverpod providers

### File Naming Conventions

- **Models**: `{entity_name}_model.dart` (e.g., `user_model.dart`)
- **Entities**: `{entity_name}.dart` (e.g., `user.dart`)
- **Repository interfaces**: `{name}_repository.dart` (e.g., `user_repository.dart`)
- **Repository implementations**: `{name}_repository_impl.dart` (e.g., `user_repository_impl.dart`)
- **Controllers**: `{feature_name}_controller.dart` (e.g., `daily_journey_controller.dart`)
- **Screens/Pages**: `{name}_screen.dart` or `{name}_page.dart` (e.g., `onboarding_screen.dart`)
- **Widgets**: Descriptive names ending in `_widget.dart` if generic (e.g., `guided_practice_widget.dart`)

### Part Directives for Code Generation

Always include the correct `part` directive for generated files:

```dart
// In repository implementations
part '{filename}_impl.g.dart';

// In models
part '{model_name}_model.g.dart';

// In controllers
part '{controller_name}.g.dart';
```

### Testing Strategy

- **Unit tests** for domain usecases and business logic
- **Widget tests** for presentation layer components
- **Integration tests** for complete user flows
- **Mock external dependencies** (repositories, data sources)
- Aim for high coverage in domain and data layers

## Current Features

The application currently has the following features implemented:

1. **journal**: Daily logs and journal entries
2. **user**: User entity and management
3. **user_profile**: Medical profile and concierge preferences
4. **daily_journey**: Daily itineraries with guided practices
5. **onboarding**: Multi-section onboarding flow
6. **report**: AI-generated transformation reports
7. **hub**: Transformation hub for completed journeys
8. **splash**: Splash screen with intelligent routing

## Linting

Project uses `flutter_lints ^5.0.0` with default Flutter lint rules. Follow all lint suggestions and warnings.

## Important Reminders

- **NEVER** create files outside the feature-first structure
- **NEVER** put shared code in feature folders (use `core/` instead)
- **NEVER** import data layer implementations in presentation layer
- **ALWAYS** run code generation after creating/modifying models or providers
- **ALWAYS** respect the dependency rule (inward dependencies only)
- **ALWAYS** follow the exact folder structure documented above
