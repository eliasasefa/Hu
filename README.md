# Haramaya University App

A comprehensive Flutter application for Haramaya University students and staff, featuring web portal access, exit exam management, and secure authentication.

## Features

### 🔐 Authentication & Security
- **Email/Password Authentication**: Secure login and registration using Firebase Auth
- **Biometric Authentication**: Fingerprint and face recognition support for quick login
- **Settings Management**: Configure biometric authentication and account settings

### 📚 Exit Exam System
- **Exam Import**: Import exam questions via JSON files with department, year, and exam type
- **Dynamic Filtering**: Browse exams by department, year, and exam type
- **Exam Taking**: Take filtered exams with real-time progress tracking

### 🌐 Web Portal Access
- **Student Portal**: Access to student information systems
- **Old Portal**: Legacy student portal access
- **Dormitory Management**: Dormitory search and management
- **E-learning**: Online learning platform access
- **Registrar Office**: Administrative services
- **Freshman Program**: First-year student resources

### 🎨 User Interface
- **Modern Design**: Clean, responsive UI with Material Design
- **Dark/Light Theme**: Toggle between themes with system preference support
- **Cross-platform**: Works on Android, iOS, Web, Windows, macOS, and Linux

## Getting Started

### Prerequisites
- Flutter SDK (>=3.3.1)
- Firebase project setup
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase:
   - Add `google-services.json` for Android
   - Add `GoogleService-Info.plist` for iOS
   - Update `firebase_options.dart` with your Firebase configuration
4. Run `flutter run` to start the app

### Biometric Authentication Setup
1. Register or log in to your account
2. Navigate to Settings from the drawer menu
3. Toggle "Biometric Login" to enable
4. Enter your current password for verification
5. Complete biometric authentication (fingerprint/face)
6. Biometric login will be available for future sessions

### Importing Exam Questions
Use the following JSON format for importing exam questions:

```json
{
  "department": "Computer Science",
  "year": "2024",
  "examType": "Final",
  "questions": [
    {
      "question": "What is object-oriented programming?",
      "options": ["A", "B", "C", "D"],
      "correctAnswer": "A",
      "explanation": "OOP is a programming paradigm..."
    }
  ]
}
```

## Dependencies

- **Firebase**: Authentication, Firestore database
- **local_auth**: Biometric authentication
- **flutter_secure_storage**: Secure credential storage
- **file_picker**: JSON file import functionality
- **flutter_inappwebview**: Web portal integration

## Contributing

This project is developed for Haramaya University. For contributions or issues, please contact the development team.

## License

This project is proprietary software developed for Haramaya University.
