# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application named "everglow_app" using Flutter SDK 3.9.2+. The project supports multiple platforms: Android, iOS, Linux, macOS, Windows, and Web.

## Architecture

### Clean Architecture (Feature-First)

This project follows **Clean Architecture** with a **Feature-First** approach. Each feature is self-contained with its own layers:

```
lib/
├── core/                    # Shared code across features
│   ├── error/              # Error handling, failures, exceptions
│   ├── network/            # Network utilities, API clients
│   ├── usecases/           # Base usecase classes
│   ├── utils/              # General utilities
│   └── widgets/            # Shared widgets
│
└── features/               # Feature modules
    └── feature_name/
        ├── data/
        │   ├── datasources/    # Remote/Local data sources
        │   ├── models/         # Data models (JSON serialization)
        │   └── repositories/   # Repository implementations
        ├── domain/
        │   ├── entities/       # Business objects
        │   ├── repositories/   # Repository interfaces
        │   └── usecases/       # Business logic/use cases
        └── presentation/
            ├── bloc/           # BLoC/Cubit state management
            ├── pages/          # Screen widgets
            └── widgets/        # Feature-specific widgets
```

### Layer Responsibilities

- **Domain Layer** (innermost): Pure Dart, no Flutter dependencies. Contains business logic, entities, and repository contracts.
- **Data Layer**: Implements domain repositories. Handles data from APIs, databases, or local storage. Models convert to/from domain entities.
- **Presentation Layer**: Flutter widgets, state management (BLoC/Cubit), and UI logic. Depends on domain layer only.

### Dependency Rule
Dependencies flow inward: Presentation → Domain ← Data. Domain layer has no dependencies on outer layers.

## Common Commands

### Development
- **Run the app**: `flutter run`
- **Run on specific device**: `flutter run -d <device_id>`
- **List available devices**: `flutter devices`
- **Hot reload**: Press `r` in terminal while app is running
- **Hot restart**: Press `R` in terminal while app is running

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
- **Full rebuild**: `flutter clean && flutter pub get && flutter run`

## Development Guidelines

### Code Style & Documentation

1. **All comments and documentation MUST be in English**
2. **Document all public APIs** with dartdoc comments (`///`)
3. **Use meaningful variable and function names** that are self-documenting
4. **Follow Flutter/Dart style guide** (enforced by flutter_lints)

### Always Act as a Flutter Senior Developer

When working in this codebase:

- **Think architecture-first**: Consider how changes fit into Clean Architecture layers
- **Prioritize testability**: Write testable code with proper dependency injection
- **Consider performance**: Be mindful of rebuilds, memory usage, and async operations
- **Use best practices**:
  - Const constructors where possible
  - Proper error handling with Either/Result types
  - Immutable entities and models
  - Repository pattern for data access
  - BLoC/Cubit for state management
  - Dependency injection (get_it, injectable, or riverpod)
- **Write production-ready code**: Handle edge cases, null safety, and error states
- **Review before committing**: Ensure code is clean, tested, and follows architecture

### Creating a New Feature

When adding a new feature, create the complete folder structure:

1. Create feature folder: `lib/features/feature_name/`
2. Create domain layer first (entities, repositories, usecases)
3. Create data layer (models, datasources, repository implementations)
4. Create presentation layer (pages, widgets, state management)
5. Write tests for each layer
6. Register dependencies in dependency injection container

### Testing Strategy

- **Unit tests** for domain usecases and business logic
- **Widget tests** for presentation layer components
- **Integration tests** for complete user flows
- **Mock external dependencies** (repositories, data sources)
- Aim for high coverage in domain and data layers

## Current State

The app currently contains only a basic skeleton with a "Hello World!" screen in `lib/main.dart`. The Clean Architecture structure needs to be implemented as features are added.

## Linting

Project uses `flutter_lints ^5.0.0` with default Flutter lint rules. Follow all lint suggestions and warnings.
