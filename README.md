# 👨‍👩‍👧‍👦 Family Travel Document Management App

A beautiful Flutter application for managing family members and their travel documents with real-time expiry status tracking.

## 📱 Features

### ✅ Core Features (Implemented)
- **Family Members Management**: Create and manage family members with name, age, and relation
- **Document Upload**: Upload multiple documents per family member  
- **Camera & Gallery Support**: Capture new photos or select existing images for documents
- **Real-time Expiry Status**: Automatic calculation and color-coded badges:
  - 🟢 **VALID** (Green) - More than 6 months remaining
  - 🟡 **EXPIRING SOON** (Yellow) - Within 6 months
  - 🔴 **EXPIRED** (Red) - Already expired
- **Beautiful Modern UI**: Gradient backgrounds, smooth animations, and card-based design
- **Form Validation**: Complete validation for all input fields
- **State Management**: Provider pattern for efficient state management

### 🎨 UI/UX Highlights
- Modern gradient color scheme (Purple to Pink)
- Smooth Hero animations for transitions
- Card-based design with shadows and borders
- Responsive and intuitive interface
- Custom badges and status indicators

## 🚀 How to Run

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Android Studio / VS Code with Flutter plugins
- Android device or emulator / iOS device or simulator

### Installation Steps

1. **Clone or Extract the Project**
   ```bash
   cd family_travel_app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

4. **Build APK** (Optional)
   ```bash
   flutter build apk --release
   ```
   APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## 📦 Dependencies Used

- **provider** ^6.1.5+1 - State management
- **image_picker** ^1.2.1 - Camera and gallery access
- **intl** ^0.20.2 - Date formatting
- **permission_handler** ^12.0.1 - Runtime permissions handling

## 📂 Project Structure

```
lib/
├── models/
│   ├── member_model.dart      # Family member data model
│   └── document_model.dart    # Document data model with expiry logic
├── providers/
│   └── family_provider.dart   # State management provider
├── screens/
│   ├── home_screen.dart       # Family members list
│   ├── add_member_screen.dart # Add new member form
│   ├── member_documents_screen.dart  # Documents list for member
│   └── add_document_screen.dart      # Add document with image picker
└── main.dart                  # App entry point
```

## 🎯 Usage Guide

### Adding a Family Member
1. Tap the **"Add Member"** floating button on home screen
2. Fill in the member details:
   - Full Name (required, minimum 2 characters)
   - Age (required, 1-120)
   - Relation (dropdown selection)
3. Tap **"Save Member"**

### Adding a Document
1. Select a family member from the home screen
2. Tap the **"Add Document"** floating button
3. Fill in document details:
   - Select document type from dropdown
   - Enter/edit document name
   - Select issue date
   - Select expiry date
   - Add image (camera or gallery)
4. Tap **"Save Document"**

### Understanding Expiry Status
- Documents are automatically evaluated based on expiry date
- Status badges appear next to each document name
- Color coding helps quick identification:
  - Green = Safe to travel
  - Yellow = Renewal needed soon
  - Red = Expired, urgent action required

## 🔐 Permissions

The app requires the following permissions:
- **Camera** - To capture document photos
- **Storage/Photos** - To select images from gallery

Permissions are requested at runtime when needed.

## 💾 Data Storage

Currently using **in-memory storage** (Provider state management).
- Data will be lost when app is closed
- Perfect for demonstration and testing
- Can be easily upgraded to:
  - Local persistence (SQLite, Hive, Shared Preferences)
  - Cloud storage (Firebase, Supabase)

## 🎓 Technical Highlights

- **Clean Architecture**: Separation of models, providers, and UI
- **Provider Pattern**: Efficient state management with ChangeNotifier
- **Form Validation**: Comprehensive input validation
- **Date Handling**: Smart expiry calculation logic
- **Image Handling**: Async image picking with error handling
- **Responsive Design**: Adapts to different screen sizes
- **Modern Flutter**: Uses Material 3 design system

## 🤝 Assumptions Made

1. **Dates**: All calculations based on device's local time
2. **6 Months Rule**: Calculated as 180 days for simplicity
3. **Image Storage**: Images stored as File paths (in-memory)
4. **Single User**: App designed for single device usage
5. **No Deletion**: No delete functionality to maintain simplicity
6. **Roman Urdu Comments**: Code comments in English for universal understanding

## 📱 Screenshots

(Add screenshots here if needed)

## 👨‍💻 Developer

**Assignment**: Flutter Technical Home Assignment (Beginner Level)  
**Time Taken**: [Your time]  
**Level**: Demonstrating intermediate-to-advanced UI/UX skills

## 📄 License

This project is created for educational and assessment purposes.

---

**Note**: This is a demonstration project showcasing Flutter fundamentals, state management, form handling, image picker integration, and modern UI/UX design principles.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
