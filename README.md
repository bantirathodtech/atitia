# 🏢 Atitia - Enterprise PG Management SaaS Platform

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-Proprietary-red)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-blue)

**A production-ready, enterprise-grade SaaS platform for Paying Guest (PG) management, connecting property owners and guests through a seamless, role-based experience.**

[Features](#-features) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Role-Based Access Control](#-role-based-access-control)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Development Workflow](#-development-workflow)
- [CI/CD & Deployment](#-cicd--deployment)
- [Security & Compliance](#-security--compliance)
- [Performance & Scalability](#-performance--scalability)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

**Atitia** is a comprehensive, enterprise-grade SaaS platform designed to revolutionize the Paying Guest (PG) accommodation industry in India. Built with Flutter and leveraging modern cloud infrastructure, Atitia provides a seamless, scalable solution for property owners to manage their PG facilities while offering guests an intuitive platform to discover, book, and manage their accommodations.

### 🎯 Core Value Proposition

- **For PG Owners**: Complete property management suite with real-time analytics, automated booking workflows, payment tracking, and guest relationship management
- **For Guests**: Streamlined discovery, booking, payment, and service management experience with transparent communication channels
- **For the Platform**: Scalable SaaS architecture supporting multi-tenancy, role-based access control, and enterprise-grade security

### 🌟 Why Atitia?

- ✅ **Production-Ready**: Built with enterprise best practices, comprehensive error handling, and monitoring
- ✅ **Scalable Architecture**: Clean Architecture + MVVM pattern ensuring maintainability and testability
- ✅ **Multi-Platform**: Native iOS, Android, and Web support from a single codebase
- ✅ **Security-First**: End-to-end encryption, Firebase App Check, GDPR compliance
- ✅ **Performance Optimized**: Lazy loading, image caching, offline-first capabilities
- ✅ **Developer Experience**: Comprehensive tooling, automation scripts, and CI/CD pipelines

---

## ✨ Key Features

### 👥 Dual-Role System

#### 🏠 **Owner Dashboard**
- **Property Management**: Multi-PG support with flexible floor/room/bed configurations
- **Interactive Bed Allocation**: Visual floor plans with drag-and-drop bed assignment
- **Booking Management**: Approve/reject requests, track occupancy, manage check-ins/check-outs
- **Financial Analytics**: Revenue tracking, payment history, outstanding amounts, property-wise breakdowns
- **Guest Management**: Complete guest profiles, payment tracking, complaint resolution
- **Food Menu Management**: Weekly meal planning, special menus, photo galleries
- **Real-time Notifications**: Booking alerts, payment reminders, complaint notifications

#### 🎒 **Guest Dashboard**
- **PG Discovery**: Advanced search and filtering (location, price, amenities, availability)
- **Seamless Booking**: One-tap booking requests with real-time status tracking
- **Payment Management**: Secure payment processing, transaction history, payment reminders
- **Service Requests**: Complaint submission, bed change requests, food feedback
- **Profile Management**: KYC verification, emergency contacts, document management
- **Food Menu Access**: View weekly menus, meal timings, special announcements

### 🔐 Authentication & Security

- **Multi-Method Auth**: Phone OTP, Google Sign-In, Apple Sign-In
- **Role-Based Access Control**: Granular permissions for Owner and Guest roles
- **KYC Verification**: Aadhaar-based identity verification with document upload
- **Secure Storage**: Encrypted local storage for sensitive data
- **Firebase App Check**: Bot protection and API abuse prevention
- **GDPR Compliant**: Data privacy controls and user consent management

### 💳 Payment Integration

- **Razorpay Integration**: Secure payment gateway for rent and deposits
- **Payment Tracking**: Automated payment reminders, history, and receipts
- **Multi-Payment Support**: One-time, recurring, and partial payments
- **Financial Reporting**: Owner-side revenue analytics and guest-side payment history

### 🌍 Localization & Accessibility

- **Multi-Language Support**: English and Telugu (extensible to more languages)
- **RTL Support**: Right-to-left text support for international expansion
- **Accessibility**: WCAG AA compliant with semantic labels and screen reader support
- **Responsive Design**: Adaptive layouts for phones, tablets, and web

### 📊 Analytics & Monitoring

- **Firebase Analytics**: User behavior tracking and conversion funnels
- **Crashlytics**: Real-time crash reporting and error tracking
- **Performance Monitoring**: App performance metrics and optimization insights
- **Custom Telemetry**: Cross-role analytics for business intelligence

### 🔔 Notifications

- **Push Notifications**: Firebase Cloud Messaging for real-time updates
- **Local Notifications**: Offline-capable notification system
- **Notification Preferences**: User-configurable notification settings
- **Multi-Channel**: In-app, push, and email notifications

---

## 🏗️ Architecture

### Clean Architecture + MVVM Pattern

Atitia follows **Clean Architecture** principles with **MVVM (Model-View-ViewModel)** pattern, ensuring separation of concerns, testability, and maintainability.

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   View/UI    │  │   ViewModel   │  │   Provider    │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   Entities   │  │  Use Cases   │  │  Interfaces  │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Repositories │  │ Data Sources │  │    Models     │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                    Infrastructure Layer                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   Firebase   │  │   Supabase   │  │  Local DB    │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

1. **Dependency Injection**: GetIt for service locator pattern
2. **State Management**: Provider for reactive state management
3. **Navigation**: GoRouter for type-safe, declarative routing
4. **Repository Pattern**: Abstraction layer for data sources
5. **Use Cases**: Business logic encapsulation
6. **Error Handling**: Centralized error handling with custom exceptions
7. **Logging**: Structured logging with different log levels
8. **Offline Support**: Local caching with sync capabilities

---

## 🛠️ Technology Stack

### Core Framework
- **Flutter**: `3.0+` - Cross-platform UI framework
- **Dart**: `3.0+` - Programming language

### Backend & Cloud Services
- **Firebase Core**: Authentication, Firestore, Storage, Analytics
- **Firebase Auth**: Phone OTP, Google Sign-In, Apple Sign-In
- **Cloud Firestore**: NoSQL database for real-time data
- **Firebase Storage**: Media file storage
- **Firebase Cloud Messaging**: Push notifications
- **Firebase Analytics**: User behavior analytics
- **Firebase Crashlytics**: Crash reporting
- **Firebase Performance**: Performance monitoring
- **Firebase App Check**: API security
- **Supabase**: Cost-effective storage alternative for media files

### State Management & Dependency Injection
- **Provider**: State management and dependency injection
- **GetIt**: Service locator for dependency injection

### Navigation
- **GoRouter**: Declarative routing with type safety

### Networking & Storage
- **HTTP**: REST API communication
- **Flutter Secure Storage**: Encrypted local storage
- **Shared Preferences**: App preferences storage
- **Cached Network Image**: Image caching and optimization

### UI & Design
- **Material Design 3**: Modern Material Design components
- **Custom Theme System**: Adaptive light/dark themes
- **Responsive Design**: Breakpoint-based layouts
- **Shimmer**: Loading placeholders

### Payments
- **Razorpay Flutter**: Payment gateway integration

### Security & Encryption
- **Encrypt**: AES encryption for sensitive data
- **Crypto**: Cryptographic hashing

### Localization
- **Flutter Localizations**: Built-in i18n support
- **Intl**: Internationalization utilities

### Development Tools
- **Flutter Lints**: Code quality and linting
- **Build Runner**: Code generation
- **Mockito**: Testing mocks

### Testing
- **Flutter Test**: Unit and widget testing
- **Integration Test**: End-to-end testing

---

## 👥 Role-Based Access Control

Atitia implements a comprehensive **Role-Based Access Control (RBAC)** system with granular permissions for each role.

### Owner Permissions
- ✅ Manage PG properties (create, edit, delete)
- ✅ Approve/reject booking requests
- ✅ Assign rooms and beds
- ✅ View and manage guest information
- ✅ Process payments and view financial reports
- ✅ Manage complaints and service requests
- ✅ Publish and manage food menus
- ✅ View analytics and dashboards

### Guest Permissions
- ✅ Browse and search PG listings
- ✅ Submit booking requests
- ✅ View own bookings and payment history
- ✅ Submit complaints and service requests
- ✅ View food menus and submit feedback
- ✅ Request bed changes
- ✅ Manage profile and KYC documents

### Permission Enforcement
- **Route Guards**: Navigation guards prevent unauthorized access
- **UI Conditional Rendering**: Features hidden based on permissions
- **API-Level Validation**: Backend validates all permission checks
- **Audit Logging**: All permission checks are logged for security auditing

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: `3.0.0` or higher
- **Dart SDK**: `3.0.0` or higher
- **Android Studio** / **Xcode**: For platform-specific development
- **Firebase Account**: For backend services
- **Supabase Account**: For media storage (optional)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/atitia.git
   cd atitia
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in `android/app/` and `ios/Runner/` respectively
   - Run `flutterfire configure` to generate `firebase_options.dart`

4. **Configure Environment**
   - Copy `.secrets/common/.env.example` to `.secrets/common/.env`
   - Fill in your Firebase and API credentials
   - See [docs/guides/CREDENTIAL_STORAGE_GUIDE.md](docs/guides/CREDENTIAL_STORAGE_GUIDE.md) for details

5. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
```bash
cd android
./gradlew build
```

#### iOS
```bash
cd ios
pod install
```

#### Web
```bash
flutter build web --release
```

---

## 📁 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── app/                # App-level configuration
│   ├── config/             # Environment configuration
│   ├── db/                  # Database abstractions
│   ├── di/                  # Dependency injection
│   ├── interfaces/          # Service interfaces
│   ├── models/              # Core domain models
│   ├── monitoring/          # Error tracking & monitoring
│   ├── navigation/          # Navigation configuration
│   ├── providers/           # Global providers
│   ├── repositories/        # Data repositories
│   ├── services/            # Core services
│   ├── telemetry/           # Analytics & telemetry
│   └── viewmodels/          # Shared view models
│
├── feature/                 # Feature modules
│   ├── auth/                # Authentication feature
│   ├── guest_dashboard/     # Guest role features
│   │   ├── complaints/      # Complaint management
│   │   ├── foods/           # Food menu & feedback
│   │   ├── payments/        # Payment management
│   │   ├── pgs/             # PG discovery & booking
│   │   └── profile/         # Guest profile
│   └── owner_dashboard/     # Owner role features
│       ├── analytics/       # Business analytics
│       ├── foods/           # Food menu management
│       ├── guests/          # Guest management
│       ├── mypg/            # PG property management
│       └── overview/        # Owner dashboard
│
├── common/                  # Shared utilities
│   ├── animations/          # Reusable animations
│   ├── constants/           # App constants
│   ├── styles/              # Theme & styling
│   ├── utils/               # Utility functions
│   └── widgets/             # Reusable widgets
│
└── main.dart                # App entry point
```

### Architecture Principles

- **Feature-First Structure**: Features are self-contained modules
- **Separation of Concerns**: Clear boundaries between layers
- **Dependency Rule**: Inner layers don't depend on outer layers
- **Testability**: Each layer is independently testable

---

## 🔄 Development Workflow

### Code Quality

- **Linting**: `flutter analyze` - Static code analysis
- **Formatting**: `dart format .` - Consistent code style
- **Testing**: `flutter test` - Unit and widget tests

### Automation Scripts

We provide comprehensive automation scripts for common tasks:

```bash
# Setup environment
bash scripts/core/cli.sh setup

# Run diagnostics
bash scripts/core/cli.sh diagnose

# Build for all platforms
bash scripts/core/cli.sh build all

# Run tests with coverage
bash scripts/core/cli.sh test all yes

# Release build
bash scripts/core/cli.sh release all

# Deploy to stores
bash scripts/core/cli.sh deploy all
```

See [scripts/README.md](scripts/README.md) for complete automation toolkit documentation.

### Git Workflow

- **Main Branch**: Production-ready code
- **Feature Branches**: `feat/feature-name` for new features
- **Development Branch**: `updates` for ongoing development
- **Pull Requests**: Required for all changes with code review

---

## 🚢 CI/CD & Deployment

### Continuous Integration

- **GitHub Actions**: Automated testing and builds on every push
- **Multi-Platform Builds**: Android, iOS, and Web builds in parallel
- **Code Quality Checks**: Automated linting and formatting validation
- **Test Execution**: Unit, widget, and integration tests

### Continuous Deployment

- **Automated Releases**: Tag-based releases trigger deployment workflows
- **Store Deployment**: Automated uploads to Google Play and App Store
- **Firebase Hosting**: Automated web deployment
- **Artifact Management**: Build artifacts stored for 90 days

### Deployment Scripts

```bash
# Android release
bash scripts/release/release_android.sh both

# iOS release
bash scripts/release/release_ios.sh

# Web deployment
bash scripts/release/build_web.sh yes
```

See [docs/deployment/](docs/deployment/) for detailed deployment guides.

---

## 🔒 Security & Compliance

### Security Measures

- **End-to-End Encryption**: Sensitive data encrypted at rest and in transit
- **Firebase App Check**: Bot protection and API abuse prevention
- **Secure Storage**: Encrypted local storage using Flutter Secure Storage
- **Token Management**: Secure token storage and refresh mechanisms
- **Input Validation**: Comprehensive input sanitization and validation
- **SQL Injection Prevention**: Parameterized queries and Firestore security rules

### Compliance

- **GDPR Compliance**: User data privacy controls and consent management
- **Data Retention**: Configurable data retention policies
- **Audit Logging**: Comprehensive audit trails for security events
- **Access Controls**: Role-based access control with least privilege principle

### Security Best Practices

- Secrets stored in `.secrets/` directory (gitignored)
- Environment variables for sensitive configuration
- Regular security audits and dependency updates
- Secure coding practices enforced through linting

---

## ⚡ Performance & Scalability

### Performance Optimizations

- **Lazy Loading**: On-demand loading of features and data
- **Image Caching**: Intelligent image caching with size optimization
- **Code Splitting**: Feature-based code splitting for web
- **Memory Management**: Efficient memory usage with proper disposal
- **Build Optimization**: Obfuscation and minification for production

### Scalability Features

- **Multi-Tenancy**: Support for multiple PG owners and properties
- **Horizontal Scaling**: Cloud Firestore auto-scaling
- **CDN Integration**: Firebase Hosting CDN for static assets
- **Offline Support**: Local caching with sync capabilities
- **Performance Monitoring**: Real-time performance metrics

### Performance Metrics

- **App Size**: Optimized APK/IPA sizes
- **Startup Time**: < 2 seconds cold start
- **Frame Rate**: Consistent 60 FPS
- **Memory Usage**: Optimized for low-end devices

---

## 📚 Documentation

Comprehensive documentation is available in the `docs/` directory:

- **[Setup Guides](docs/guides/)**: Step-by-step setup instructions
- **[Deployment Guides](docs/deployment/)**: CI/CD and deployment documentation
- **[API Documentation](docs/)**: API reference and integration guides
- **[Architecture Docs](PROJECT_ORGANIZATION.md)**: Detailed architecture documentation

### Key Documentation Files

- [Automation Toolkit](docs/AUTOMATION_TOOLKIT.md) - Complete script documentation
- [Project Organization](PROJECT_ORGANIZATION.md) - Project structure guide
- [Deployment Guide](docs/deployment/DEPLOYMENT_GUIDE.md) - Deployment instructions
- [Security Guide](docs/guides/SECURE_CREDENTIALS_SETUP.md) - Security best practices

---

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feat/amazing-feature`
3. **Follow code style**: Run `dart format .` and `flutter analyze`
4. **Write tests**: Ensure all new features have test coverage
5. **Commit changes**: Use conventional commit messages
6. **Push to branch**: `git push origin feat/amazing-feature`
7. **Open a Pull Request**: Provide detailed description of changes

### Code Standards

- **Dart Style Guide**: Follow official Dart style guide
- **Flutter Best Practices**: Adhere to Flutter best practices
- **Test Coverage**: Maintain >80% test coverage
- **Documentation**: Document all public APIs

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **Firebase Team**: For robust backend infrastructure
- **Open Source Community**: For the excellent packages and tools

---

## 📞 Contact & Support

- **Project Maintainer**: Banti Rathod
- **Email**: bantirathodtech@gmail.com
- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/bantirathodtech/atitia/issues)

---

<div align="center">

**Built with ❤️ using Flutter**

[⬆ Back to Top](#-atitia---enterprise-pg-management-saas-platform)

</div>
