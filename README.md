# DotaGiftX Mobile

Mobile platform for [dotagiftx.com](https://dotagiftx.com/) - Market place for Dota 2 Giftables, items that can only be gift or gift-once are probably belong here. If you are on Dota2Trade subreddit, its basically the Giftable Megathread with a kick.

## 📱 Download

### From Releases

1. Go to the [Releases](https://github.com/your-username/dotagiftx_mobile/releases) section
2. Download the appropriate APK for your device architecture:
   - **arm64-v8a**: For most modern Android devices (64-bit ARM)
   - **armeabi-v7a**: For older Android devices (32-bit ARM)
   - **x86_64**: For Android emulators and x86 devices
   - **universal**: Works on all architectures (larger file size)

> **💡 Tip**: If you're unsure about your device architecture, download the universal APK.

### How to Install

1. Enable "Install from Unknown Sources" in your Android settings
2. Download the APK file
3. Open the downloaded file and follow the installation prompts

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK (latest stable version)
- [FVM (Flutter Version Manager)](https://fvm.app/) (recommended)
- Android Studio or VS Code
- Git

### Environment Configuration

1. Create a `.env` directory in the project root
2. Copy the sample environment file:

   ```bash
   cp .env/sample-env.json .env/env.json
   ```

3. Configure the following environment variables in `.env/env.json`:

   ```json
   {
     "baseUrl": "your-api-base-url",
     "firebaseApiKey": "your-firebase-api-key",
     "firebaseAppId": "your-firebase-app-id",
     "firebaseProjectId": "your-firebase-project-id",
     "firebaseStorageBucket": "your-firebase-storage-bucket"
   }
   ```

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/tentenponce/dotagiftx-mobile.git
   cd dotagiftx-mobile
   ```

2. Install dependencies:

   ```bash
   fvm flutter pub get
   ```

3. Generate code:

   ```bash
   make codegen
   ```

4. Run the app:

   ```bash
   fvm flutter run --dart-define-from-file=.env/prod.json
   ```

   Or use your specific environment file:

   ```bash
   fvm flutter run --dart-define-from-file=.env/your-env.json
   ```

   Alternatively, you can run the app using any IDE that acknowledges `.vscode` settings (VS Code, Android Studio, etc.) - the launch configurations are already set up for you.

### Available Commands

- `make codegen` - Generate code using build_runner
- `make codeformat` - Analyze code formatting
- `make codecov` - Generate test coverage report

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. Check the [Issues](https://github.com/tentenponce/dotagiftx-mobile/issues) tab
2. Look for issues tagged with `enhancement`
3. Comment on the issue you'd like to work on
4. Fork the repository and create a new branch
5. Make your changes and submit a pull request

### Contribution Guidelines

- Follow the existing code style and conventions
- Write tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

## 🏗️ Architecture

This project follows Clean Architecture principles with:

- **Presentation Layer**: UI components, cubits, and states
- **Domain Layer**: Business logic, models, and use cases
- **Data Layer**: API clients, repositories, and data sources

### Key Dependencies

- **State Management**: Flutter Bloc/Cubit
- **Dependency Injection**: Injectable/GetIt
- **Network**: Dio
- **Firebase**: Analytics, Crashlytics, Remote Config
- **Local Storage**: Shared Preferences, Secure Storage

## 📁 Project Structure

```text
lib/
├── core/                 # Core utilities and infrastructure
├── data/                 # Data sources and repositories
├── domain/               # Business logic and models
├── presentation/         # UI components and state management
└── di/                   # Dependency injection configuration
```

## 🧪 Testing

Run tests with:

```bash
fvm flutter test
```

Generate coverage report:

```bash
make codecov
```

## 📋 Requirements

- **Minimum Android Version**: API 21 (Android 5.0)
- **Target Android Version**: API 34 (Android 14)
- **Flutter Version**: 3.7.2+
- **Dart Version**: 3.7.2+

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🐛 Issues & Support

If you encounter any issues:

1. Check existing [Issues](https://github.com/tentenponce/dotagiftx-mobile/issues)
2. Create a new issue with detailed information
3. Include device information, Flutter version, and steps to reproduce

## 📞 Contact

For questions or support, please reach out through:

- GitHub Issues
- Email: [poncetenten10@gmail.com](mailto:poncetenten10@gmail.com)

---
