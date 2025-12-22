# Debt Tracker – Project Documentation

## What the app does
- Flutter mobile app that tracks money you are owed (receivables) and money you owe others (loans).
- Authenticates with Firebase Auth (email/password + Google) and stores user profiles in Firestore with avatars in Firebase Storage.
- Caches users/receivables locally with Isar so lists and detail screens can be read without re-fetching every time.
- Shows a tabbed experience: Home overview, Receivables (people who owe you), Loan (people you owe), and Profile.

## Code structure
- `lib/main.dart` initializes Firebase, prepares databases via `UserService.initlizeDataBase`, and wires up the `Provider` tree. Routes point to auth screens, the root navigator, the receivable form, and the profile page.
- `lib/root_screen.dart` holds the bottom navigation + `PageView` for Home, Receivables, Loan, and Profile; a FAB opens the receivable creation form when on the Receivables tab.
- Screens
  - `lib/screens/Auth/` → login (email/Google), registration (with image upload to Storage), and password reset flows.
  - `lib/screens/home_screen.dart` → loads receivables from the provider and computes totals, net balance, and participant counts.
  - `lib/screens/receivalbe_screen.dart` → groups receivables you created by participant, showing how much each person owes you; tapping opens a detail view.
  - `lib/screens/loan_screen.dart` → computes what you owe other creators and lists lenders; tapping opens a detail view.
  - `lib/screens/form/recievable_form_screen.dart` → builds a receivable by choosing users and splitting amounts equally or per person.
  - `lib/screens/inner screens/` → detail cards for a single counterpart (mark paid/received, delete, remove participant).
  - `lib/screens/profile_screen.dart` → displays the signed-in user and allows logout.
- Data layer
  - `lib/model/` → plain models for users, receivables, loans, and shared transaction metadata.
  - `lib/DataBase/` → repository interfaces plus Firebase and Isar implementations. Firestore collections: `Users`, `Receivables`, `Loans`.
  - `lib/services/` → orchestrate local/remote repos. `UserService` syncs profiles, `ReceivableService` manages creation, fetch, status updates, and participant removal while mirroring to Isar; `LoanService` listens to Firestore loans and mirrors locally.
  - `lib/providers/` → `ChangeNotifier` wrappers exposing lists and mutation methods to the UI (`ReceivableProvider`, `LoanProvider`, `UserProvider`).
- UI utilities and styling: `lib/widgets/` for shared typography and app bar; `lib/constant/` for theming and validation; `assets/` for illustration and placeholder images.

## How the main flows work
- **Authentication**
  - Login uses `FirebaseAuthService.signInWithEmail`; on success, it fetches the profile from Firestore and caches it locally.
  - Google sign-in delegates to `FirebaseAuthService.signInWithGoogle`; new Google users are created in Firestore/Isar.
  - Registration creates the Firebase user, uploads the avatar to Storage, then writes the profile to Firestore and Isar.
  - Forgot password triggers `sendPasswordReset` in Firebase Auth.
- **Receivable creation**
  - The form fetches all other users via `UserProvider.getAllUsers` (Firestore → Isar) and lets you select participants.
  - Amounts can be split equally or per person; arrays of `rate`, `isReceived`, and `isPaid` are built in the same order as the `participants` list (creator at index 0).
  - `ReceivableProvider.createReceivable` calls `ReceivableService`, which writes to Firestore and Isar.
- **Listing and grouping**
  - `ReceivableProvider.startListening` subscribes to Firestore snapshots; the in-memory list updates whenever remote data changes.
  - Home recomputes totals by scanning receivables and comparing the current user id to each participant slot:
    - creator (index 0) → money owed to you,
    - participant (index > 0) → money you owe someone else.
  - Receivables tab groups receivables you created by debtor and sums unpaid amounts.
  - Loan tab filters receivables where you are a participant (not creator) and groups by the lender (the creator).
- **Detail actions**
  - Receivable detail: creator can mark a debtor as received (`updateReceivedStatus`) or remove that user (`removeUserFromReceivable`); both update Firestore and Isar and refresh provider state.
  - Loan detail: participant can mark themselves as paid (`updatePaymentStatus`) or remove themselves from the receivable.
  - Deleting a receivable removes it in both stores via `deleteReceivable`.
- **Profile and logout**
  - `ProfileScreen` loads the cached profile (falls back to Firestore if needed) and displays avatar/contact info.
  - Logout signs out of Firebase Auth and Google, then routes back to login.

## Notes on data and sync
- Firestore is the source of truth; Isar mirrors for faster local reads and offline resilience. Services call `initializeDatabase` to ensure both layers are ready before operations.
- Lists are primarily driven by Firestore snapshot listeners (`watchReceivables` in the service/provider); manual refresh in the UI triggers `getAllReceivables` to re-fetch.
- Rates/flags arrays must stay aligned with the `participants` list—index math is used heavily when computing totals and statuses.

## Quick directory map
- `lib/` – Flutter app code (entrypoint, screens, providers, services, database adapters, widgets, constants).
- `assets/` – images for auth/empty states.
- `android/`, `ios/`, `web/` (if present) – platform boilerplate.
- `pubspec.yaml` – dependencies (Firebase, Isar, Provider, image picker, etc.) and asset registration.
