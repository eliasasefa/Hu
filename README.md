# 🎓 Hu+

[![Flutter](https://img.shields.io/badge/Flutter-3.3.1+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-orange.svg)](https://firebase.google.com/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/docs/deployment)

A comprehensive Flutter application designed for Haramaya University students and staff, providing seamless access to university services, exit exam management, and secure authentication.

## 📱 Screenshots
<img width="360" height="806" alt="Image 1" src="https://github.com/user-attachments/assets/57d43421-5cbf-4749-8e50-0c5bb7906507" />
<img width="360" height="806" alt="Image 2" src="https://github.com/user-attachments/assets/94d6d096-a150-48b0-a269-5742c047d60a" />
<img width="360" height="806" alt="Image 3" src="https://github.com/user-attachments/assets/6dc23680-709b-4002-b2fc-11b0761230eb" />
<img width="360" height="806" alt="Screenshot 20250710-131045" src="https://github.com/user-attachments/assets/1a424e33-aac6-4bab-90e2-18b9afb32035" />
<img width="360" height="806" alt="Screenshot_20250710-130754" src="https://github.com/user-attachments/assets/bbd29d9e-daee-46f3-86cc-3fb7104f034b" />
<img width="360" height="806" alt="Screenshot_20250710-130736" src="https://github.com/user-attachments/assets/8e17f541-598e-4324-a359-52cf5129d9b7" />
<img width="360" height="806" alt="Screenshot_20250710-130726" src="https://github.com/user-attachments/assets/f359d7cb-370f-4775-bc8e-748ca48f3ae0" />
<img width="360" height="806" alt="Screenshot_20250710-130657" src="https://github.com/user-attachments/assets/fcddbad4-07ce-48dc-a6ee-6b5b876878fa" />
<img width="360" height="806" alt="Screenshot_20250710-130920" src="https://github.com/user-attachments/assets/32326708-f2fc-4770-b513-a42af6263b45" />
<img width="360" height="806" alt="Screenshot_20250710-130930" src="https://github.com/user-attachments/assets/3f29a3d8-ea56-4e24-9709-d1de95044100" />
<img width="360" height="806" alt="Screenshot_20250710-130935" src="https://github.com/user-attachments/assets/76becb5e-7c35-4722-913a-2d64e16df08a" />
<img width="360" height="806" alt="Screenshot_20250710-130951" src="https://github.com/user-attachments/assets/b37fb3f3-d09f-4b54-bf60-1e9410fe82cf" />
<img width="360" height="806" alt="Screenshot_20250710-131000" src="https://github.com/user-attachments/assets/3e16d3d9-a74d-46cd-9555-2be3c2eebfd0" />
<img width="360" height="806" alt="Screenshot_20250710-131039" src="https://github.com/user-attachments/assets/2fe9c39e-107c-43b2-b333-d6c791bd0c45" />
<img width="360" height="806" alt="Screenshot_20250710-130847" src="https://github.com/user-attachments/assets/9c1142c5-4286-4b10-b615-1ef3bd13a8df" />
<img width="360" height="806" alt="Screenshot_20250710-133101" src="https://github.com/user-attachments/assets/118a516b-16e9-4003-ad5d-cda16964b1de" />
<img width="360" height="806" alt="Screenshot_20250710-130910" src="https://github.com/user-attachments/assets/2a84a8cf-64e9-42a3-b315-55ab9d1ab592" />
<img width="360" height="806" alt="Screenshot_20250710-131018" src="https://github.com/user-attachments/assets/48a857af-7bf1-421a-8c4a-f894e272b441" />





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
