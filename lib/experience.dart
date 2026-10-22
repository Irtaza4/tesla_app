import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

const _bg = Color(0xFF1F1F1F);
const _panel = Color(0xFF292929);
const _cyan = Color(0xFF00BBD4);
const _purple = Color(0xFF7454F8);
const _secondary = Color(0xFF969696);

class TeslaExperience extends StatefulWidget {
  const TeslaExperience({super.key, required this.dashboard});
  final Widget dashboard;
  @override
  State<TeslaExperience> createState() => _TeslaExperienceState();
}

class _TeslaExperienceState extends State<TeslaExperience> {
  int tab = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, bounds) {
          final scale = math.min(bounds.maxWidth / 390, bounds.maxHeight / 844);
          return Center(
            child: SizedBox(
              width: 390 * scale,
              height: 844 * scale,
              child: FittedBox(
                child: SizedBox(
                  width: 390,
                  height: 844,
                  child: Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: tab,
                          children: [
                            widget.dashboard,
                            TickerMode(
                              enabled: tab == 1,
                              child: DrivePage(active: tab == 1),
                            ),
                            const ControlsPage(),
                            const ChargingPage(),
                            ExplorePage(onDrive: () => setState(() => tab = 1)),
                          ],
                        ),
                      ),
                      Container(
                        height: 83,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 13),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFF303030)),
                          ),
                        ),
                        child: Row(
                          children: [
                            for (int i = 0; i < 5; i++)
                              Expanded(
                                child: Semantics(
                                  selected: tab == i,
                                  child: Tooltip(
                                    message: [
                                      'Info tab',
                                      'Drive tab',
                                      'Controls tab',
                                      'Charge tab',
                                      'Explore tab',
                                    ][i],
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(18),
                                      onTap: () => setState(() => tab = i),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 220,
                                        ),
                                        decoration: BoxDecoration(
                                          color: tab == i
                                              ? _cyan.withValues(alpha: .12)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              [
                                                Icons.home_outlined,
                                                Icons.route,
                                                Icons.tune,
                                                Icons.bolt,
                                                Icons.map_outlined,
                                              ][i],
                                              color: tab == i
                                                  ? _cyan
                                                  : _secondary,
                                              size: 22,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              [
                                                'Info',
                                                'Drive',
                                                'Controls',
                                                'Charge',
                                                'Explore',
                                              ][i],
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: tab == i
                                                    ? _cyan
                                                    : _secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
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

class _Heading extends StatelessWidget {
  const _Heading(this.title, this.subtitle, {this.trailing});
  final String title, subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(27, 28, 27, 20),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle.toUpperCase(),
                style: const TextStyle(
                  color: _secondary,
                  letterSpacing: 2,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, {this.color = _cyan});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 10,
        letterSpacing: .7,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action(this.label, this.icon, this.onTap, {this.color = _cyan});
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 50,
    width: double.infinity,
    child: FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class DrivePage extends StatefulWidget {
  const DrivePage({super.key, required this.active});
  final bool active;
  @override
  State<DrivePage> createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController road = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  Timer? timer;
  bool driving = false;
  double speed = 48;
  double distance = 0;
  int seconds = 0;
  int lane = 1;
  String mode = 'Chill';
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (driving && widget.active) {
        setState(() {
          seconds++;
          distance += speed / 3600;
        });
      }
    });
  }

  @override
  void didUpdateWidget(DrivePage old) {
    super.didUpdateWidget(old);
    if (widget.active && driving) {
      road.repeat();
    } else {
      road.stop();
    }
  }

  void toggleDrive() {
    setState(() => driving = !driving);
    if (driving) {
      road.repeat();
    } else {
      road.stop();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    road.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _Heading(
        'Let’s drive.',
        'Model 3 · driving simulator',
        trailing: _Pill(driving ? 'DRIVING' : 'PARKED'),
      ),
      Expanded(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: road,
                builder: (context, _) =>
                    CustomPaint(painter: _RoadPainter(road.value)),
              ),
            ),
            Positioned(
              top: 6,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    driving ? speed.round().toString() : '0',
                    style: const TextStyle(
                      fontSize: 72,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -3,
                    ),
                  ),
                  const Text(
                    'MPH',
                    style: TextStyle(
                      fontSize: 11,
                      color: _secondary,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeInOutCubic,
              left: 95 + lane * 55,
              bottom: 34,
              width: 90,
              height: 195,
              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    right: 15,
                    bottom: 9,
                    height: 120,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: _cyan.withValues(alpha: driving ? .15 : 0),
                            blurRadius: 35,
                            spreadRadius: 9,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset('assets/images/model_3.png', fit: BoxFit.contain),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              left: 25,
              child: IconButton(
                tooltip: 'Steer left',
                onPressed: lane > 0 ? () => setState(() => lane--) : null,
                icon: const Icon(Icons.west, size: 21),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 25,
              child: IconButton(
                tooltip: 'Steer right',
                onPressed: lane < 2 ? () => setState(() => lane++) : null,
                icon: const Icon(Icons.east, size: 21),
              ),
            ),
            const Positioned(
              top: 125,
              right: 30,
              child: _Pill('60', color: Colors.white70),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(27, 10, 27, 18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stat(distance.toStringAsFixed(2), 'MILES'),
                _stat(
                  '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
                  'TRIP TIME',
                ),
                _stat(mode == 'Chill' ? '218' : '264', 'WH / MI'),
              ],
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                const Text(
                  'Cruise speed',
                  style: TextStyle(color: _secondary, fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    semanticFormatterCallback: (v) =>
                        '${v.round()} miles per hour',
                    value: speed,
                    min: 10,
                    max: 60,
                    divisions: 50,
                    activeColor: _cyan,
                    onChanged: (value) => setState(() {
                      speed = value;
                      road.duration = Duration(
                        milliseconds: (2400 - value * 22).round(),
                      );
                      if (driving) {
                        road.repeat();
                      }
                    }),
                  ),
                ),
                Text(
                  '${speed.round()} mph',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                for (final name in ['Chill', 'Sport'])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Center(child: Text(name)),
                        selected: mode == name,
                        selectedColor: _purple.withValues(alpha: .25),
                        onSelected: (_) => setState(() => mode = name),
                      ),
                    ),
                  ),
                IconButton(
                  tooltip: 'Reset trip',
                  onPressed: () => setState(() {
                    distance = 0;
                    seconds = 0;
                  }),
                  icon: const Icon(Icons.restart_alt, color: _secondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _Action(
              driving ? 'Park vehicle' : 'Start drive',
              driving ? Icons.local_parking : Icons.play_arrow_rounded,
              toggleDrive,
            ),
          ],
        ),
      ),
    ],
  );
  Widget _stat(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          color: _secondary,
          letterSpacing: 1.4,
        ),
      ),
    ],
  );
}

