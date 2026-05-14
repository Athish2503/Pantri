# Pantri 🍃

> A production-quality, multilingual smart pantry and grocery management app for families.

Pantri helps households track their kitchen inventory, automatically monitor low-stock items, and compile dynamic shopping lists effortlessly. Designed with clean architecture, robust state management, and an elder-friendly user interface, Pantri ensures accessible and scalable management for modern homes.

---

## 🌟 Key Features & Core Pantry Flow

- **Smart Inventory Tracking**: Filter inventory items by specific categories (**Rice & Grains, Spices, Oils, Snacks, Beverages, Vegetables, Cleaning, Misc**) and update quantities in real-time.
- **Stock Status Management**: Mark and track items as **Enough**, **Low**, or **Finished** instantly using dedicated accessible StatusChips. Includes recurring item tracking flags.
- **Live Search & Status Filtering**: Real-time multi-criteria filtering supports searching by text query and segmenting displays by stock deficit statuses.
- **Automated Shopping Lists**: Items transitioning to **Low** or **Finished** stock status automatically trigger seamless addition to the active shopping trip planner.
- **Duplicate Prevention**: State engine guarantees zero duplicate shopping list entries occur during dynamic additions.
- **Local Persistence caching**: Leverages robust local disk cache (`shared_preferences`) ensuring offline state preservation across user app sessions.
- **Elder-Friendly UI Design**: Engineered with high contrast text, easily legible typography scales, and accessible minimum touch targets (≥48dp).

---

## 🏛️ Architecture Notes & Decisions

- **Layered Feature-Driven Segregation**: Application capabilities map cleanly into independent top-level feature containers isolating data layers from UI layout elements.
- **Repository Pattern Mediation**: Dedicated `PantryRepository` abstracts low-level reads/writes from the underlying client storage engines, supporting easy testability and clean swapping for Cloud Firestore streams.
- **Reactive State Flow (Riverpod 2.x)**: Uses `AsyncNotifier` paradigms to systematically expose loading, error, and fully loaded state variants cleanly to UI widgets. Computed providers join parameters like search string filters dynamically without modifying source lists.
- **Immutability First**: State records are modified purely via immutable functional transformations (`copyWith`) avoiding unpredictable side-effects.

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
 │   ├── models/          # Immutable entities (PantryItem) serialized for persistence
 │   ├── services/        # 3rd-party facade access definitions
 │   └── widgets/         # Reusable structural components (EmptyStateWidget)
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

## 🔥 Next Development Steps & Integration Roadmap

1. **Firebase Real-Time Streams Integration**:
   Substitute current local repository implementations with distributed Firebase Firestore streams to enable seamless live sync across separate family devices.
2. **User Authentication Module Integration**:
   Hook up real credential management inside `auth_screen.dart` to securely bind separate pantries to validated family accounts.
3. **Background Push Notifications**:
   Attach localized smart alerts to remind users of soon-to-expire items or pending low stock thresholds proactively.
