# DotaGiftX Mobile

Mobile platform for [dotagiftx.com](https://dotagiftx.com/) - Marketplace for Dota 2 Giftables. Items that can only be gifted or gift-once are probably belong here. If you are on Dota2Trade subreddit, it's basically the Giftable Megathread with a kick.

## 📱 Download

### From Google Play Store

[![Get it on Google Play](https://images.weserv.nl/?url=play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png&w=200)](https://play.google.com/store/apps/details?id=com.dotagiftx)

### From GitHub Releases

1. Go to the [Releases](https://github.com/tentenponce/dotagiftx-mobile/releases) section
2. Download the appropriate APK for your device architecture:
   - **arm64-v8a**: For most modern Android devices (64-bit ARM)
   - **armeabi-v7a**: For older Android devices (32-bit ARM)
   - **x86_64**: For Android emulators and x86 devices
   - **universal**: Works on all architectures (larger file size)

> **💡 Tip**: If you're unsure about your device architecture, download the universal APK.

### How to Install APK

1. Enable "Install from Unknown Sources" in your Android settings
2. Download the APK file
3. Open the downloaded file and follow the installation prompts

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK (3.29.3 or compatible)
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
     "appName": "app name here",
     "appId": "application ID for Android",
     "loginRedirectUrl": "login-redirect-url-for-steam-redirect",
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

- `make codegen` - Generate code using build_runner and intl_utils
- `make codeformat` - Analyze code formatting with Flutter analyzer
- `make codecov` - Generate comprehensive test coverage report

## 🧪 Testing

The project has comprehensive test coverage with **80+ test files** covering:

- **Domain Layer**: Use cases and business logic
- **Presentation Layer**: Cubit state management and UI logic
- **Integration Tests**: End-to-end functionality

Run tests and generate coverage report:

```bash
make codecov
```

The coverage report focuses on critical business logic:
- `lib/presentation/**/viewmodels/*` - State management logic
- `lib/domain/usecases/*` - Business use cases

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. Check the [Issues](https://github.com/tentenponce/dotagiftx-mobile/issues) tab
2. Look for issues tagged with `enhancement` or `good first issue`
3. Comment on the issue you'd like to work on
4. Fork the repository and create a new branch
5. Make your changes and submit a pull request

### Contribution Guidelines

- Follow the existing code style and conventions
- Write comprehensive tests for new features (we maintain high test coverage)
- Update documentation as needed
- Ensure all tests pass before submitting (`make codeformat` and `make codecov`)
- Use FVM for Flutter version management consistency

## 🏗️ Architecture

This project follows **Clean Architecture** principles with:

- **Presentation Layer**: UI components, Cubit state management, and states
- **Domain Layer**: Business logic, models, and use cases
- **Data Layer**: API clients, repositories, and data sources

## 📋 Requirements

- **Minimum Android Version**: API 26 (Android 8.0)
- **Target Android Version**: API 35 (Android 15)
- **Flutter Version**: 3.29.3 (managed via FVM)
- **Dart Version**: 3.7.2+

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🐛 Issues & Support

If you encounter any issues:

1. Check existing [Issues](https://github.com/tentenponce/dotagiftx-mobile/issues)
2. Create a new issue with detailed information including:
   - Device information and Android version
   - Flutter version (use `fvm flutter --version`)
   - Steps to reproduce the issue
   - Screenshots or logs if applicable

## 📞 Contact

For questions or support, please reach out through:

- GitHub Issues (preferred for bug reports and feature requests)
- Email: [poncetenten10@gmail.com](mailto:poncetenten10@gmail.com)

## 🙏 Acknowledgments

- Thanks to [Kudarap](https://github.com/kudarap), developer of [dotagiftx](https://github.com/kudarap/dotagiftx)!
