Run to obtain debug SHA keys:

```
cd android && ./gradlew signingReport
```

Copy the SHA-1 and SHA-256 values for the `debug` variant into Firebase Console (Android app for `com.example.depth_tracker`), then download and replace `android/app/google-services.json`.
