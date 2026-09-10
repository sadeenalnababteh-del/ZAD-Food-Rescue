import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'navigate_verify_delivery_screen.dart';
import '../services/firebase_service.dart';
class DonationDetail {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final double weightKg;
  final String expiryLabel;
  final bool isUrgent;
  final double tempCelsius;
  final double stabilityPct;
  final String collectionAddress;
  final String distanceKm;
  final String pickupLoggedTime;
  final String kitchenClearanceTime;
  final String donorName;
  final String donorImageUrl;
  const DonationDetail({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.weightKg,
    required this.expiryLabel,
    required this.isUrgent,
    required this.tempCelsius,
    required this.stabilityPct,
    required this.collectionAddress,
    required this.distanceKm,
    required this.pickupLoggedTime,
    required this.kitchenClearanceTime,
    required this.donorName,
    required this.donorImageUrl,
  });
}
class DonationDetailsScreen extends StatefulWidget {
  final DonationDetail donation;
  const DonationDetailsScreen({super.key, required this.donation});
  static DonationDetail get demo => const DonationDetail(
        id: 'DON-2847',
        title: 'Mujaddara & Fresh Produce Mix',
        category: 'Prepared Meals • Vegetarian',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCPbdkRvOozJWOj8BDPs6V5tBbyO4Fxi0GNcqPrH_Hg8dS7ggga-l0REJ8mrWLW4r08bgLjWUk7g6lqzWjlYwBHaEQtgf094J_QZPMbh_EMnREQNEIsNfrWZ3z8of_VNPFAf_k8s2KrTY85XRfUn2MJ1m7XTlll7X5dileWyHTv_-4Cu-LWuPoKY4uBJSpVOmagXT9BFGqzxnXA9ECo0GvB3_JaSXDyZejXLob-dzBvqZPgXnEkcVOI6JL4UFQ9FjdODWPDLhZ8D-Q',
        weightKg: 12.5,
        expiryLabel: 'ينتهي خلال ساعتين',
        isUrgent: true,
        tempCelsius: 3.2,
        stabilityPct: 0.85,
        collectionAddress: 'المطبخ المركزي – منطقة 4، شارع الأمير محمد',
        distanceKm: '1.2 كم',
        pickupLoggedTime: '10:45 ص',
        kitchenClearanceTime: '09:12 ص',
        donorName: 'فندق كمبينسكي عمّان',
        donorImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA-UMkUYZrXvJrvYKYgtuIvw63iv6dDE4e9s1ZkvK9DgQe3FM2VEGslduvMuQXIVW67XsJ40ZQYvRf9tHkrrphoXfii6uIubXWyVuHS-n-4dfHziQYAxgDdJGxavN2sqPLXaDeGu6ZIBCmQaccWCtmbnoEFXYZSYjO4F1Oa_R5zUEdQlGowyxVHKwDrmj2bWLuzsOrFtR2gzgrbCZ-EWazyYWXJzm1EnPFoyzC42LHBNwXizZCiSYCPiMdwQAqT_-nX5MEnrzcBm6M',
      );
  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}
