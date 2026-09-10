import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'donation_details_screen.dart';
enum DonationTrackerStatus { active, pending, delivered, expired }
class TrackedDonation {
  final String id;
  final String title;
  final String imageUrl;
  final double weightKg;
  final String pickupBy;
  final String pickupRole;
  final String expiryTime;
  final DonationTrackerStatus status;
  final String location;
  const TrackedDonation({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.weightKg,
    required this.pickupBy,
    required this.pickupRole,
    required this.expiryTime,
    required this.status,
    required this.location,
  });
}
class MyDonationsTrackerBody extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const MyDonationsTrackerBody({super.key, required this.onOpenDrawer});
  @override
  State<MyDonationsTrackerBody> createState() => _MyDonationsTrackerBodyState();
}
class _MyDonationsTrackerBodyState extends State<MyDonationsTrackerBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  static const _imgSalad =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAD88vwkJh9V1KjQtF5cI29Bqt5wJktJnP5Ob-xLwqUZ-cNTzIQKzI1qVNchWxneRsyuVA4FX_y5DgDrg_NE4WFuxfXt4spNZbaYLmxxYJUa7jLWB8QS1_0Xfk8CDJXyXvV17Q9kqG-0FaTK2ZNDO9A45ZL9Y41DCgYzkVd-nqzy6gtgl2VeDOnIEBwZ0RxORE4HETtJ264j2BjPIYESETlt_uu2RiAeUQpwqRqhNe6sVAK53-CSzJXtJYkHqQIkTHTPebhPS_MjcQ';
  static const _imgBread =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDndWqx72_dhNGICBXqRMPh32pzHMy25CYD5rV5xaAqdKyJLKS6xt7PMj-1cu_HUptyGr3N_MWd2WisvoapW2UH6yCcZm2bNoLYtTTeH_YXHuIcQ1E6lrRynmaXPZAngp3BJspAVDTH2C7zF1GfnBNajlD-1Z-apIcAtGeDYSpLZfUQBSBkA2VLevP9apsD1P2pm123ONJpxtw06uvX4H7Ki3Is8dtWtl519tzXVf8gHtaGAS219ZH3GFFUq47wR3o-EwyBYXEW_Ck';
  static const _imgFruits =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAgtIAYsUtGx9x5sFVfWduAhahIvbWZruAtMYLOHwK6cblarTJLaLcULuYTs9XwUKrSHdU0q7kE463z3YLf8FhHr6rl7zsRQ-gNecBZ9kZ7zykg7wigmjWh9HB6sfAfXtq_Jkqu51C9P3PYhAACN6SVS9Q50fTagohapDJKOjPvTqSvoUm_PbkgbOZk91hb-vxN84frRTi1Ntgv_uMPwm1Wu6aSdtGYzNTudZBAqEIra8YyH-fA-DGmbnjsULicxbpWPSCkcQ46ZTo';
  final _active = const [
    TrackedDonation(
      id: 'D001',
      title: 'Fresh Fatoush & Garden Salad',
      imageUrl: _imgSalad,
      weightKg: 12,
      pickupBy: 'أحمد المتطوع',
      pickupRole: 'سائق',
      expiryTime: 'اليوم 6:00 م',
      status: DonationTrackerStatus.active,
      location: 'مطبخ فندق الماريوت – شارع الملكة نور',
    ),
    TrackedDonation(
      id: 'D002',
      title: 'Artisan Ka\'ak & Taboon Mix',
      imageUrl: _imgBread,
      weightKg: 8.5,
      pickupBy: 'جمعية الرحمة',
      pickupRole: 'جمعية خيرية',
      expiryTime: 'اليوم 4:30 م',
      status: DonationTrackerStatus.pending,
      location: 'مخبز الأصيل – وادي السير',
    ),
    TrackedDonation(
      id: 'D003',
      title: 'Organic Fruit Boxes – Ajloun',
      imageUrl: _imgFruits,
      weightKg: 18,
      pickupBy: 'سارة الطيب',
      pickupRole: 'سائقة',
      expiryTime: 'غداً 10:00 ص',
      status: DonationTrackerStatus.active,
      location: 'سوق الخضار المركزي – الوحدات',
    ),
  ];
  final _history = const [
    TrackedDonation(
      id: 'D004',
      title: 'Kabsa & Maqlouba Cooked Meals',
      imageUrl: _imgSalad,
      weightKg: 22,
      pickupBy: 'دار الأيتام الأردنية',
      pickupRole: 'جمعية خيرية',
      expiryTime: 'تم التسليم أمس',
      status: DonationTrackerStatus.delivered,
      location: 'مطعم بيت الأردن – الشميساني',
    ),
    TrackedDonation(
      id: 'D005',
      title: 'Jameed & Dairy Products',
      imageUrl: _imgBread,
      weightKg: 5,
      pickupBy: '—',
      pickupRole: '—',
      expiryTime: 'انتهت صلاحيتها',
      status: DonationTrackerStatus.expired,
      location: 'سوبرماركت كارفور – مرج الحمام',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _isRefreshing = false);
  }
  void _onCardTap(TrackedDonation d) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DonationTrackerDetailSheet(donation: d),
    );
  }
  void _onCancelDonation(TrackedDonation d) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ZadColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('إلغاء التبرع',
            style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
        content: Text(
          'هل أنت متأكد من إلغاء تبرع "${d.title}"؟ لا يمكن التراجع عن هذا الإجراء.',
          style: ZadTextStyles.bodyMd
              .copyWith(color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('تراجع'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ZadColors.error),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إلغاء "${d.title}"',
                      style: ZadTextStyles.bodyMd
                          .copyWith(color: Colors.white, fontFamily: 'Inter')),
                  backgroundColor: ZadColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: const Text('إلغاء التبرع',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: ZadColors.surface,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: widget.onOpenDrawer,
                        icon: const Icon(Icons.menu,
                            color: ZadColors.primary, size: 26),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ZAD',
                        style: ZadTextStyles.headlineLg.copyWith(
                          color: ZadColors.primary,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Inter',
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _onRefresh,
                        icon: AnimatedRotation(
                          turns: _isRefreshing ? 1 : 0,
                          duration: const Duration(milliseconds: 600),
                          child: const Icon(Icons.refresh,
                              color: ZadColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تبرعاتي',
                            style: ZadTextStyles.headlineXl.copyWith(
                                fontFamily: 'Inter',
                                color: ZadColors.onBackground)),
                        Text(
                          'تابع عمليات إعادة توزيع الطعام في الوقت الفعلي.',
                          style: ZadTextStyles.bodyMd.copyWith(
                              color: ZadColors.onSurfaceVariant,
                              fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'إجمالي ما أنقذته',
                          value: '124 كجم',
                          color: ZadColors.primaryContainer,
                          onColor: ZadColors.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'مستلَم حالياً',
                          value: '${_active.where((d) => d.status == DonationTrackerStatus.active).length} عناصر',
                          color: ZadColors.surface,
                          onColor: ZadColors.primary,
                          border: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ZadColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: ZadColors.surface,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1))
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: ZadColors.primary,
                    unselectedLabelColor: ZadColors.onSurfaceVariant,
                    labelStyle: ZadTextStyles.labelLg
                        .copyWith(fontFamily: 'Inter', fontWeight: FontWeight.w700),
                    unselectedLabelStyle:
                        ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                    tabs: const [
                      Tab(text: 'القوائم النشطة'),
                      Tab(text: 'السجل السابق'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: ZadColors.outlineVariant),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _DonationList(
                items: _active,
                onTap: _onCardTap,
                onCancel: _onCancelDonation,
                emptyMessage: 'لا توجد تبرعات نشطة حالياً',
              ),
              _DonationList(
                items: _history,
                onTap: _onCardTap,
                showCancel: false,
                emptyMessage: 'لا يوجد سجل سابق',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color onColor;
  final bool border;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.onColor,
    this.border = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: border ? Border.all(color: ZadColors.outlineVariant) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: ZadTextStyles.labelMd.copyWith(
                  color: onColor.withValues(alpha: 0.8), fontFamily: 'Inter')),
          const SizedBox(height: 2),
          Text(value,
              style: ZadTextStyles.headlineLg.copyWith(
                  color: onColor,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter')),
        ],
      ),
    );
  }
}
class _DonationList extends StatelessWidget {
  final List<TrackedDonation> items;
  final void Function(TrackedDonation) onTap;
  final void Function(TrackedDonation)? onCancel;
  final bool showCancel;
  final String emptyMessage;
  const _DonationList({
    required this.items,
    required this.onTap,
    this.onCancel,
    this.showCancel = true,
    required this.emptyMessage,
  });
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56, color: ZadColors.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(emptyMessage,
                style: ZadTextStyles.bodyMd.copyWith(
                    color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: ZadColors.primary,
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _TrackedDonationCard(
          donation: items[i],
          onTap: () => onTap(items[i]),
          onCancel: showCancel && onCancel != null
              ? () => onCancel!(items[i])
              : null,
        ),
      ),
    );
  }
}
class _TrackedDonationCard extends StatelessWidget {
  final TrackedDonation donation;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  const _TrackedDonationCard({
    required this.donation,
    required this.onTap,
    this.onCancel,
  });
  Color _statusColor(DonationTrackerStatus s) {
    switch (s) {
      case DonationTrackerStatus.active:
        return ZadColors.primary;
      case DonationTrackerStatus.pending:
        return ZadColors.tertiary;
      case DonationTrackerStatus.delivered:
        return ZadColors.primaryContainer;
      case DonationTrackerStatus.expired:
        return ZadColors.error;
    }
  }
  String _statusLabel(DonationTrackerStatus s) {
    switch (s) {
      case DonationTrackerStatus.active:
        return 'جارٍ الاستلام';
      case DonationTrackerStatus.pending:
        return 'بانتظار المستلم';
      case DonationTrackerStatus.delivered:
        return 'تم التسليم';
      case DonationTrackerStatus.expired:
        return 'منتهي الصلاحية';
    }
  }
  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(donation.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ZadColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ZadColors.outlineVariant),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        donation.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: ZadColors.surfaceContainerHigh,
                          child: const Icon(Icons.fastfood,
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                donation.title,
                                style: ZadTextStyles.headlineMd.copyWith(
                                    fontFamily: 'Inter',
                                    color: ZadColors.onBackground),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _statusLabel(donation.status),
                                style: ZadTextStyles.labelSm.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _InfoChip(
                                icon: Icons.scale_outlined,
                                label: '${donation.weightKg} كجم'),
                            const SizedBox(width: 12),
                            _InfoChip(
                                icon: Icons.schedule_outlined,
                                label: donation.expiryTime,
                                color: donation.status ==
                                        DonationTrackerStatus.expired
                                    ? ZadColors.error
                                    : ZadColors.onSurfaceVariant),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 13,
                                color: ZadColors.onSurfaceVariant),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                donation.location,
                                style: ZadTextStyles.labelSm.copyWith(
                                    color: ZadColors.onSurfaceVariant,
                                    fontFamily: 'Inter'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: ZadColors.outlineVariant)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 14, color: ZadColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${donation.pickupBy} (${donation.pickupRole})',
                    style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
                  ),
                  const Spacer(),
                  if (onCancel != null) ...[
                    GestureDetector(
                      onTap: onCancel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ZadColors.errorContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('إلغاء',
                            style: ZadTextStyles.labelSm.copyWith(
                                color: ZadColors.error,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter')),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ZadColors.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('التفاصيل',
                          style: ZadTextStyles.labelSm.copyWith(
                              color: ZadColors.primary,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _InfoChip({required this.icon, required this.label, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? ZadColors.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: c),
        const SizedBox(width: 3),
        Text(label,
            style: ZadTextStyles.labelSm.copyWith(
                color: c, fontFamily: 'Inter', fontWeight: FontWeight.w600)),
      ],
    );
  }
}
class _DonationTrackerDetailSheet extends StatelessWidget {
  final TrackedDonation donation;
  const _DonationTrackerDetailSheet({required this.donation});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: ZadColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: ZadColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 180,
                      child: Image.network(donation.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              color: ZadColors.surfaceContainerHigh,
                              child: const Icon(Icons.fastfood, size: 48,
                                  color: ZadColors.onSurfaceVariant))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(donation.title,
                      style: ZadTextStyles.headlineXl.copyWith(
                          fontFamily: 'Inter', color: ZadColors.onBackground)),
                  const SizedBox(height: 4),
                  Text(donation.location,
                      style: ZadTextStyles.bodyMd.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter')),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ZadColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZadColors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                            icon: Icons.scale_outlined,
                            label: 'الوزن',
                            value: '${donation.weightKg} كجم'),
                        const Divider(color: ZadColors.outlineVariant, height: 16),
                        _DetailRow(
                            icon: Icons.schedule_outlined,
                            label: 'ينتهي',
                            value: donation.expiryTime),
                        const Divider(color: ZadColors.outlineVariant, height: 16),
                        _DetailRow(
                            icon: Icons.person_outline,
                            label: 'المستلم',
                            value:
                                '${donation.pickupBy} (${donation.pickupRole})'),
                        const Divider(color: ZadColors.outlineVariant, height: 16),
                        _DetailRow(
                            icon: Icons.tag_outlined,
                            label: 'رقم التبرع',
                            value: '#${donation.id}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('مراحل التبرع',
                      style: ZadTextStyles.headlineMd.copyWith(
                          fontFamily: 'Inter')),
                  const SizedBox(height: 12),
                  _TimelineStep(
                      icon: Icons.check_circle,
                      label: 'تم إنشاء التبرع',
                      time: 'اليوم 8:00 ص',
                      done: true),
                  _TimelineStep(
                      icon: Icons.local_shipping_outlined,
                      label: 'في طريق الاستلام',
                      time: 'اليوم 10:30 ص',
                      done: donation.status == DonationTrackerStatus.active ||
                          donation.status == DonationTrackerStatus.delivered),
                  _TimelineStep(
                      icon: Icons.home_outlined,
                      label: 'تم التسليم',
                      time: donation.status == DonationTrackerStatus.delivered
                          ? 'أمس 3:00 م'
                          : '—',
                      done: donation.status == DonationTrackerStatus.delivered),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: ZadColors.outlineVariant),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('إغلاق',
                              style: ZadTextStyles.labelLg.copyWith(
                                  color: ZadColors.onSurfaceVariant,
                                  fontFamily: 'Inter')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => DonationDetailsScreen(
                                donation: DonationDetailsScreen.demo,
                              ),
                            ));
                          },
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text('التفاصيل'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ZadColors.primary,
                            foregroundColor: ZadColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            textStyle: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: ZadColors.primary),
        const SizedBox(width: 8),
        Text(label,
            style: ZadTextStyles.labelMd.copyWith(
                color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
        const Spacer(),
        Text(value,
            style: ZadTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w600, fontFamily: 'Inter')),
      ],
    );
  }
}
class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final bool done;
  const _TimelineStep(
      {required this.icon,
      required this.label,
      required this.time,
      required this.done});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: done
                  ? ZadColors.primary
                  : ZadColors.onSurfaceVariant.withValues(alpha: 0.4)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: ZadTextStyles.bodyMd.copyWith(
                    color: done
                        ? ZadColors.onSurface
                        : ZadColors.onSurfaceVariant,
                    fontFamily: 'Inter')),
          ),
          Text(time,
              style: ZadTextStyles.labelSm.copyWith(
                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
        ],
      ),
    );
  }
}