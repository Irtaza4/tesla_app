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

## Interactive screens

The bottom navigation now opens five persistent screens:

- **Info:** original Model 3 dashboard and animated pressure diagram.
- **Drive:** start/park the simulation, change cruise speed, steer between three lanes, select Chill/Sport, and reset the trip. Animation and trip accumulation pause when the tab is hidden.
- **Controls:** cabin temperature, fan speed, climate power, locks, window venting, trunk, seat heat, and defrost.
- **Charge:** start/stop a simulated charging session and set a 50–100% limit. Battery advances one percentage point every two seconds and stops at the limit.
- **Explore:** illustrated demo map, three destination presets, route selection, and a transition into the driving screen.

Settings persist while switching tabs during the current app session. Map routes, driving, and charging are simulations; no mapping service or vehicle API is connected.

Driving motion uses a frame-timed simulation: Chill and Sport accelerate at different rates, road speed follows actual speed, braking illuminates rear lights, and lane changes ease into position with a small steering lean. Five staggered traffic vehicles add depth ahead of the car. Driving buttons compress on press and trigger selection/light-impact haptics on supported devices. Simulation pauses while the Drive tab is hidden.
