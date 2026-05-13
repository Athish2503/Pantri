# Pantri: Setup & Deployment Instructions

Follow these step-by-step instructions to compile, run, and scale the Pantri application locally and in production environments.

---

## 🛠️ Phase 1: Local Development Setup

### 1. System Requirements
- **Flutter SDK**: Ensure `^3.11.5` compatibility. Verify setup status via terminal execution:
  ```bash
  flutter doctor
  ```
- **Windows OS Considerations**: Building projects configured with native platform integrations requires enabled developer symlinks. Navigate to system settings or run `start ms-settings:developers` to switch on **Developer Mode**.

### 2. Workspace Initialization
Clone or extract the source application directory. Open standard command line consoles at the project directory root:
```bash
cd d:\pantri
```

### 3. Dependency Compilation
Download configured packages referenced inside `pubspec.yaml`:
```bash
flutter pub get
```

### 4. Static Code Verification
Run project validation passes to verify zero package lint inconsistencies:
```bash
flutter analyze
```

### 5. Launch Simulator / Device
Boot the application view on dedicated hardware targets:
```bash
flutter run
```

---

## ☁️ Phase 2: Firebase Cloud Configuration

Pantri provides stubbing structures ready to interface with live Google Cloud Firestore and Authentication modules.

### Step 1: Create a Project
1. Navigate to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new cloud instance titled **Pantri-App**.

### Step 2: Register Application Platforms
- **Android**: Register standard package namespaces matching `pubspec.yaml` setups. Download generated `google-services.json` metadata configurations and place directly inside `android/app/`.
- **iOS / Web**: Provision appropriate matching configuration files (`GoogleService-Info.plist`) per target specs.

### Step 3: Implement Initializer Directives
Open `lib/main.dart` and uncomment startup initializations:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Activate cloud hook initialization
  runApp(const ProviderScope(child: PantriApp()));
}
```
