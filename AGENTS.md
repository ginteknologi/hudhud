# AGENTS.md

## Repository Guidelines & Instructions

### Flutter Version Management (FVM)
- **Always use FVM**: Every Flutter and Dart CLI operation must be invoked with `fvm`.
  - Use `fvm flutter ...` (e.g. `fvm flutter pub get`, `fvm flutter run`, `fvm flutter analyze`, `fvm flutter test`).
  - Use `fvm dart ...` for Dart commands.
- **Never invoke global Flutter or Dart directly**.
- FVM configuration is in `.fvmrc` and `.fvm/fvm_config.json`.
