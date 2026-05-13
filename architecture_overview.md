# Pantri: Architectural Overview & Design Decisions

As a production-ready utility framework designed for family-wide synchronization, Pantri adheres to strict clean code modularity. This document outlines the rationale guiding our component hierarchy, data management flows, and structural trade-offs.

---

## 🏛️ 1. Layered Feature-Driven Architecture

To prevent monolithic state congestion, Pantri separates source code primarily by **Features**, sub-categorized internally by functional responsibilities:

```text
features/pantry/
 ├── data/           # Mock seeds and API translation adapters
 ├── domain/         # State definitions, business logic rules, and Riverpod Notifiers
 └── presentation/   # Declarative screen rendering and reactive event dispatchers
```

### Rationale:
- **Scalability**: New application capabilities (e.g., Barcode Scanning, Receipt Parsing) can be embedded as dedicated top-level feature directories without cross-polluting existing inventory mechanics.
- **Maintainability**: Clear architectural grouping supports rapid onboarding for new engineers. Domain boundaries remain isolated, ensuring presentation code remains thin and agnostic of persistent data mechanics.

---

## ⚡ 2. State Management via Riverpod 2.x

Pantri utilizes `flutter_riverpod` directly across its data access pipelines:

- **Explicit Notifiers**: Modifying items requires direct interaction through functional operations (`addItem`, `incrementQuantity`) managed by the `PantryNotifier` class.
- **Computed Reactive Filtering**: Providers such as `filteredPantryProvider` and `lowStockItemsProvider` automatically recalculate lists reactively when users shift category filters or change inventory quantities.

### Rationale:
- **Decoupled Reactivity**: Rebuilding layouts happens selectively at leaf widget nodes using `Consumer` or `ConsumerWidget`. This avoids performance hits associated with global state updates.
- **Simplicity Over Cleverness**: We avoid overengineered stream orchestrators. Providers act as standard variables that can easily be mocked or swapped for persistent Cloud Firestore Streams when deploying backend services.

---

## 👴 3. Accessibility & Elder-Friendly UI Design

Grocery trackers are frequently used by older family members. The interface enforces accessible standards natively:

- **Typography Sizing**: Text scales provide high-contrast color choices (`#1B5E20` on light green backgrounds) ensuring optimal reading contrast under bright kitchen lighting.
- **Enhanced Touch Targets**: Quick-adjust interactive increment/decrement counters utilize minimum touch boundary sizes of `48x48dp` to minimize input friction.
- **Flatter Navigation**: Persistent tabs managed through `go_router`'s `StatefulNavigationShell` prevent disorientation. Users never lose internal tab input state when switching contexts.

---

## 🗄️ 4. Serialization & Data Models

Entities such as the `PantryItem` class are written immutably using core Dart definitions.

```dart
class PantryItem {
  // Implements copyWith for predictable functional updates
  // Implements toMap / fromMap preparing seamless Firebase Cloud Firestore integration
}
```

### Rationale:
- Keeps runtime footprint minimal and ensures data integrity. Avoids dependency overheads of reflection-based generator codebases during basic project scaffolding.
