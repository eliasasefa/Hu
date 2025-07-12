# 🎓 Haramaya University Mobile App

[![Flutter](https://img.shields.io/badge/Flutter-3.3.1+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-orange.svg)](https://firebase.google.com/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/docs/deployment)

A comprehensive Flutter application designed for Haramaya University students and staff, providing seamless access to university services, exit exam management, and secure authentication.

## 📱 Screenshots

*[Add screenshots here - you can include images of the main dashboard, exam center, authentication screens, etc.]*

## ✨ Features

### 🔐 **Authentication & Security**
- **Firebase Authentication**: Secure email/password login and registration
- **Biometric Authentication**: Fingerprint and face recognition for quick access
- **Remember Me**: Persistent login sessions with secure storage
- **Theme Management**: Dark/Light mode with system preference support

### 📚 **Exit Exam System**
- **Exam Management**: Import and manage exam questions via JSON files
- **Department-based Organization**: Browse exams by department, year, and exam type
- **Real-time Exam Taking**: Interactive exam interface with progress tracking
- **Exam History**: View completed and in-progress exam attempts
- **Admin Features**: Import exam questions (admin-only functionality)

### 🌐 **University Portal Access**
- **Student Portal**: Direct access to student information systems
- **Old Portal**: Legacy student portal integration
- **Dormitory Management**: Search and manage dormitory information
- **E-learning Platform**: Access to online learning resources
- **Registrar Office**: Administrative services and forms
- **Freshman Program**: First-year student resources and information
- **Academic Calendar**: University calendar and important dates
- **Placement Services**: Career and placement information

### 🎨 **User Experience**
- **Responsive Design**: Optimized for all screen sizes and orientations
- **Modern UI**: Material Design with custom theming
- **Cross-platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **Offline Support**: Cached data for better performance
- **Accessibility**: Support for screen readers and accessibility features

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.3.1 or higher
- **Dart SDK**: Version 3.0 or higher
- **Firebase Project**: Set up with Authentication and Firestore
- **Development Environment**: Android Studio, VS Code, or your preferred IDE

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/hu-app.git
   cd hu-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   
   **For Android:**
   - Download `google-services.json` from Firebase Console
   - Place it in `android/app/`
   
   **For iOS:**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Place it in `ios/Runner/`
   
   **For Web:**
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Run the application**
   ```bash
   flutter run
   ```

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication with Email/Password provider
3. Create a Firestore database
4. Set up security rules for your collections:
   - `exit_exam_questions`
   - `user_exam_attempts`
5. Download configuration files and add them to your project

## 📋 Usage

### Authentication
1. Launch the app and create an account or log in
2. Enable "Remember Me" to stay signed in
3. Optionally enable biometric authentication in Settings

### Exit Exam System
1. Navigate to "Exit Exam" from the main dashboard
2. Browse available exams by department
3. Select an exam to start
4. Complete the exam and review results
5. View your exam history and progress

### Web Portal Access
1. Select any portal from the main dashboard
2. The app will open the portal in an embedded web view
3. Navigate through university services seamlessly

### Admin Features
- **Exam Import**: Use the admin account to import exam questions
- **JSON Format**: Follow the specified JSON structure for exam data

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
├── pages/
│   ├── auth/                 # Authentication pages
│   ├── navbar/               # Main navigation
│   ├── exit_exam/            # Exam system
│   ├── drawer_pages/         # Side drawer pages
│   ├── custom_widgets/       # Reusable widgets
│   └── splash/               # Splash screen
└── utils/                    # Utility functions
```

## 🔧 Configuration

### Environment Variables
- Firebase configuration is handled through `firebase_options.dart`
- No additional environment variables required

### Dependencies
Key dependencies include:
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `local_auth`: Biometric authentication
- `flutter_secure_storage`: Secure storage
- `file_picker`: File import functionality
- `flutter_inappwebview`: Web portal integration

## 🤝 Contributing

We welcome contributions to improve the Haramaya University app!

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test thoroughly**
5. **Commit your changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

### Development Guidelines

- Follow Flutter best practices and conventions
- Write clean, documented code
- Include tests for new features
- Update documentation as needed
- Ensure cross-platform compatibility

## 🐛 Bug Reports

If you encounter any issues:

1. Check existing issues in the GitHub repository
2. Create a new issue with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Device/OS information
   - Screenshots if applicable

## 📄 License

This project is proprietary software developed for Haramaya University. All rights reserved.

## 👥 Team

- **Developer**: Elias Asefa
- **Institution**: Haramaya University
- **Contact**: eliasasefa3@gmail.com

## 🙏 Acknowledgments

- Haramaya University for the opportunity to develop this application
- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and testers

---

**Made with ❤️ for Haramaya University**