class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  bool _claimed = false;
  bool _claiming = false;
  void _onGetDirections() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => NavigateVerifyDeliveryScreen(
        mission: NavigateVerifyDeliveryScreen.demo,
      ),
    ));
  }
  Future<void> _onClaim() async {
    setState(() => _claiming = true);
    try {
      await DonationService.claimDonation(widget.donation.id);
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _claiming = false;
      _claimed = true;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ZadColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ZadColors.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: ZadColors.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text('تم الحجز بنجاح!',
                style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Text(
              'تم حجز "${widget.donation.title}" لك. توجّه إلى نقطة الاستلام خلال الوقت المحدد.',
              textAlign: TextAlign.center,
              style: ZadTextStyles.bodyMd.copyWith(
                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
            ),
          ],
        ),
        actions: [
          Center(
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ZadColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ممتاز!',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final d = widget.donation;
    return Scaffold(
      backgroundColor: ZadColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: ZadColors.surface,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ZadColors.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: ZadColors.primary, size: 20),
                  ),
                ),
                title: Text('ZAD',
                    style: ZadTextStyles.headlineLg.copyWith(
                      color: ZadColors.primary,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Inter',
                    )),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        d.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: ZadColors.surfaceContainerHigh,
                          child: const Icon(Icons.restaurant,
                              size: 64,
                              color: ZadColors.onSurfaceVariant),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                      if (d.isUrgent)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: ZadColors.error,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: ZadColors.error.withValues(alpha: 0.4),
                                    blurRadius: 8)
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.priority_high,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text('عاجل',
                                    style: ZadTextStyles.labelMd.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter')),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.title,
                                    style: ZadTextStyles.headlineXl.copyWith(
                                        fontFamily: 'Inter',
                                        color: ZadColors.onBackground)),
                                const SizedBox(height: 2),
                                Text(d.category,
                                    style: ZadTextStyles.bodyMd.copyWith(
                                        color: ZadColors.onSurfaceVariant,
                                        fontFamily: 'Inter')),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${d.weightKg} كجم',
                                  style: ZadTextStyles.headlineMd.copyWith(
                                      color: ZadColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Inter')),
                              Text('الوزن الإجمالي',
                                  style: ZadTextStyles.labelSm.copyWith(
                                      color: ZadColors.onSurfaceVariant,
                                      fontFamily: 'Inter')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: d.isUrgent
                              ? ZadColors.errorContainer.withValues(alpha: 0.3)
                              : ZadColors.primaryContainer.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule,
                                size: 13,
                                color: d.isUrgent
                                    ? ZadColors.error
                                    : ZadColors.primary),
                            const SizedBox(width: 4),
                            Text(d.expiryLabel,
                                style: ZadTextStyles.labelSm.copyWith(
                                    color: d.isUrgent
                                        ? ZadColors.error
                                        : ZadColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_user,
                                    color: ZadColors.primary, size: 18),
                                const SizedBox(width: 8),
                                Text('جواز الصحة الرقمي',
                                    style: ZadTextStyles.labelLg.copyWith(
                                        fontFamily: 'Inter')),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: ZadColors.primaryContainer
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('سجل آمن',
                                      style: ZadTextStyles.labelSm.copyWith(
                                          color: ZadColors.onPrimaryContainer,
                                          fontFamily: 'Inter')),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _HealthMetric(
                                    label: 'درجة الحرارة',
                                    value: '${d.tempCelsius}°C',
                                    progress: d.stabilityPct,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _HealthMetric(
                                    label: 'الاستقرار',
                                    value: 'مثالي',
                                    isOptimal: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                                color: ZadColors.outlineVariant, height: 1),
                            const SizedBox(height: 12),
                            _LogRow(
                                dot: ZadColors.primary,
                                label: 'تم تسجيل الاستلام',
                                time: d.pickupLoggedTime),
                            const SizedBox(height: 6),
                            _LogRow(
                                dot: ZadColors.primary,
                                label: 'تصريح المطبخ',
                                time: d.kitchenClearanceTime),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Image.network(
                                  d.donorImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: ZadColors.surfaceContainerHigh,
                                    child: const Icon(Icons.business,
                                        color: ZadColors.onSurfaceVariant),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('المانح',
                                      style: ZadTextStyles.labelSm.copyWith(
                                          color: ZadColors.onSurfaceVariant,
                                          fontFamily: 'Inter')),
                                  Text(d.donorName,
                                      style: ZadTextStyles.bodyMd.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Inter')),
                                ],
                              ),
                            ),
                            const Icon(Icons.verified,
                                color: ZadColors.primary, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('نقطة الاستلام',
                                style: ZadTextStyles.labelLg
                                    .copyWith(fontFamily: 'Inter')),
                            const SizedBox(height: 10),
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                color: ZadColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: ZadColors.outlineVariant),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    painter: _MapGridPainter(),
                                    size: const Size(double.infinity, 130),
                                  ),
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: ZadColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: ZadColors.primary
                                                .withValues(alpha: 0.4),
                                            blurRadius: 10)
                                      ],
                                    ),
                                    child: const Icon(Icons.location_on,
                                        color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 15, color: ZadColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(d.collectionAddress,
                                      style: ZadTextStyles.bodyMd.copyWith(
                                          color: ZadColors.onSurfaceVariant,
                                          fontFamily: 'Inter')),
                                ),
                                const SizedBox(width: 8),
                                Text(d.distanceKm,
                                    style: ZadTextStyles.labelMd.copyWith(
                                        color: ZadColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: ZadColors.surface,
                border: const Border(
                    top: BorderSide(color: ZadColors.outlineVariant)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 12,
                      offset: const Offset(0, -4))
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: _onGetDirections,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ZadColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.directions,
                          color: ZadColors.primary, size: 18),
                      label: Text('التنقل',
                          style: ZadTextStyles.labelLg.copyWith(
                              color: ZadColors.primary, fontFamily: 'Inter')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _claimed || _claiming ? null : _onClaim,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            _claimed ? ZadColors.primaryContainer : ZadColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: _claiming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Icon(
                              _claimed
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: Colors.white,
                              size: 18),
                      label: Text(
                          _claimed
                              ? 'تم الحجز ✓'
                              : (_claiming ? 'جارٍ الحجز...' : 'احجز الآن'),
                          style: ZadTextStyles.labelLg.copyWith(
                              color: Colors.white, fontFamily: 'Inter')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: child,
    );
  }
}
class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final double? progress;
  final bool isOptimal;
  const _HealthMetric({
    required this.label,
    required this.value,
    this.progress,
    this.isOptimal = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: ZadTextStyles.labelSm.copyWith(
                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
          const SizedBox(height: 4),
          Text(value,
              style: ZadTextStyles.headlineMd.copyWith(
                  color:
                      isOptimal ? ZadColors.primary : ZadColors.onSurface,
                  fontFamily: 'Inter')),
          if (progress != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: ZadColors.surfaceContainerHigh,
                color: ZadColors.primary,
                minHeight: 4,
              ),
            ),
          ] else if (isOptimal) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (_) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                      color: ZadColors.primary, shape: BoxShape.circle),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
class _LogRow extends StatelessWidget {
  final Color dot;
  final String label;
  final String time;
  const _LogRow(
      {required this.dot, required this.label, required this.time});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter')),
        ),
        Text(time,
            style: ZadTextStyles.labelSm.copyWith(
                color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
      ],
    );
  }
}
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ZadColors.outlineVariant.withValues(alpha: 0.5)
      ..strokeWidth = 0.8;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final road = Paint()
      ..color = ZadColors.outlineVariant.withValues(alpha: 0.8)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        road);
    canvas.drawLine(
        Offset(size.width * 0.4, 0),
        Offset(size.width * 0.4, size.height),
        road);
  }
  @override
  bool shouldRepaint(_) => false;
}