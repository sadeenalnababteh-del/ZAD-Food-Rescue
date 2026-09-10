import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'donation_details_screen.dart';
class InTransitShipment {
  final String id;
  final String title;
  final String source;
  final String eta;
  final double progressFraction;
  final String distanceLabel;
  final String imageUrl;
  const InTransitShipment({
    required this.id,
    required this.title,
    required this.source,
    required this.eta,
    required this.progressFraction,
    required this.distanceLabel,
    required this.imageUrl,
  });
}
class IncomingItem {
  final String title;
  final double kg;
  final String arrivalTime;
  final String storageType;
  final String imageUrl;
  const IncomingItem({
    required this.title,
    required this.kg,
    required this.arrivalTime,
    required this.storageType,
    required this.imageUrl,
  });
}
final _mockShipments = [
  const InTransitShipment(
    id: '1',
    title: 'Organic Vegetables (Ghor Al-Safi)',
    source: 'مزرعة الوادي الأخضر',
    eta: 'يصل خلال 12 دقيقة',
    progressFraction: 0.85,
    distanceLabel: '85% قريب',
    imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200',
  ),
  const InTransitShipment(
    id: '2',
    title: 'Taboon Bread & Pastries',
    source: 'مخبز الأصيل',
    eta: 'يصل خلال 28 دقيقة',
    progressFraction: 0.45,
    distanceLabel: '45% قريب',
    imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200',
  ),
];
final _mockIncoming = [
  const IncomingItem(
    title: 'Seasonal Vegetable Box',
    kg: 45,
    arrivalTime: '12:45 ظهراً',
    storageType: 'تخزين جاف',
    imageUrl: 'https://images.unsplash.com/photo-1518843875459-f738682238a6?w=200',
  ),
  const IncomingItem(
    title: 'Fatayer & Sambousek Assorted',
    kg: 18,
    arrivalTime: '1:15 ظهراً',
    storageType: 'مخبوزات',
    imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=200',
  ),
  const IncomingItem(
    title: 'Kabsa & Cooked Meals',
    kg: 22,
    arrivalTime: '2:00 ظهراً',
    storageType: 'تبريد',
    imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200',
  ),
];
class ReceiverDashboardBody extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const ReceiverDashboardBody({super.key, required this.onOpenDrawer});
  @override
  State<ReceiverDashboardBody> createState() => _ReceiverDashboardBodyState();
}
class _ReceiverDashboardBodyState extends State<ReceiverDashboardBody> {
  List<InTransitShipment> _shipments = List.from(_mockShipments);
  List<IncomingItem> _incoming = List.from(_mockIncoming);
  final Set<String> _preparedIds = {};
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _shipments = List.from(_mockShipments.reversed);
      _incoming = List.from(_mockIncoming);
    });
  }
  void _onPreparationToggle(int index) {
    final key = _incoming[index].title;
    setState(() {
      if (_preparedIds.contains(key)) {
        _preparedIds.remove(key);
      } else {
        _preparedIds.add(key);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _preparedIds.contains(key)
              ? '✓ تم تجهيز المساحة لـ${_incoming[index].title}'
              : 'تم إلغاء تجهيز ${_incoming[index].title}',
          style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter'),
        ),
        backgroundColor: _preparedIds.contains(key) ? ZadColors.primary : ZadColors.onSurfaceVariant,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  void _onNotificationsTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _ReceiverNotificationsSheet(),
    );
  }
  void _onViewAllIncoming() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AllIncomingSheet(items: _incoming),
    );
  }
  @override
  Widget build(BuildContext context) {
    final preparedCount = _preparedIds.length;
    return Scaffold(
      backgroundColor: ZadColors.background,
      body: RefreshIndicator(
        color: ZadColors.primary,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: ZadColors.surface,
              elevation: 0,
              scrolledUnderElevation: 1,
              surfaceTintColor: ZadColors.surface,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onOpenDrawer,
                    child: const Icon(Icons.menu, color: ZadColors.primary),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'ZAD',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: ZadColors.primary,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: _onNotificationsTap,
                  icon: Badge(
                    backgroundColor: ZadColors.secondary,
                    label: const Text('4'),
                    child: const Icon(Icons.notifications_outlined, color: ZadColors.primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: widget.onOpenDrawer,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: ZadColors.surfaceContainerHigh,
                      child: ClipOval(
                        child: Image.network(
                          'https://i.pravatar.cc/80?img=5',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person, color: ZadColors.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1, color: ZadColors.outlineVariant),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لوحة المطبخ',
                      style: ZadTextStyles.headlineXl.copyWith(fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'مركز التخطيط والتحضير',
                      style: ZadTextStyles.bodyMd.copyWith(
                        color: ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 0, 12),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, color: ZadColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'شحنات في الطريق',
                      style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: ZadColors.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${_shipments.length} نشطة',
                        style: ZadTextStyles.labelSm.copyWith(
                          color: ZadColors.onPrimaryContainer,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 148,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _shipments.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _ShipmentCard(item: _shipments[i]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _ImpactBanner(preparedCount: preparedCount),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatChip(
                        label: 'تسجيلات معلقة',
                        value: '12',
                        subtitle: 'وصول لمسح',
                        valueColor: ZadColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatChip(
                        label: 'مساحة التجميد',
                        value: '15%',
                        subtitle: 'منخفض جداً',
                        valueColor: ZadColors.secondary,
                        isWarning: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المخزون القادم',
                      style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                    ),
                    TextButton(
                      onPressed: _onViewAllIncoming,
                      style: TextButton.styleFrom(
                        foregroundColor: ZadColors.primary,
                        textStyle: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList.separated(
                itemCount: _incoming.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final item = _incoming[i];
                  final isPrepared = _preparedIds.contains(item.title);
                  return _IncomingItemCard(
                    item: item,
                    isPrepared: isPrepared,
                    onPrepare: () => _onPreparationToggle(i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _ShipmentCard extends StatelessWidget {
  final InTransitShipment item;
  const _ShipmentCard({required this.item});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DonationDetailsScreen(donation: DonationDetailsScreen.demo),
      )),
      child: Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: ZadColors.surfaceContainerHigh,
                      child: const Icon(Icons.fastfood, size: 18, color: ZadColors.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.eta,
                      style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.primary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: item.progressFraction,
              minHeight: 6,
              backgroundColor: ZadColors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(ZadColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'من: ${item.source}',
                style: ZadTextStyles.labelSm.copyWith(
                  color: ZadColors.onSurfaceVariant,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                item.distanceLabel,
                style: ZadTextStyles.labelSm.copyWith(
                  color: ZadColors.primary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
class _ImpactBanner extends StatelessWidget {
  final int preparedCount;
  const _ImpactBanner({required this.preparedCount});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ZadColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.eco, color: ZadColors.onPrimaryContainer, size: 20),
              const SizedBox(width: 8),
              Text(
                'التوقع اليومي',
                style: ZadTextStyles.labelMd.copyWith(
                  color: ZadColors.onPrimaryContainer,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
              if (preparedCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: ZadColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$preparedCount مجهّز',
                    style: ZadTextStyles.labelSm.copyWith(
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(children: [
              const TextSpan(
                text: '124',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: ZadColors.onPrimaryContainer,
                ),
              ),
              TextSpan(
                text: ' كجم محفوظة',
                style: ZadTextStyles.headlineMd.copyWith(
                  color: ZadColors.onPrimaryContainer,
                  fontFamily: 'Inter',
                ),
              ),
            ]),
          ),
          const SizedBox(height: 4),
          Text(
            'ما يعادل 295 وجبة للمحتاجين',
            style: ZadTextStyles.labelMd.copyWith(
              color: ZadColors.onPrimaryContainer.withValues(alpha: 0.8),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color valueColor;
  final bool isWarning;
  const _StatChip({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.valueColor,
    this.isWarning = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? ZadColors.secondary.withValues(alpha: 0.3) : ZadColors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ZadTextStyles.labelSm.copyWith(
              color: ZadColors.onSurfaceVariant,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: ZadTextStyles.headlineLg.copyWith(
              color: valueColor,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            subtitle,
            style: ZadTextStyles.labelSm.copyWith(
              color: isWarning ? ZadColors.secondary : ZadColors.onSurfaceVariant,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
class _IncomingItemCard extends StatelessWidget {
  final IncomingItem item;
  final bool isPrepared;
  final VoidCallback onPrepare;
  const _IncomingItemCard({
    required this.item,
    required this.isPrepared,
    required this.onPrepare,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ZadColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPrepare,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrepared ? ZadColors.primary : ZadColors.outlineVariant,
              width: isPrepared ? 1.5 : 1,
            ),
            color: isPrepared ? ZadColors.primaryContainer.withValues(alpha: 0.08) : ZadColors.surface,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: ZadColors.surfaceContainerHigh,
                      child: const Icon(Icons.fastfood, color: ZadColors.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: ZadTextStyles.headlineMd.copyWith(
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.scale_outlined, size: 13, color: ZadColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${item.kg.toStringAsFixed(0)} كجم',
                          style: ZadTextStyles.labelSm.copyWith(
                            color: ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.access_time, size: 13, color: ZadColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          item.arrivalTime,
                          style: ZadTextStyles.labelSm.copyWith(
                            color: ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ZadColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.storageType,
                        style: ZadTextStyles.labelSm.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isPrepared ? ZadColors.primary : ZadColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPrepared ? ZadColors.primary : ZadColors.outlineVariant,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPrepared ? Icons.check : Icons.inventory_2_outlined,
                      size: 18,
                      color: isPrepared ? Colors.white : ZadColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPrepared ? 'جاهز' : 'تجهيز',
                      style: ZadTextStyles.labelSm.copyWith(
                        color: isPrepared ? Colors.white : ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter',
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
}
class _AllIncomingSheet extends StatelessWidget {
  final List<IncomingItem> items;
  const _AllIncomingSheet({required this.items});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'جميع الواردات اليوم',
                    style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            ),
            const Divider(color: ZadColors.outlineVariant),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final item = items[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ZadColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZadColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: ZadColors.surfaceContainerHigh,
                                child: const Icon(Icons.fastfood, color: ZadColors.onSurfaceVariant),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.kg.toStringAsFixed(0)} كجم • ${item.arrivalTime} • ${item.storageType}',
                                style: ZadTextStyles.labelSm.copyWith(
                                  color: ZadColors.onSurfaceVariant,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ZadColors.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'قادم',
                            style: ZadTextStyles.labelSm.copyWith(
                              color: ZadColors.primary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _ReceiverNotificationsSheet extends StatelessWidget {
  const _ReceiverNotificationsSheet();
  static const _notifs = [
    (Icons.local_shipping_outlined, ZadColors.primary, 'شحنة جديدة في الطريق', 'خضروات عضوية 45 كجم – وصول خلال 12 دقيقة', 'الآن'),
    (Icons.warning_amber_rounded, ZadColors.secondary, 'مساحة التجميد منخفضة', 'تبقى 15% فقط – يُنصح بالتفريغ قبل الاستلام', 'منذ 10 دقائق'),
    (Icons.check_circle_outline, ZadColors.primary, 'تم الاستلام بنجاح', 'معجنات متنوعة 18 كجم تم استلامها أمس', 'أمس 3:45 م'),
  ];
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      minChildSize: 0.35,
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
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: ZadColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الإشعارات',
                      style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            ),
            const Divider(color: ZadColors.outlineVariant),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.all(16),
                itemCount: _notifs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final n = _notifs[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ZadColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZadColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: n.$2.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(n.$1, color: n.$2, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.$3,
                                  style: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter')),
                              const SizedBox(height: 2),
                              Text(n.$4,
                                  style: ZadTextStyles.labelSm.copyWith(
                                      color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(n.$5,
                            style: ZadTextStyles.labelSm.copyWith(
                                color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}