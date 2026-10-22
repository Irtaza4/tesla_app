import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

const charcoal = Color(0xFF1F1F1F);
const muted = Color(0xFF777777);
const cyan = Color(0xFF00B7CF);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Tesla · Model 3',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: charcoal,
      fontFamily: 'Outfit',
      colorScheme: const ColorScheme.dark(primary: cyan, surface: charcoal),
      useMaterial3: true,
    ),
    home: const TeslaDashboard(),
  );
}

class TeslaDashboard extends StatefulWidget {
  const TeslaDashboard({super.key});
  @override
  State<TeslaDashboard> createState() => _TeslaDashboardState();
}

class _TeslaDashboardState extends State<TeslaDashboard>
    with SingleTickerProviderStateMixin {
  late final AnimationController transition = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  bool wheels = false;
  bool power = true;
  bool locked = true;
  int selectedControl = 0;

  void showWheels(bool value) {
    HapticFeedback.selectionClick();
    setState(() => wheels = value);
    value ? transition.forward() : transition.reverse();
  }

  @override
  void dispose() {
    transition.dispose();
    super.dispose();
  }

  void details(String title, String description, IconData icon) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF292929),
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: cyan, size: 36),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = math.min(
            constraints.maxWidth / 390,
            constraints.maxHeight / 844,
          );
          return Center(
            child: SizedBox(
              width: 390 * scale,
              height: 844 * scale,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 390,
                  height: 844,
                  child: ClipRect(
                    child: AnimatedBuilder(
                      animation: transition,
                      builder: (context, _) {
                        final t = Curves.easeInOutCubic.transform(
                          transition.value,
                        );
                        final outline = ((transition.value - .42) / .58).clamp(
                          0.0,
                          1.0,
                        );
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(painter: _Backdrop(t)),
                            ),
                            Positioned(
                              left: 38,
                              top: 36,
                              child: _IconButton(
                                label: wheels
                                    ? 'Back to dashboard'
                                    : 'Vehicle settings',
                                icon: wheels
                                    ? Icons.chevron_left
                                    : Icons.hexagon_outlined,
                                onTap: () => wheels
                                    ? showWheels(false)
                                    : details(
                                        'Model 3',
                                        'Tesla Model 3\nVehicle controls and information\nDemo vehicle · Last synced just now',
                                        Icons.directions_car_outlined,
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 40,
                              top: 36,
                              child: _IconButton(
                                label: wheels
                                    ? 'Pressure information'
                                    : 'Toggle vehicle power',
                                icon: wheels
                                    ? Icons.chat_bubble_outline_rounded
                                    : Icons.power_settings_new,
                                background: wheels
                                    ? Colors.transparent
                                    : (power
                                          ? const Color(0xFF6041EA)
                                          : const Color(0xFF343434)),
                                foreground: wheels ? muted : Colors.white,
                                onTap: () => wheels
                                    ? details(
                                        'Pressure Fluid',
                                        'Front axle 25 atm\nRear axle 23 atm\nValues reproduce the design reference and are demo data.',
                                        Icons.tire_repair,
                                      )
                                    : setState(() => power = !power),
                              ),
                            ),
                            Positioned(
                              left: 48 + t * 100,
                              top: 126,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wheels ? 'Wheels' : 'Model3',
                                    style: const TextStyle(
                                      fontSize: 43,
                                      height: 1.1,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    wheels ? 'Pressure Fluid' : 'Tesla',
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: wheels ? 15 : 19,
                                      letterSpacing: wheels ? 1.3 : 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (t > 0)
                              Positioned(
                                left: 42,
                                top: 121,
                                child: Opacity(
                                  opacity: t,
                                  child: _ControlButton(
                                    kind: 0,
                                    selected: true,
                                    onTap: () =>
                                        setState(() => selectedControl = 0),
                                  ),
                                ),
                              ),
                            Positioned(
                              left: -3 + 139 * t,
                              top: 242,
                              width: 228,
                              height: 492,
                              child: GestureDetector(
                                onTap: () => showWheels(!wheels),
                                child: Semantics(
                                  button: true,
                                  label: wheels
                                      ? 'Return to vehicle overview'
                                      : 'View wheel pressure',
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Opacity(
                                        opacity: 1 - outline,
                                        child: Image.asset(
                                          'assets/images/model_3.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Opacity(
                                        opacity: outline,
                                        child: Image.asset(
                                          'assets/images/model_3_outline.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      if (outline > 0)
                                        Opacity(
                                          opacity: outline,
                                          child: _PressureReadout(
                                            progress: outline,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (t < 1)
                              Positioned(
                                right: 23 - 180 * t,
                                top: 242,
                                child: Opacity(
                                  opacity: 1 - t,
                                  child: Column(
                                    children: [
                                      _Metric(
                                        value: '57°f',
                                        label: 'Temp',
                                        onTap: () => details(
                                          'Cabin temperature',
                                          '57°F inside your Model 3.\nClimate controls are in demo mode.',
                                          Icons.thermostat,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      _Metric(
                                        value: power ? '86' : '0',
                                        unit: 'mph',
                                        label: 'Speed',
                                        active: true,
                                        onTap: () => details(
                                          'Vehicle speed',
                                          'This is a visual prototype.\nThe dashboard displays sample driving data.',
                                          Icons.speed,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      _Metric(
                                        value: '19%',
                                        label: 'Charge',
                                        alert: true,
                                        onTap: () => details(
                                          'Battery charge',
                                          '19% remaining\nConnect your Model 3 to a charger.',
                                          Icons.battery_charging_full,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      _Metric(
                                        value: '215',
                                        unit: 'mi',
                                        label: 'Range',
                                        onTap: () => details(
                                          'Estimated range',
                                          '215 miles\nSample range from the original design.',
                                          Icons.route_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (t < .8)
                              Positioned(
                                left: 171 + 139 * t,
                                top: 650,
                                child: Opacity(
                                  opacity: (1 - t / .8).clamp(0.0, 1.0),
                                  child: Semantics(
                                    label: locked
                                        ? 'Unlock vehicle'
                                        : 'Lock vehicle',
                                    button: true,
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => locked = !locked),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: .15,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: locked
                                                ? const Color(0xFFE46C86)
                                                : cyan,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            locked
                                                ? Icons.lock
                                                : Icons.lock_open,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (t > 0)
                              Positioned(
                                left: 39,
                                top: 264,
                                child: Opacity(
                                  opacity: t,
                                  child: Column(
                                    children: [
                                      for (int i = 1; i <= 4; i++)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 17,
                                          ),
                                          child: _ControlButton(
                                            kind: i,
                                            selected: selectedControl == i,
                                            onTap: () {
                                              setState(
                                                () => selectedControl = i,
                                              );
                                              if (i != 1) {
                                                details(
                                                  [
                                                    '',
                                                    'Wheel pressure',
                                                    'Windows',
                                                    'Air flow',
                                                    'Steering',
                                                  ][i],
                                                  [
                                                    '',
                                                    '',
                                                    'All windows are closed.',
                                                    'Air circulation is set to automatic.',
                                                    'Steering assistance is enabled.',
                                                  ][i],
                                                  [
                                                    Icons.tire_repair,
                                                    Icons.tire_repair,
                                                    Icons.crop_square,
                                                    Icons.air,
                                                    Icons.trip_origin,
                                                  ][i],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      const SizedBox(height: 70),
                                      _IconButton(
                                        label: 'More vehicle controls',
                                        icon: Icons.more_horiz,
                                        onTap: () => details(
                                          'Vehicle controls',
                                          'Tap the car to return to the dashboard.\nTap the power button to toggle demo driving mode.',
                                          Icons.tune,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Positioned(
                              left: 47,
                              right: 39,
                              bottom: 23,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    button: true,
                                    label: 'Vehicle information',
                                    child: GestureDetector(
                                      onTap: () => showWheels(false),
                                      child: Container(
                                        width: 127,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00AFEA),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Info',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            SizedBox(width: 19),
                                            Icon(Icons.home_outlined, size: 23),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  _IconButton(
                                    label: 'Wheel controls',
                                    icon: Icons.all_inclusive,
                                    foreground: wheels ? cyan : muted,
                                    onTap: () => showWheels(true),
                                  ),
                                  _IconButton(
                                    label: 'Charging',
                                    icon: Icons.bolt_outlined,
                                    onTap: () => details(
                                      'Charging',
                                      '19% battery remaining\nCharging cable disconnected',
                                      Icons.bolt_outlined,
                                    ),
                                  ),
                                  _IconButton(
                                    label: 'Vehicle guide',
                                    icon: Icons.map_outlined,
                                    onTap: () => details(
                                      'Your Model 3',
                                      'Tap the car or wheel controls to see pressure.\nUse the lock to lock or unlock the demo vehicle.\nTap any card for more information.',
                                      Icons.menu_book_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.background = Colors.transparent,
    this.foreground = muted,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color background, foreground;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 44,
    height: 44,
    child: IconButton(
      tooltip: label,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      icon: Icon(icon, size: 23),
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.value,
    required this.label,
    required this.onTap,
    this.unit,
    this.active = false,
    this.alert = false,
  });
  final String value, label;
  final String? unit;
  final bool active, alert;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '$label $value ${unit ?? ''}',
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 101,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: active ? cyan : const Color(0xFF282828),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Positioned(
              right: alert ? 12 : -10,
              top: alert ? 12 : -12,
              child: Container(
                width: alert ? 6 : 37,
                height: alert ? 6 : 37,
                decoration: BoxDecoration(
                  color: alert
                      ? const Color(0xFFE96B85)
                      : Colors.white.withValues(alpha: .035),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 19,
              top: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: value,
                      style: const TextStyle(
                        fontSize: 30,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.8,
                      ),
                      children: [
                        if (unit != null)
                          TextSpan(
                            text: ' $unit',
                            style: const TextStyle(
                              fontSize: 17,
                              letterSpacing: 0,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: active ? Colors.white70 : muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.kind,
    required this.selected,
    required this.onTap,
  });
  final int kind;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: [
      'Pressure diagram',
      'Wheel pressure',
      'Windows',
      'Air flow',
      'Steering',
    ][kind],
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: kind == 0 ? 73 : 65,
        height: kind == 0 ? 73 : 65,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2B2B2B) : const Color(0xFF262626),
          borderRadius: BorderRadius.circular(23),
        ),
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CustomPaint(
              painter: _ControlIcon(kind, selected ? Colors.white : muted),
            ),
          ),
        ),
      ),
    ),
  );
}

class _ControlIcon extends CustomPainter {
  _ControlIcon(this.kind, this.color);
  final int kind;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (kind == 2) {
      canvas.drawPath(
        Path()
          ..moveTo(4, 9)
          ..lineTo(23, 3)
          ..lineTo(23, 23)
          ..lineTo(4, 23)
          ..close(),
        p,
      );
      canvas.drawLine(const Offset(4, 4), const Offset(13, 4), p);
    } else if (kind == 4) {
      canvas.drawCircle(const Offset(13, 13), 10, p);
      canvas.drawCircle(const Offset(13, 13), 3, p);
      canvas.drawLine(const Offset(3, 12), const Offset(10, 12), p);
      canvas.drawLine(const Offset(16, 12), const Offset(23, 12), p);
      canvas.drawLine(const Offset(13, 16), const Offset(13, 23), p);
    } else {
      canvas.drawCircle(const Offset(12, 14), 8, p);
      canvas.drawArc(const Rect.fromLTWH(9, 11, 6, 6), -.6, 5, false, p);
      if (kind == 3) {
        canvas.drawPath(
          Path()
            ..moveTo(12, 6)
            ..lineTo(24, 6)
            ..lineTo(24, 11)
            ..lineTo(12, 11),
          p,
        );
      } else {
        canvas.drawArc(const Rect.fromLTWH(2, 3, 21, 21), -1.5, 2, false, p);
        if (kind == 0) {
          canvas.drawLine(const Offset(1, 24), const Offset(12, 24), p);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ControlIcon old) =>
      old.color != color || old.kind != kind;
}

class _PressureReadout extends StatelessWidget {
  const _PressureReadout({required this.progress});
  final double progress;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned(
        left: 18,
        top: 0,
        child: Text('10', style: TextStyle(color: muted, fontSize: 18)),
      ),
      const Positioned(
        right: 17,
        top: 0,
        child: Text(
          '25',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      Positioned(left: 14, right: 14, top: 80, child: _Axle(reverse: false)),
      Positioned(
        top: 132,
        left: 0,
        right: 0,
        child: Center(
          child: Text(
            '${(25 * progress).round()} atm',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      Positioned(
        bottom: 112,
        left: 0,
        right: 0,
        child: Center(
          child: Text(
            '${(23 * progress).round()} atm',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      Positioned(left: 14, right: 14, bottom: 64, child: _Axle(reverse: true)),
      const Positioned(
        left: 18,
        bottom: 0,
        child: Text(
          '23',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      const Positioned(
        right: 17,
        bottom: 0,
        child: Text('16', style: TextStyle(color: muted, fontSize: 18)),
      ),
    ],
  );
}

class _Axle extends StatelessWidget {
  const _Axle({required this.reverse});
  final bool reverse;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 34,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: reverse
                  ? [cyan, const Color(0xFF6B43E2), const Color(0xFFED6C90)]
                  : [const Color(0xFFED6C90), const Color(0xFF6B43E2), cyan],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _dot(reverse ? cyan : const Color(0xFFED6C90)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _dot(reverse ? const Color(0xFFED6C90) : cyan),
        ),
        Container(
          width: 34,
          height: 34,
          padding: const EdgeInsets.all(9),
          decoration: const BoxDecoration(
            color: Color(0xFF383838),
            shape: BoxShape.circle,
          ),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF6742E7), cyan]),
            ),
          ),
        ),
      ],
    ),
  );
  Widget _dot(Color color) => Container(
    width: 7,
    height: 7,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _Backdrop extends CustomPainter {
  _Backdrop(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = charcoal);
    canvas.save();
    canvas.translate(-progress * 100, 0);
    canvas.rotate(-progress * .45);
    final area = Rect.fromLTWH(0, -100, 235, size.height + 250);
    canvas.drawRect(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF282828), charcoal],
        ).createShader(area),
    );
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1C1C1C), Color(0x001C1C1C)],
      ).createShader(const Rect.fromLTWH(0, 0, 390, 490))
      ..strokeWidth = 1.5;
    for (double x = 23; x < 235; x += 72) {
      canvas.drawLine(Offset(x, -100), Offset(x, size.height + 150), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_Backdrop old) => old.progress != progress;
}
