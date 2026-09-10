import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
class DeliveryMission {
  final String id;
  final String title;
  final String pickupAddress;
  final String dropoffAddress;
  final int minutesLeft;
  final double weightKg;
  const DeliveryMission({
    required this.id,
    required this.title,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.minutesLeft,
    required this.weightKg,
  });
}
final _demoMission = DeliveryMission(
  id: 'M-001',
  title: 'Redistribution: 15kg Organic Mansaf Ingredients',
  pickupAddress: 'Central Vegetable Market, King Abdullah St, Amman',
  dropoffAddress: 'Alpha Community Kitchen, Downtown Amman',
  minutesLeft: 12,
  weightKg: 15,
);
class NavigateVerifyDeliveryScreen extends StatefulWidget {
  final DeliveryMission mission;
  const NavigateVerifyDeliveryScreen({super.key, required this.mission});
  static DeliveryMission get demo => _demoMission;
  @override
  State<NavigateVerifyDeliveryScreen> createState() =>
      _NavigateVerifyDeliveryScreenState();
}
enum _DeliveryStep { initial, pickupScanned, enRoute, dropoffScanned, done }
class _NavigateVerifyDeliveryScreenState
    extends State<NavigateVerifyDeliveryScreen>
    with SingleTickerProviderStateMixin {
  _DeliveryStep _step = _DeliveryStep.initial;
  late int _secondsLeft;
  Timer? _timer;
  bool _scannerActive = false;
  bool _routeStarted = false;
  late AnimationController _scanAnim;
  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.mission.minutesLeft * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) _secondsLeft--;
      });
    });
    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }
  @override
  void dispose() {
    _timer?.cancel();
    _scanAnim.dispose();
    super.dispose();
  }
  String get _timeLabel {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
  void _onScanPickup() {
    setState(() => _scannerActive = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _scannerActive = false;
        _step = _DeliveryStep.pickupScanned;
      });
      _showSnack('✅ تم التحقق من الاستلام بنجاح', ZadColors.primary);
    });
  }
  void _onStartRoute() {
    setState(() {
      _routeStarted = true;
      if (_step == _DeliveryStep.pickupScanned) {
        _step = _DeliveryStep.enRoute;
      }
    });
    _showSnack('🗺️ بدأ التنقل نحو نقطة التسليم', ZadColors.primaryContainer);
  }
  void _onScanDropoff() {
    setState(() => _scannerActive = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _scannerActive = false;
        _step = _DeliveryStep.dropoffScanned;
      });
      _showSnack('🎉 تم تأكيد التسليم! شكراً لتطوعك', ZadColors.primary);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _step = _DeliveryStep.done);
      });
    });
  }
  void _onReportIssue() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReportIssueSheet(),
    );
  }
  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: ZadTextStyles.bodyMd
                .copyWith(color: Colors.white, fontFamily: 'Inter')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZadColors.background,
      body: Stack(
        children: [
          _MapBackground(routeActive: _routeStarted),
          SafeArea(
            child: Column(
              children: [
                _TopBar(mission: widget.mission, timeLabel: _timeLabel),
                const SizedBox(height: 12),
                _StepChips(step: _step),
                const Spacer(),
                if (_scannerActive) _ScannerOverlay(anim: _scanAnim),
                if (_step == _DeliveryStep.done) _CompletionBanner(),
                _BottomPanel(
                  mission: widget.mission,
                  step: _step,
                  scannerActive: _scannerActive,
                  onScanPickup: _onScanPickup,
                  onStartRoute: _onStartRoute,
                  onScanDropoff: _onScanDropoff,
                  onReportIssue: _onReportIssue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _MapBackground extends StatelessWidget {
  final bool routeActive;
  const _MapBackground({required this.routeActive});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFE8EDF0),
      child: CustomPaint(painter: _MapPainter(routeActive: routeActive)),
    );
  }
}
class _MapPainter extends CustomPainter {
  final bool routeActive;
  const _MapPainter({required this.routeActive});
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFCDD5DA)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    if (routeActive) {
      final routePaint = Paint()
        ..color = const Color(0xFF1A73E8).withValues(alpha: 0.7)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      final path = Path()
        ..moveTo(size.width * 0.2, size.height * 0.7)
        ..lineTo(size.width * 0.2, size.height * 0.4)
        ..lineTo(size.width * 0.6, size.height * 0.4)
        ..lineTo(size.width * 0.6, size.height * 0.25);
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFF1A73E8).withValues(alpha: 0.7)
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round);
    }
    _drawMarker(canvas, Offset(size.width * 0.2, size.height * 0.7),
        ZadColors.primary);
    _drawMarker(canvas, Offset(size.width * 0.6, size.height * 0.25),
        ZadColors.secondary);
  }
  void _drawMarker(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 14, Paint()..color = color);
    canvas.drawCircle(center, 10, Paint()..color = Colors.white);
    canvas.drawCircle(center, 6, Paint()..color = color);
  }
  @override
  bool shouldRepaint(_MapPainter old) => old.routeActive != routeActive;
}
class _TopBar extends StatelessWidget {
  final DeliveryMission mission;
  final String timeLabel;
  const _TopBar({required this.mission, required this.timeLabel});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ZadColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZadColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new,
                color: ZadColors.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المهمة الحالية',
                    style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                Text(mission.title,
                    style: ZadTextStyles.headlineMd.copyWith(
                        color: ZadColors.onSurface, fontFamily: 'Inter'),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ZadColors.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined,
                    color: ZadColors.onPrimaryContainer, size: 16),
                const SizedBox(width: 4),
                Text(timeLabel,
                    style: ZadTextStyles.labelMd.copyWith(
                        color: ZadColors.onPrimaryContainer,
                        fontFamily: 'Inter')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _StepChips extends StatelessWidget {
  final _DeliveryStep step;
  const _StepChips({required this.step});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StepChip(
            label: 'مسح الاستلام',
            number: '1',
            active: step == _DeliveryStep.initial,
            done: step.index >= _DeliveryStep.pickupScanned.index,
          ),
          const SizedBox(width: 8),
          _StepChip(
            label: 'مسح التسليم',
            number: '2',
            active: step == _DeliveryStep.enRoute,
            done: step.index >= _DeliveryStep.dropoffScanned.index,
          ),
        ],
      ),
    );
  }
}
class _StepChip extends StatelessWidget {
  final String label;
  final String number;
  final bool active;
  final bool done;
  const _StepChip(
      {required this.label,
      required this.number,
      required this.active,
      required this.done});
  @override
  Widget build(BuildContext context) {
    final bgColor = done
        ? ZadColors.primaryContainer
        : active
            ? ZadColors.primaryContainer
            : ZadColors.surfaceContainerLow;
    final textColor = done || active
        ? ZadColors.onPrimaryContainer
        : ZadColors.onSurfaceVariant;
    final borderColor =
        done || active ? ZadColors.primary : ZadColors.outlineVariant;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: done || active ? 1 : 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: done || active ? 2 : 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: done ? ZadColors.primary : Colors.white,
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : Text(number,
                      style: ZadTextStyles.labelMd.copyWith(
                          color: active
                              ? ZadColors.primary
                              : ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter')),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  style: ZadTextStyles.labelMd
                      .copyWith(color: textColor, fontFamily: 'Inter'),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
class _ScannerOverlay extends StatelessWidget {
  final AnimationController anim;
  const _ScannerOverlay({required this.anim});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            ..._corners(),
            AnimatedBuilder(
              animation: anim,
              builder: (_, __) => Positioned(
                top: 20 + (anim.value * 180),
                left: 20,
                right: 20,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: ZadColors.primary,
                    boxShadow: [
                      BoxShadow(
                          color: ZadColors.primary.withValues(alpha: 0.6),
                          blurRadius: 8)
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('وجّه رمز QR داخل الإطار',
                        style: ZadTextStyles.labelMd.copyWith(
                            color: Colors.white, fontFamily: 'Inter')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Widget> _corners() {
    const size = 28.0;
    const thick = 4.0;
    final color = ZadColors.primary;
    return [
      _corner(top: 12, left: 12, tl: true, color: color, s: size, t: thick),
      _corner(top: 12, right: 12, tr: true, color: color, s: size, t: thick),
      _corner(bottom: 12, left: 12, bl: true, color: color, s: size, t: thick),
      _corner(
          bottom: 12, right: 12, br: true, color: color, s: size, t: thick),
    ];
  }
  Widget _corner(
      {double? top,
      double? left,
      double? right,
      double? bottom,
      bool tl = false,
      bool tr = false,
      bool bl = false,
      bool br = false,
      required Color color,
      required double s,
      required double t}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: SizedBox(
        width: s,
        height: s,
        child: CustomPaint(
          painter: _CornerPainter(
              tl: tl, tr: tr, bl: bl, br: br, color: color, thick: t),
        ),
      ),
    );
  }
}
class _CornerPainter extends CustomPainter {
  final bool tl, tr, bl, br;
  final Color color;
  final double thick;
  const _CornerPainter(
      {required this.tl,
      required this.tr,
      required this.bl,
      required this.br,
      required this.color,
      required this.thick});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    if (tl) {
      path.moveTo(0, size.height * 0.6);
      path.lineTo(0, 8);
      path.arcToPoint(const Offset(8, 0), radius: const Radius.circular(8));
      path.lineTo(size.width * 0.6, 0);
    }
    if (tr) {
      path.moveTo(size.width * 0.4, 0);
      path.lineTo(size.width - 8, 0);
      path.arcToPoint(Offset(size.width, 8), radius: const Radius.circular(8));
      path.lineTo(size.width, size.height * 0.6);
    }
    if (bl) {
      path.moveTo(0, size.height * 0.4);
      path.lineTo(0, size.height - 8);
      path.arcToPoint(Offset(8, size.height),
          radius: const Radius.circular(8));
      path.lineTo(size.width * 0.6, size.height);
    }
    if (br) {
      path.moveTo(size.width * 0.4, size.height);
      path.lineTo(size.width - 8, size.height);
      path.arcToPoint(Offset(size.width, size.height - 8),
          radius: const Radius.circular(8));
      path.lineTo(size.width, size.height * 0.4);
    }
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_) => false;
}
class _CompletionBanner extends StatelessWidget {
  const _CompletionBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ZadColors.primary, ZadColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مهمة مكتملة! 🎉',
                    style: ZadTextStyles.headlineMd
                        .copyWith(color: Colors.white, fontFamily: 'Inter')),
                Text('تم توصيل ${_demoMission.weightKg.toStringAsFixed(0)} كجم من الطعام بنجاح',
                    style: ZadTextStyles.bodyMd.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontFamily: 'Inter')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _BottomPanel extends StatelessWidget {
  final DeliveryMission mission;
  final _DeliveryStep step;
  final bool scannerActive;
  final VoidCallback onScanPickup;
  final VoidCallback onStartRoute;
  final VoidCallback onScanDropoff;
  final VoidCallback onReportIssue;
  const _BottomPanel({
    required this.mission,
    required this.step,
    required this.scannerActive,
    required this.onScanPickup,
    required this.onStartRoute,
    required this.onScanDropoff,
    required this.onReportIssue,
  });
  @override
  Widget build(BuildContext context) {
    if (step == _DeliveryStep.done) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.home_outlined),
            label: const Text('العودة للرئيسية'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ZadColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle:
                  ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
            ),
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZadColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: ZadColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: ZadColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.index < _DeliveryStep.enRoute.index
                          ? 'نقطة الاستلام'
                          : 'نقطة التسليم',
                      style: ZadTextStyles.labelSm.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter'),
                    ),
                    Text(
                      step.index < _DeliveryStep.enRoute.index
                          ? mission.pickupAddress
                          : mission.dropoffAddress,
                      style: ZadTextStyles.bodyMd.copyWith(
                          fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  final address = step.index < _DeliveryStep.enRoute.index
                      ? mission.pickupAddress
                      : mission.dropoffAddress;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening directions to: $address',
                        style: ZadTextStyles.bodyMd
                            .copyWith(color: Colors.white, fontFamily: 'Inter'),
                      ),
                      backgroundColor: ZadColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      action: SnackBarAction(
                        label: 'Copy',
                        textColor: Colors.white,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: address));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Address copied to clipboard',
                                style: ZadTextStyles.bodyMd
                                    .copyWith(color: Colors.white, fontFamily: 'Inter'),
                              ),
                              backgroundColor: ZadColors.primaryContainer,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ZadColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.directions,
                      color: ZadColors.onSurfaceVariant, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (step == _DeliveryStep.initial)
                Expanded(
                  child: _ActionBtn(
                    label: 'مسح الاستلام',
                    icon: Icons.qr_code_scanner,
                    primary: true,
                    loading: scannerActive,
                    onTap: onScanPickup,
                  ),
                ),
              if (step == _DeliveryStep.initial) const SizedBox(width: 8),
              if (step == _DeliveryStep.initial)
                Expanded(
                  child: _ActionBtn(
                    label: 'ابدأ المسار',
                    icon: Icons.navigation_outlined,
                    primary: false,
                    onTap: onStartRoute,
                  ),
                ),
              if (step == _DeliveryStep.pickupScanned)
                Expanded(
                  child: _ActionBtn(
                    label: 'ابدأ المسار',
                    icon: Icons.navigation_outlined,
                    primary: true,
                    onTap: onStartRoute,
                  ),
                ),
              if (step == _DeliveryStep.enRoute)
                Expanded(
                  child: _ActionBtn(
                    label: 'مسح التسليم',
                    icon: Icons.qr_code_scanner,
                    primary: true,
                    loading: scannerActive,
                    onTap: onScanDropoff,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onReportIssue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flag_outlined,
                    size: 16, color: ZadColors.secondary),
                const SizedBox(width: 4),
                Text('الإبلاغ عن مشكلة',
                    style: ZadTextStyles.labelMd.copyWith(
                        color: ZadColors.secondary, fontFamily: 'Inter')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final bool loading;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.primary,
    this.loading = false,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: primary ? ZadColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: primary
              ? null
              : Border.all(color: ZadColors.primary, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            else
              Icon(icon,
                  color: primary ? Colors.white : ZadColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: ZadTextStyles.labelMd.copyWith(
                    color: primary ? Colors.white : ZadColors.primary,
                    fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}
class _ReportIssueSheet extends StatefulWidget {
  @override
  State<_ReportIssueSheet> createState() => _ReportIssueSheetState();
}
class _ReportIssueSheetState extends State<_ReportIssueSheet> {
  int _selectedIssue = 0;
  final _noteCtrl = TextEditingController();
  bool _submitting = false;
  static const _issues = [
    'مشكلة في جودة الطعام',
    'فشل التبريد',
    'عنوان خاطئ',
    'المستلم غير موجود',
    'أخرى',
  ];
  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ZadColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('الإبلاغ عن مشكلة',
                  style: ZadTextStyles.headlineMd
                      .copyWith(fontFamily: 'Inter')),
              const SizedBox(height: 16),
              ..._issues.asMap().entries.map((e) => GestureDetector(
                    onTap: () => setState(() => _selectedIssue = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedIssue == e.key
                            ? ZadColors.primaryContainer.withValues(alpha: 0.3)
                            : ZadColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedIssue == e.key
                              ? ZadColors.primary
                              : ZadColors.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedIssue == e.key
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: _selectedIssue == e.key
                                ? ZadColors.primary
                                : ZadColors.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(e.value,
                              style: ZadTextStyles.bodyMd
                                  .copyWith(fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              TextField(
                controller: _noteCtrl,
                maxLines: 2,
                style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                decoration: const InputDecoration(
                  labelText: 'ملاحظات إضافية (اختياري)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting
                      ? null
                      : () async {
                          setState(() => _submitting = true);
                          await Future.delayed(const Duration(milliseconds: 800));
                          if (!mounted) return;
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم إرسال البلاغ بنجاح',
                                  style: ZadTextStyles.bodyMd.copyWith(
                                      color: Colors.white,
                                      fontFamily: 'Inter')),
                              backgroundColor: ZadColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZadColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text('إرسال البلاغ',
                          style: ZadTextStyles.headlineMd
                              .copyWith(color: Colors.white, fontFamily: 'Inter')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}