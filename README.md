# Tesla Model 3

Flutter recreation of [uixNinja’s Tesla mobile app concept](https://dribbble.com/shots/6908388-Tesla-mobile-app-ui-tutorial).

## Run

```sh
flutter pub get
flutter run
```

Browser preview: `flutter run -d chrome`.

Tap the car or infinity-shaped bottom control to open Wheels. The car transitions into the extracted pressure outline. Use the back arrow or Info to return. Power and lock controls toggle local demo state; metric cards open details.

Both screens use sample readings from the concept. No Tesla API or real vehicle control is connected. The car assets are extracted from the compressed reference video; typography and icons are recreated. See `assets/README.md` for provenance.

## Verify

```sh
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
```
