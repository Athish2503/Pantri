# Pantri 🍃

> A production-quality, multilingual smart pantry and grocery management app for families.

Pantri helps households track their kitchen inventory, automatically monitor low-stock items, and compile dynamic shopping lists effortlessly. Designed with clean architecture, robust state management, and an elder-friendly user interface, Pantri ensures accessible and scalable management for modern homes.

---

## 🌟 Key Features

- **Smart Inventory Tracking**: Filter inventory items by specific categories (Grains, Produce, Dairy, etc.) and update quantities in real-time.
- **Automated Shopping Lists**: Items hitting configurable threshold limits instantly populate the automated smart shopping list.
- **Elder-Friendly UI Design**: Engineered with high contrast text, easily legible typography scales, and accessible minimum touch targets (≥48dp).
- **Multilingual Support Ready**: Setup built to easily toggle app localizations seamlessly.
- **Firebase Setup Prepared**: Pre-configured data structures designed to stream real-time sync across household family members using Cloud Firestore.

---

## 🏗️ Folder Structure

```text
lib/
 ├── core/
 │   ├── constants/       # Global constants, static category definitions, layout variables
 │   ├── router/          # Declarative navigation tree built using go_router
 │   ├── theme/           # Customized Material 3 theme implementing fresh kitchen greens
 │   └── utils/           # Date formatters & internationalization helpers
 │
 ├── features/
 │   ├── auth/            # Security access flow modules (Sign In stub)
 │   ├── family/          # Synchronized multi-device household group setups
 │   ├── pantry/          # Core inventory feature layers (Domain state, Presentation screens)
 │   ├── settings/        # Preferences control screen including multilingual select
 │   └── shopping/        # Dynamic automated grocery generation views
 │
 ├── shared/
 │   ├── models/          # Immutable entities (PantryItem) serialized for Firestore integration
 │   ├── services/        # 3rd-party facade access definitions (FirebaseService)
 │   └── widgets/         # Reusable structural components (BottomNavigationScaffold)
 │
 └── main.dart            # Root provider bindings and app lifecycle initialization
```

---

## 🚀 Setup & Execution Instructions

### Prerequisites
- **Flutter SDK**: Version `^3.11.5` or stable equivalent.
- **Windows Users**: Ensure **Developer Mode** is enabled in system settings to support automatic creation of local package plugin symlinks during pub compilation. Run `start ms-settings:developers` to turn it on.

### Installation Steps

1. **Clone & Open Project Workspace**:
   Open the root repository directory inside your primary Flutter IDE.

2. **Fetch Dependencies**:
   Retrieve required packages configured within `pubspec.yaml`:
   ```bash
   flutter pub get
   ```

3. **Validate Architecture Cleanliness**:
   Perform static lint validation to confirm structured formatting:
   ```bash
   flutter analyze
   ```

4. **Run Application locally**:
   Launch optimized interface on connected Android devices or emulators:
   ```bash
   flutter run
   ```

---

## 🔥 Future Firebase Integration Roadmap

Production setups implementing remote sync functionality follow these designated hooks:

1. **Initialization Hook**:
   Uncomment `await Firebase.initializeApp();` setup directives located inside `lib/main.dart` and `lib/shared/services/firebase_service.dart`.
2. **Cloud Firestore Stream Replacements**:
   Substitute current static memory lists managed by Riverpod's `PantryNotifier` inside `lib/features/pantry/domain/pantry_provider.dart` with realtime subscription snapshots leveraging `FirebaseFirestore.instance.collection('households')`.
3. **Authentication Flows**:
   Attach valid sign-in actions inside `lib/features/auth/presentation/auth_screen.dart` to control access layers securely.
