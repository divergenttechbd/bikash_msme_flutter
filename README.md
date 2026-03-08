# MSME SDK

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue.svg?style=for-the-badge)]()

A comprehensive Flutter SDK for integrating MSME (Micro, Small, and Medium Enterprises) Business Operation Platform into mobile applications with secure authentication and intuitive user interface.

## 📋 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Requirements](#-requirements)
- [Quick Start](#-quick-start)
- [API Reference](#-api-reference)
- [Examples](#-examples)
- [Testing](#-testing)
- [Changelog](#-changelog)
- [License](#-license)
- [Support](#-support)

## ✨ Features

- 🔐 **Secure PIN Authentication** - 4-digit PIN validation
- 🏦 **Banking Services** - Account management and operations
- 💳 **Payment Processing** - Send and receive payments
- 📄 **Invoice Management** - Bill and invoice tracking
- 📊 **Business Analytics** - Insights and reporting
- ⚙️ **Settings Management** - User preferences
- 🆘 **Support Integration** - Help and assistance

## 📦 Installation

### From pub.dev (Recommended)

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  msme_sdk: ^1.0.0
```

Or install it using the command line:

```bash
flutter pub add msme_sdk
```

### From GitHub Repository

You can also install directly from the GitHub repository:

#### Option 1: Using pubspec.yaml

Add the GitHub repository to your `pubspec.yaml` file:

```yaml
dependencies:
  msme_sdk:
    git:
      url: https://github.com/divergenttechbd/bikash_msme_flutter.git
      ref: main  # or specify a tag/commit hash
```

#### Option 2: Manual pubspec.yaml edit (Recommended for GitHub)

The most reliable way to install from GitHub is to manually edit your `pubspec.yaml` file:

1. Open your `pubspec.yaml` file
2. Add the following dependency:

```yaml
dependencies:
  msme_sdk:
    git:
      url: https://github.com/divergenttechbd/bikash_msme_flutter.git
      ref: main  # or specify a tag/commit hash
```

3. Run `flutter pub get` to install the package

#### Option 3: Specific version/tag

To install a specific version or tag, use the same method with a specific ref:

```yaml
dependencies:
  msme_sdk:
    git:
      url: https://github.com/divergenttechbd/bikash_msme_flutter.git
      ref: v1.0.0  # specific tag
```

Then run `flutter pub get` to install.

> **Note:** When installing from GitHub, make sure to specify the correct branch, tag, or commit hash using the `ref` parameter.

Then import the package in your Dart code:

```dart
import 'package:msme_sdk/msme_sdk.dart';
```

## 📋 Requirements

| Platform | Minimum Version |
|----------|-----------------|
| Dart     | `^3.10.7`       |
| Flutter  | `>=3.10.0`      |
| Android  | API Level 21+   |
| iOS      | iOS 11.0+       |

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:msme_sdk/msme_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSME SDK Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Demo')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => MSMEManager.launchSDK(context),
            child: const Text('Launch MSME Platform'),
          ),
        ),
      ),
    );
  }
}
```

### Complete Example

See the [Examples](#-examples) section for a full implementation.

## 📚 API Reference

### `MSMEManager`

The main entry point for the MSME SDK.

#### Methods

##### `launchSDK(BuildContext context) → void`

Launches the MSME SDK with PIN authentication screen.

**Parameters:**
- `context` - BuildContext for navigation

**Example:**
```dart
MSMEManager.launchSDK(context);
```

##### `validatePin(String pin) → bool`

Validates a 4-digit PIN.

**Parameters:**
- `pin` - 4-digit PIN string

**Returns:**
- `bool` - `true` if PIN is valid, `false` otherwise

**Example:**
```dart
final isValid = MSMEManager.validatePin('4444');
print(isValid); // true
```

##### `navigateToMenu(BuildContext context) → void`

Navigates directly to the main menu screen.

**Parameters:**
- `context` - BuildContext for navigation

**Example:**
```dart
MSMEManager.navigateToMenu(context);
```

## 💡 Examples

### Basic Integration

```dart
import 'package:flutter/material.dart';
import 'package:msme_sdk/msme_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MSME SDK Integration'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.business_center,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'MSME Business Platform',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Secure business operations at your fingertips',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => MSMEManager.launchSDK(context),
              icon: const Icon(Icons.launch),
              label: const Text('Launch Platform'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // Test PIN validation
                final result = MSMEManager.validatePin('4444');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('PIN Validation: ${result ? "Valid" : "Invalid"}'),
                    backgroundColor: result ? Colors.green : Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.security),
              label: const Text('Test PIN Validation'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Demo Information:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('• Default PIN: 4444'),
                  Text('• Features: Banking, Payments, Invoices'),
                  Text('• Analytics, Settings, Support'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Custom Integration with Error Handling

```dart
class CustomMSMEIntegration extends StatelessWidget {
  const CustomMSMEIntegration({super.key});

  Future<void> _launchWithValidation(BuildContext context) async {
    try {
      // Pre-validate PIN if needed
      const testPin = '4444';
      if (MSMEManager.validatePin(testPin)) {
        MSMEManager.launchSDK(context);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid PIN configuration'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching SDK: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _launchWithValidation(context),
      child: const Text('Launch with Validation'),
    );
  }
}
```

## 🧪 Testing

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:msme_sdk/msme_sdk.dart';

void main() {
  group('MSMEManager Tests', () {
    test('validatePin should return true for correct PIN', () {
      expect(MSMEManager.validatePin('4444'), isTrue);
    });

    test('validatePin should return false for incorrect PIN', () {
      expect(MSMEManager.validatePin('1234'), isFalse);
      expect(MSMEManager.validatePin('0000'), isFalse);
      expect(MSMEManager.validatePin('1111'), isFalse);
    });

    test('validatePin should handle invalid input', () {
      expect(MSMEManager.validatePin(''), isFalse);
      expect(MSMEManager.validatePin('123'), isFalse); // Too short
      expect(MSMEManager.validatePin('12345'), isFalse); // Too long
      expect(MSMEManager.validatePin('abcd'), isFalse); // Non-numeric
    });
  });
}
```

### Widget Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:msme_sdk/msme_sdk.dart';

void main() {
  testWidgets('MSME SDK should launch correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => MSMEManager.launchSDK(context),
                child: const Text('Launch SDK'),
              );
            },
          ),
        ),
      ),
    );

    // Verify the button exists
    expect(find.text('Launch SDK'), findsOneWidget);
    
    // Tap the button and trigger a frame
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify PIN page is displayed
    expect(find.text('Enter PIN'), findsOneWidget);
  });
}
```

## 📋 Additional Information

### Security Considerations

- PIN validation is performed client-side for demo purposes
- In production, implement server-side authentication
- PIN input is automatically sanitized and validated
- Failed attempts are logged and handled gracefully

### UI Customization

The SDK uses Material Design 3 with the following theme:

```dart
ThemeData(
  primaryColor: Colors.blue[800],
  scaffoldBackgroundColor: Colors.grey[100],
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### Performance

- Minimal memory footprint
- Efficient navigation using Flutter's Navigator
- Optimized widget rebuilds
- Smooth animations and transitions

## 📈 Changelog

### 1.0.0

**Released: March 5, 2026**

#### ✨ Added
- Initial release of MSME SDK
- Secure PIN authentication system
- Interactive main menu with service cards
- Banking, Payments, Invoices, Analytics, Settings, and Support modules
- Material Design 3 UI components
- Comprehensive API documentation
- Unit and widget test examples

#### 🐛 Fixed
- PIN input validation edge cases
- Navigation stack management
- Memory leak prevention

#### 🔧 Improved
- Error handling and user feedback
- Performance optimizations
- Code documentation and examples

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 MSME Platform

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 🤝 Support

### Getting Help

- 📧 **Email**: support@msme-platform.com
- 📱 **Phone**: +1-800-MSME-HELP
- 🌐 **Website**: [msme-platform.com](https://msme-platform.com)
- 📚 **Documentation**: [docs.msme-platform.com](https://docs.msme-platform.com)
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/divergenttechbd/bikash_msme_flutter/issues)

### Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Community

- 💬 **Discord**: [Join our Discord](https://discord.gg/msme-platform)
- 🐦 **Twitter**: [@MSMEPlatform](https://twitter.com/MSMEPlatform)
- 💼 **LinkedIn**: [MSME Platform](https://linkedin.com/company/msme-platform)

---

**Built with ❤️ by the MSME Platform Team**
