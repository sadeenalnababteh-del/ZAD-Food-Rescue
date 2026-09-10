import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class _ImpactMetric {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  const _ImpactMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });
}
class _SectorProgress {
  final String name;
  final IconData icon;
  final double progress;
  final String progressLabel;
  const _SectorProgress({
    required this.name,
    required this.icon,
    required this.progress,
    required this.progressLabel,
  });
}
class _BarData {
  final String month;
  final double value;
  const _BarData(this.month, this.value);
}
final _heroMetrics = [
  _ImpactMetric(
      label: 'طعام محفوظ',
      value: '1,240',
      unit: 'طن',
      icon: Icons.eco,
      color: ZadColors.primary),
  _ImpactMetric(
      label: 'CO₂ موفّر',
      value: '3,100',
      unit: 'طن',
      icon: Icons.co2,
      color: ZadColors.primary),
  _ImpactMetric(
      label: 'ماء محفوظ',
      value: '4.2M',
      unit: 'لتر',
      icon: Icons.water_drop_outlined,
      color: ZadColors.primary),
  _ImpactMetric(
      label: 'وجبات قُدِّمت',
      value: '2.1M',
      unit: 'وجبة',
      icon: Icons.restaurant,
      color: ZadColors.primary),
];
final _sectors = [
  _SectorProgress(
      name: 'قطاع الزراعة',
      icon: Icons.grass,
      progress: 0.72,
      progressLabel: '72% من الهدف'),
  _SectorProgress(
      name: 'قطاع اللوجستيات',
      icon: Icons.local_shipping_outlined,
      progress: 0.48,
      progressLabel: '48% من الهدف'),
  _SectorProgress(
      name: 'قطاع التجزئة',
      icon: Icons.store_outlined,
      progress: 0.89,
      progressLabel: '89% من الهدف'),
];
final _co2Bars = [
  _BarData('يناير', 0.40),
  _BarData('فبراير', 0.55),
  _BarData('مارس', 0.45),
  _BarData('أبريل', 0.70),
  _BarData('مايو', 0.85),
  _BarData('يونيو', 1.0),
];
final _regionalStats = [
  {'label': 'كفاءة إعادة التوزيع', 'value': '94.2%', 'color': ZadColors.primary},
  {'label': 'متوسط وقت التوصيل', 'value': '4.2 ساعة', 'color': ZadColors.secondary},
];
class GlobalSustainabilityImpactScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const GlobalSustainabilityImpactScreen({super.key, this.onOpenDrawer});
  @override
  State<GlobalSustainabilityImpactScreen> createState() =>
      _GlobalSustainabilityImpactScreenState();
}
class _GlobalSustainabilityImpactScreenState
    extends State<GlobalSustainabilityImpactScreen> {
  bool _alertDismissed = false;
  bool _deploying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZadColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: ZadColors.surface,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: ZadColors.primary),
              onPressed: widget.onOpenDrawer,
            ),
            title: Row(
              children: [
                Text('ZAD',
                    style: ZadTextStyles.headlineLg.copyWith(
                        color: ZadColors.primary,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Inter')),
                const SizedBox(width: 12),
                Text('الأثر العالمي',
                    style: ZadTextStyles.labelMd.copyWith(
                        color: ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter')),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                  height: 1, color: ZadColors.outlineVariant),
            ),
            actions: [
              CircleAvatar(
                radius: 16,
                backgroundColor: ZadColors.surfaceContainerHigh,
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/80?img=8',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.person,
                        color: ZadColors.onSurfaceVariant, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _HeroBanner(),
                const SizedBox(height: 20),
                _Co2ChartCard(),
                const SizedBox(height: 16),
                _WaterCard(sectors: _sectors),
                const SizedBox(height: 16),
                _RegionalCard(stats: _regionalStats),
                const SizedBox(height: 16),
                _StakeholderCard(),
                const SizedBox(height: 16),
                if (!_alertDismissed) ...[
                  _UrgencyAlert(
                    onDeploy: () async {
                      setState(() => _deploying = true);
                      await Future.delayed(const Duration(milliseconds: 1000));
                      if (!mounted) return;
                      setState(() {
                        _deploying = false;
                        _alertDismissed = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم نشر فريق الدعم في المنطقة 4',
                              style: ZadTextStyles.bodyMd.copyWith(
                                  color: Colors.white, fontFamily: 'Inter')),
                          backgroundColor: ZadColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    deploying: _deploying,
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ZadColors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.eco,
                size: 140,
                color: ZadColors.onPrimaryContainer.withValues(alpha: 0.1)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ملخص الأثر العالمي',
                  style: ZadTextStyles.labelMd.copyWith(
                      color: ZadColors.onPrimaryContainer.withValues(alpha: 0.85),
                      fontFamily: 'Inter',
                      letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text('قيادة المسؤولية المؤسسية',
                  style: ZadTextStyles.headlineLg.copyWith(
                      color: ZadColors.onPrimaryContainer,
                      fontFamily: 'Inter')),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: _heroMetrics
                    .map((m) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(m.label,
                                style: ZadTextStyles.labelSm.copyWith(
                                    color: ZadColors.onPrimaryContainer
                                        .withValues(alpha: 0.75),
                                    fontFamily: 'Inter')),
                            Text('${m.value} ${m.unit}',
                                style: ZadTextStyles.headlineMd.copyWith(
                                    color: ZadColors.onPrimaryContainer,
                                    fontFamily: 'Inter')),
                          ],
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _Co2ChartCard extends StatefulWidget {
  @override
  State<_Co2ChartCard> createState() => _Co2ChartCardState();
}
class _Co2ChartCardState extends State<_Co2ChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.co2, color: ZadColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('انبعاثات CO₂ الموفّرة',
                        style: ZadTextStyles.headlineMd.copyWith(
                            color: ZadColors.primary, fontFamily: 'Inter')),
                    Text('نمو شهري في تقليل الكربون',
                        style: ZadTextStyles.bodyMd.copyWith(
                            color: ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter')),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ZadColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('+12% مقارنة بالعام الماضي',
                    style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onPrimary, fontFamily: 'Inter')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _co2Bars
                    .map((b) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3),
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${b.month}: ${(b.value * 450).toStringAsFixed(0)} طن',
                                        style: ZadTextStyles.bodyMd.copyWith(
                                            color: Colors.white,
                                            fontFamily: 'Inter')),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 100 * b.value * _anim.value,
                                    decoration: BoxDecoration(
                                      color: ZadColors.primary
                                          .withValues(alpha: 0.3 + b.value * 0.7),
                                      borderRadius:
                                          const BorderRadius.vertical(
                                              top: Radius.circular(4)),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(b.month.substring(0, 3),
                                      style: ZadTextStyles.labelSm.copyWith(
                                          color: ZadColors.onSurfaceVariant,
                                          fontFamily: 'Inter')),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: ZadColors.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الحالي: 450 طن/شهر',
                  style: ZadTextStyles.labelMd.copyWith(
                      color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تفاصيل الاستهلاك: 450 طن/شهر هو المعدل الحالي للتوزيع عبر المناطق الأردنية.',
                        style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter'),
                      ),
                      backgroundColor: ZadColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
                child: Text('عرض التفاصيل',
                    style: ZadTextStyles.labelMd.copyWith(
                        color: ZadColors.primary, fontFamily: 'Inter')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _WaterCard extends StatelessWidget {
  final List<_SectorProgress> sectors;
  const _WaterCard({required this.sectors});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_outlined,
                  color: ZadColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الحفاظ على المياه',
                        style: ZadTextStyles.headlineMd.copyWith(
                            color: ZadColors.primary, fontFamily: 'Inter')),
                    Text('يعادل 1.5 حوض أولمبي محفوظ اليوم',
                        style: ZadTextStyles.bodyMd.copyWith(
                            color: ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sectors.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SectorRow(sector: s),
              )),
        ],
      ),
    );
  }
}
class _SectorRow extends StatelessWidget {
  final _SectorProgress sector;
  const _SectorRow({required this.sector});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: ZadColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(sector.icon, color: ZadColors.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: sector.progress,
                  backgroundColor: ZadColors.surfaceContainerHighest,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ZadColors.primary),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sector.name,
                      style: ZadTextStyles.labelSm.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter')),
                  Text(sector.progressLabel,
                      style: ZadTextStyles.labelMd.copyWith(
                          fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _RegionalCard extends StatelessWidget {
  final List<Map<String, dynamic>> stats;
  const _RegionalCard({required this.stats});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 160,
              color: const Color(0xFFD4E0D4),
              child: Stack(
                children: [
                  CustomPaint(
                      painter: _SimpleMapPainter(),
                      size: const Size(double.infinity, 160)),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: ZadColors.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ZadColors.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('المنطقة النشطة',
                              style: ZadTextStyles.labelSm.copyWith(
                                  color: ZadColors.onSurfaceVariant,
                                  fontFamily: 'Inter')),
                          Text('المملكة الأردنية الهاشمية',
                              style: ZadTextStyles.headlineMd.copyWith(
                                  color: ZadColors.primary,
                                  fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الكفاءة الإقليمية',
                    style: ZadTextStyles.headlineLg
                        .copyWith(fontFamily: 'Inter')),
                const SizedBox(height: 8),
                Text(
                    'حققت شبكتنا اللوجستية كفاءة إعادة توزيع 94% في الربع الأخير، مما قلل وقت الهدر بمعدل 18 ساعة.',
                    style: ZadTextStyles.bodyMd.copyWith(
                        color: ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter')),
                const SizedBox(height: 16),
                Row(
                  children: stats
                      .map((s) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ZadColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: ZadColors.outlineVariant),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s['label'] as String,
                                      style: ZadTextStyles.labelSm.copyWith(
                                          color: ZadColors.onSurfaceVariant,
                                          fontFamily: 'Inter')),
                                  const SizedBox(height: 4),
                                  Text(s['value'] as String,
                                      style: ZadTextStyles.headlineMd
                                          .copyWith(
                                              color: s['color'] as Color,
                                              fontFamily: 'Inter')),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _SimpleMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBFCABA)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final dotPaint = Paint()..color = ZadColors.primary;
    for (final pt in [
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.5),
    ]) {
      canvas.drawCircle(pt, 8, dotPaint);
      canvas.drawCircle(pt, 5, Paint()..color = Colors.white);
      canvas.drawCircle(pt, 3, dotPaint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}
class _StakeholderCard extends StatefulWidget {
  @override
  State<_StakeholderCard> createState() => _StakeholderCardState();
}
class _StakeholderCardState extends State<_StakeholderCard> {
  bool _expanded = false;
  static const _partners = [
    'بنك الطعام الأردني',
    'مطبخ المجتمع ألفا',
    'جمعية الهلال الأحمر',
    'بنك نور للغذاء',
    'مبادرة صفر هدر',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZadColors.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ثقة أصحاب المصلحة',
              style: ZadTextStyles.headlineMd.copyWith(
                  color: ZadColors.onTertiaryContainer, fontFamily: 'Inter')),
          const SizedBox(height: 8),
          Text('انضم 98 شريكاً مجتمعياً لمبادرة "صفر هدر" هذا الشهر.',
              style: ZadTextStyles.bodyMd.copyWith(
                  color: ZadColors.onTertiaryContainer.withValues(alpha: 0.85),
                  fontFamily: 'Inter')),
          const SizedBox(height: 16),
          Row(
            children: [
              ...List.generate(
                  3,
                  (i) => Transform.translate(
                        offset: Offset(i * -10.0, 0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: ZadColors.surfaceContainerHighest,
                          child: Text(['🌿', '🚚', '🤝'][i],
                              style: const TextStyle(fontSize: 16)),
                        ),
                      )),
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 20,
                backgroundColor: ZadColors.surfaceContainerHighest,
                child: Text('+95',
                    style: ZadTextStyles.labelSm.copyWith(
                        fontFamily: 'Inter', fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: _partners
                  .map((p) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.handshake_outlined,
                            color: ZadColors.onTertiaryContainer, size: 18),
                        title: Text(p,
                            style: ZadTextStyles.bodyMd.copyWith(
                                color: ZadColors.onTertiaryContainer,
                                fontFamily: 'Inter')),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: ElevatedButton.styleFrom(
                backgroundColor: ZadColors.onTertiaryContainer,
                foregroundColor: ZadColors.tertiaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(_expanded ? 'إخفاء القائمة' : 'عرض قائمة الشركاء',
                  style: ZadTextStyles.labelMd
                      .copyWith(fontFamily: 'Inter')),
            ),
          ),
        ],
      ),
    );
  }
}
class _UrgencyAlert extends StatelessWidget {
  final VoidCallback onDeploy;
  final bool deploying;
  const _UrgencyAlert({required this.onDeploy, required this.deploying});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZadColors.secondary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ZadColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تنبيه: اختناق لوجستي',
                        style: ZadTextStyles.headlineMd.copyWith(
                            color: ZadColors.secondary, fontFamily: 'Inter')),
                    Text('المنطقة 4 تُسجّل زيادة 20% في الهدر بسبب تأخيرات النقل.',
                        style: ZadTextStyles.bodyMd.copyWith(
                            color: ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: deploying ? null : onDeploy,
              icon: deploying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.support_agent, size: 18),
              label:
                  Text(deploying ? 'جارٍ النشر...' : 'نشر فريق الدعم',
                      style: ZadTextStyles.labelMd
                          .copyWith(fontFamily: 'Inter')),
              style: ElevatedButton.styleFrom(
                backgroundColor: ZadColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}