class _RoadPainter extends CustomPainter {
  _RoadPainter(this.offset);
  final double offset;
  @override
  void paint(Canvas canvas, Size size) {
    final road = Path()
      ..moveTo(140, 110)
      ..lineTo(250, 110)
      ..lineTo(385, size.height)
      ..lineTo(5, size.height)
      ..close();
    canvas.drawPath(
      road,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x001F1F1F), Color(0xFF303236)],
        ).createShader(Offset.zero & size),
    );
    final edge = Paint()
      ..color = _cyan.withValues(alpha: .35)
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(140, 110), Offset(5, size.height), edge);
    canvas.drawLine(const Offset(250, 110), Offset(385, size.height), edge);
    for (final side in [-1, 1]) {
      for (int i = 0; i < 10; i++) {
        final f = ((i + offset) / 10);
        final y = 115 + f * f * (size.height - 115);
        final end =
            115 + math.pow((f + .045).clamp(0, 1), 2) * (size.height - 115);
        canvas.drawLine(
          Offset(195 + side * (19 + f * f * 43), y),
          Offset(
            195 + side * (19 + math.pow((f + .045).clamp(0, 1), 2) * 43),
            end,
          ),
          Paint()
            ..color = Colors.white.withValues(alpha: f * .3)
            ..strokeWidth = 1 + f * 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RoadPainter old) => old.offset != offset;
}

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});
  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  double temperature = 21;
  double fan = 3;
  bool climate = true,
      locked = true,
      windows = false,
      trunk = false,
      heated = false,
      defrost = false;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _Heading(
        'Your comfort.',
        'Model 3 · controls',
        trailing: _Pill('DEMO'),
      ),
      SizedBox(
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: _DialPainter((temperature - 16) / 14, climate),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.air, color: climate ? _cyan : _secondary, size: 28),
                const SizedBox(height: 5),
                Text(
                  '${temperature.round()}°',
                  style: const TextStyle(
                    fontSize: 65,
                    height: 1.15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  climate ? 'CABIN TEMPERATURE' : 'CLIMATE OFF',
                  style: const TextStyle(
                    fontSize: 9,
                    color: _secondary,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20,
              bottom: 14,
              child: IconButton(
                tooltip: 'Lower temperature',
                onPressed: temperature > 16
                    ? () => setState(() => temperature--)
                    : null,
                icon: const Icon(Icons.remove),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 14,
              child: IconButton(
                tooltip: 'Raise temperature',
                onPressed: temperature < 30
                    ? () => setState(() => temperature++)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ),
            Positioned(
              bottom: 3,
              child: IconButton(
                tooltip: 'Toggle climate',
                style: IconButton.styleFrom(
                  backgroundColor: climate ? _purple : _panel,
                ),
                onPressed: () => setState(() => climate = !climate),
                icon: const Icon(Icons.power_settings_new, size: 19),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Row(
          children: [
            const Icon(Icons.air, color: _secondary, size: 19),
            const SizedBox(width: 10),
            const Text('Fan', style: TextStyle(color: _secondary)),
            Expanded(
              child: Slider(
                value: fan,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: _cyan,
                onChanged: climate ? (v) => setState(() => fan = v) : null,
              ),
            ),
            Text('${fan.round()}'),
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(27, 12, 27, 20),
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _toggle(
                'Door locks',
                locked ? 'Locked' : 'Unlocked',
                locked ? Icons.lock_outline : Icons.lock_open,
                locked,
                () => setState(() => locked = !locked),
              ),
              _toggle(
                'Windows',
                windows ? 'Vented' : 'Closed',
                Icons.crop_square,
                windows,
                () => setState(() => windows = !windows),
              ),
              _toggle(
                'Rear trunk',
                trunk ? 'Open' : 'Closed',
                Icons.inventory_2_outlined,
                trunk,
                () => setState(() => trunk = !trunk),
              ),
              _toggle(
                'Seat heating',
                heated ? 'On · level 1' : 'Off',
                Icons.event_seat_outlined,
                heated,
                () => setState(() => heated = !heated),
              ),
              _toggle(
                'Defrost',
                defrost ? 'On' : 'Off',
                Icons.waves,
                defrost,
                () => setState(() => defrost = !defrost),
              ),
              _toggle(
                'Climate',
                climate ? 'Auto' : 'Off',
                Icons.ac_unit,
                climate,
                () => setState(() => climate = !climate),
              ),
            ],
          ),
        ),
      ),
    ],
  );
  Widget _toggle(
    String title,
    String status,
    IconData icon,
    bool on,
    VoidCallback action,
  ) => Semantics(
    button: true,
    toggled: on,
    child: InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: on ? const Color(0xFF283438) : _panel,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 19, color: on ? _cyan : _secondary),
                const Spacer(),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: on ? _cyan : _secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 12)),
            Text(
              status,
              style: const TextStyle(color: _secondary, fontSize: 10),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DialPainter extends CustomPainter {
  _DialPainter(this.value, this.enabled);
  final double value;
  final bool enabled;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(10);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF353535);
    canvas.drawArc(rect, .75 * math.pi, 1.5 * math.pi, false, p);
    if (enabled) {
      p.shader = const SweepGradient(
        colors: [_cyan, _purple, _cyan],
      ).createShader(rect);
      canvas.drawArc(rect, .75 * math.pi, 1.5 * math.pi * value, false, p);
    }
    for (int i = 0; i < 37; i++) {
      final a = .75 * math.pi + i / 36 * 1.5 * math.pi;
      canvas.drawLine(
        Offset(110 + math.cos(a) * 85, 110 + math.sin(a) * 85),
        Offset(110 + math.cos(a) * 89, 110 + math.sin(a) * 89),
        Paint()
          ..color = const Color(0xFF505050)
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.value != value || old.enabled != enabled;
}

class ChargingPage extends StatefulWidget {
  const ChargingPage({super.key});
  @override
  State<ChargingPage> createState() => _ChargingPageState();
}

class _ChargingPageState extends State<ChargingPage> {
  double battery = 19, limit = 80;
  bool charging = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (charging) {
        setState(() {
          battery = math.min(limit, battery + 1);
          if (battery >= limit) {
            charging = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _Heading(
        'Recharge.',
        'Model 3 · energy',
        trailing: _Pill(charging ? 'CONNECTED' : 'STANDBY', color: _purple),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 195,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 184,
              height: 184,
              child: CircularProgressIndicator(
                value: battery / 100,
                strokeWidth: 7,
                strokeCap: StrokeCap.round,
                color: _cyan,
                backgroundColor: const Color(0xFF343434),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bolt,
                  color: charging ? _cyan : _secondary,
                  size: 29,
                ),
                Text(
                  '${battery.round()}%',
                  style: const TextStyle(
                    fontSize: 49,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -2,
                  ),
                ),
                Text(
                  charging
                      ? 'Charging your Model 3'
                      : battery >= limit
                      ? 'Charge limit reached'
                      : 'Ready when you are',
                  style: const TextStyle(color: _secondary, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Row(
          children: [
            Expanded(
              child: _energy(
                '${(battery * 3.1).round()} mi',
                'Estimated range',
                Icons.route,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _energy(
                charging ? '11.5 kW' : '0 kW',
                'Charging power',
                Icons.electric_bolt,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(27, 16, 27, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Charge limit', style: TextStyle(fontSize: 17)),
                const Spacer(),
                Text(
                  '${limit.round()}%',
                  style: const TextStyle(color: _cyan, fontSize: 17),
                ),
              ],
            ),
            Slider(
              value: limit,
              min: 50,
              max: 100,
              divisions: 10,
              activeColor: _cyan,
              label: '${limit.round()}%',
              onChanged: (v) => setState(() {
                limit = v;
                if (battery >= limit) {
                  charging = false;
                }
              }),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DAILY',
                  style: TextStyle(
                    color: _secondary,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'TRIP',
                  style: TextStyle(
                    color: _secondary,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const Spacer(),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          'Simulated session · battery advances every 2 seconds.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _secondary, fontSize: 11),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(27, 18, 27, 22),
        child: _Action(
          charging ? 'Stop charging' : 'Start charging',
          charging ? Icons.stop_rounded : Icons.bolt,
          battery >= limit && !charging
              ? null
              : () => setState(() => charging = !charging),
          color: _purple,
        ),
      ),
    ],
  );
  Widget _energy(String value, String label, IconData icon) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _secondary, size: 19),
        const SizedBox(height: 14),
        Text(
          value,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        Text(label, style: const TextStyle(color: _secondary, fontSize: 11)),
      ],
    ),
  );
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, required this.onDrive});
  final VoidCallback onDrive;
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int destination = 0;
  bool navigating = false;
  final destinations = const ['Ocean Beach', 'Downtown', 'Supercharger'];
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _Heading(
        'Go somewhere.',
        'Model 3 · explore',
        trailing: _Pill('DEMO MAP'),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: CustomPaint(
                      key: ValueKey(destination),
                      painter: _MapPainter(destination),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
                const Positioned(
                  left: 18,
                  top: 17,
                  child: _Pill('SAN FRANCISCO', color: Colors.white70),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: IconButton(
                    tooltip: 'Recenter map',
                    onPressed: () => setState(() {
                      destination = 0;
                      navigating = false;
                    }),
                    style: IconButton.styleFrom(backgroundColor: _bg),
                    icon: const Icon(Icons.my_location, color: _cyan),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 19,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      navigating
                          ? 'Continue on Market St'
                          : 'Choose your next stop',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(27, 17, 27, 8),
        child: Row(
          children: [
            const Icon(Icons.search, color: _secondary, size: 21),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: destination,
                  isExpanded: true,
                  dropdownColor: _panel,
                  items: List.generate(
                    3,
                    (i) => DropdownMenuItem(
                      value: i,
                      child: Text(destinations[i]),
                    ),
                  ),
                  onChanged: (i) => setState(() {
                    destination = i!;
                    navigating = false;
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _purple.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  destination == 2
                      ? Icons.ev_station_outlined
                      : Icons.near_me_outlined,
                  color: _purple,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destinations[destination],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        '18 min · 7.2 mi',
                        '9 min · 3.4 mi',
                        '12 min · 4.8 mi',
                      ][destination],
                      style: const TextStyle(color: _secondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _secondary),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(27, 17, 27, 22),
        child: _Action(
          navigating ? 'Open driving view' : 'Start navigation',
          Icons.navigation_outlined,
          () {
            if (navigating) {
              widget.onDrive();
            } else {
              setState(() => navigating = true);
            }
          },
        ),
      ),
    ],
  );
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.destination);
  final int destination;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF25292A),
    );
    final water = Path()
      ..moveTo(0, 0)
      ..lineTo(75, 0)
      ..cubicTo(110, 90, 30, 170, 65, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(water, Paint()..color = const Color(0xFF203D46));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(130, 65, 65, 110),
        const Radius.circular(15),
      ),
      Paint()..color = const Color(0xFF2E3C34),
    );
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(80, -90);
    canvas.rotate(.35);
    for (int i = 0; i < 12; i++) {
      canvas.drawLine(
        Offset(i * 35.0, 0),
        Offset(i * 35.0, size.height + 180),
        Paint()
          ..color = const Color(0xFF383D3E)
          ..strokeWidth = 6,
      );
      canvas.drawLine(
        Offset(-100, i * 43.0),
        Offset(size.width + 100, i * 43.0),
        Paint()
          ..color = const Color(0xFF383D3E)
          ..strokeWidth = 6,
      );
    }
    canvas.restore();
    final start = Offset(size.width * .68, size.height * .8);
    final end = [
      Offset(size.width * .26, size.height * .31),
      Offset(size.width * .72, size.height * .24),
      Offset(size.width * .48, size.height * .4),
    ][destination];
    final route = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(start.dx - 35, start.dy - 90)
      ..lineTo(end.dx + 25, start.dy - 120)
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(
      route,
      Paint()
        ..color = _cyan.withValues(alpha: .15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      route,
      Paint()
        ..color = _cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(start, 14, Paint()..color = _cyan.withValues(alpha: .15));
    canvas.drawCircle(start, 6, Paint()..color = _cyan);
    canvas.drawCircle(end, 12, Paint()..color = _purple);
    canvas.drawCircle(end, 4, Paint()..color = Colors.white);
    final text = TextPainter(
      text: const TextSpan(
        text: 'GOLDEN GATE PARK',
        style: TextStyle(
          color: Color(0xFF86998A),
          fontSize: 8,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, const Offset(105, 100));
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.destination != destination;
}
