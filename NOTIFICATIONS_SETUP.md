# Push Notifications – What You Need to Implement

This doc lists everything required to send app (push) notifications to the Recipe Book app.

---

## Send a test notification from Firebase Console

1. **Get your device FCM token**  
   Run the app, allow notifications, and get the token (e.g. add a temporary `debugPrint(await NotificationService.instance.getToken());` in `main.dart` after `NotificationService.initialize()`, or log it in `NotificationService._sendTokenToServer`). Copy the printed token.

2. **Open Firebase Console**  
   [console.firebase.google.com](https://console.firebase.google.com) → select your project.

3. **Create a test message**  
   - Go to **Engage** → **Messaging** (or **Build** → **Cloud Messaging**).  
   - Click **Create your first campaign** or **New campaign**.  
   - Choose **Firebase Notification messages**.

4. **Compose and send test**  
   - Enter **Notification title** and **Notification text**.  
   - Click **Send test message**.  
   - Paste your **FCM token** (from step 1) and click **Test**.

The device should receive the notification. No code changes are required for this; use only the Firebase Console.

---

## 1. Flutter app (already done in this project)

- **Firebase**
  - `firebase_core` and `firebase_messaging` in `pubspec.yaml`
  - `Firebase.initializeApp()` and `NotificationService.initialize()` in `main.dart`
  - Background handler registered: `FirebaseMessaging.onBackgroundMessage(...)`

- **Notification service** (`lib/services/notification_service.dart`)
  - Requests notification permission (iOS + Android 13+)
  - Gets FCM token and listens for token refresh
  - Sends token to your backend via `ApiEndpoints.registerFcmToken`
  - Handles: foreground messages, notification tap (background + terminated)

- **Android**
  - `POST_NOTIFICATIONS` permission (Android 13+)
  - Default notification channel id in `res/values/strings.xml` and `AndroidManifest.xml`

- **API constant**
  - `lib/constants/api.dart`: `registerFcmToken` = `$customAPIbaseUrl/register-fcm-token`

You still need to implement the backend and configure Firebase/Apple for sending.

---

## 2. Firebase Console

1. **Project**
   - Use the same Firebase project that has `google-services.json` / `GoogleService-Info.plist` (and `firebase_options.dart`).

2. **Cloud Messaging**
   - Firebase Cloud Messaging is enabled by default.
   - No extra switch needed for receiving; you need it for **sending** from your server.

3. **Service account for sending (FCM HTTP v1)**  
   - Project Settings (gear) → **Service accounts** → **Generate new private key** (JSON).  
   - In **WordPress**: **Settings → Recipe Book** → paste the full JSON into **FCM Service Account JSON (v1)** → Save.  
   - The Recipe Book plugin uses this to send notifications when a new recipe is published (no legacy server key).

4. **iOS (if you support iPhone)**
   - In Firebase: Project Settings → Your iOS app → Upload **APNs key** (or certificate).
   - Create key in Apple Developer: Certificates, Identifiers & Profiles → Keys → APNs.
   - Without this, FCM cannot deliver to iOS devices.

---

## 3. Backend (WordPress / your API)

The app calls:

- **POST** `https://project.astranix.com.np/wp-json/v1/register-fcm-token`  
  (or whatever you set in `ApiEndpoints.registerFcmToken`)

**Request body (JSON):**

```json
{
  "fcm_token": "<device FCM token string>"
}
```

**What you must implement:**

1. **Endpoint**
   - REST route that accepts POST and reads `fcm_token` from the body.
   - Authenticate if needed (e.g. if only logged-in users get notifications).

2. **Storage**
   - Save each `fcm_token` (e.g. in a custom table or user meta).
   - Associate with user id or a guest/device id if you have one.
   - Handle duplicates (same token for same user) and cleanup old tokens.

3. **Sending notifications**
   - Use FCM **HTTP v1** API with the service account JSON from Firebase.
   - Endpoint: `https://fcm.googleapis.com/v1/projects/<PROJECT_ID>/messages:send`
   - Auth: OAuth2 access token from the service account (e.g. Google Auth Library in PHP/Node).
   - Body example (target by token):

   ```json
   {
     "message": {
       "token": "<FCM device token>",
       "notification": {
         "title": "New recipe",
         "body": "Check out the latest recipe."
       },
       "data": {
         "recipe_id": "123",
         "click_action": "FLUTTER_NOTIFICATION_CLICK"
       },
       "android": {
         "notification": {
           "channel_id": "recipe_book_default"
         }
       }
     }
   }
   ```

   - Use `channel_id` = `recipe_book_default` so it matches the app’s default channel.

**Recipe Book WordPress plugin (in this repo)**

- Full plugin file: **`wordpress/recipe-book-plugin.php`**. Copy it into your WordPress plugin directory (or merge into your existing Recipe Book plugin).
- It provides: `/v1/register-fcm-token`, `/v1/users`, `/v1/users/{id}`, and sends FCM **HTTP v1** when a recipe is published.
- **Settings → Recipe Book**: paste your **Service account JSON** (from Firebase → Project Settings → Service accounts → Generate new private key). No legacy server key.

---

## 4. Android-specific

- **Already in project**
  - `google-services.json` in `android/app/`.
  - `POST_NOTIFICATIONS` in `AndroidManifest.xml`.
  - Default notification channel id in manifest and `strings.xml`.

- **Optional**
  - Custom notification icon: add drawable and in `AndroidManifest.xml` set  
    `com.google.firebase.messaging.default_notification_icon` to that drawable.
  - Default notification color: `com.google.firebase.messaging.default_notification_color` to a color resource.

---

## 5. iOS-specific

1. **Xcode**
   - Open `ios/Runner.xcworkspace`.
   - Select Runner → Signing & Capabilities → add **Push Notifications** (and **Background Modes** → Remote notifications if you want background handling).

2. **Apple Developer**
   - Create an **APNs key** (Keys → + → Apple Push Notifications).
   - Download the `.p8` key and note Key ID and Team/App ID.
   - In Firebase: Project Settings → Your iOS app → Upload this APNs key.

3. **Info.plist**
   - No extra keys required for FCM; optional: add `UIBackgroundModes` with `remote-notification` if you use background handling.

4. **Request permission**
   - Already done in `NotificationService` via `requestPermission()`.

---

## 6. Testing

1. **Get a token**
   - Run the app, allow notifications, and log the FCM token (e.g. add a debug print of `NotificationService.instance.getToken()` or log it in `NotificationService` when you send to server).

2. **Send a test message**
   - Firebase Console: Cloud Messaging → “Send your first message” or “New campaign”.
   - Or use FCM HTTP v1 with the token and the JSON above.

3. **Backend**
   - After opening the app, check that your backend receives and stores the token.
   - Then send a message from your server using that token.

---

## 7. Summary checklist

| Item | Where | Status |
|------|--------|--------|
| firebase_messaging + init + background handler | Flutter app | Done |
| Request permission, get token, send to backend | NotificationService | Done |
| Android manifest + channel id + POST_NOTIFICATIONS | Android | Done |
| Backend: register token endpoint | WordPress / API | You implement |
| Backend: store tokens | WordPress / API | You implement |
| Backend: send via FCM HTTP v1 | WordPress plugin (in repo: wordpress/recipe-book-plugin.php) | Done |
| Firebase: service account JSON | Firebase Console → Service accounts → Generate key; paste in WP Settings → Recipe Book | You configure |
| iOS: Push capability + APNs key in Firebase | Xcode + Apple + Firebase | You configure |
| Test send (Console or server) | Firebase / backend | You test |

Once the backend stores tokens and sends messages with FCM HTTP v1 (and iOS is configured if needed), the app will receive and show notifications and handle taps as implemented in `NotificationService`.
