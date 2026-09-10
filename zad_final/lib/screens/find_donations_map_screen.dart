import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'donation_details_screen.dart';
enum DonationStatus { ready, expiringSoon, claimed }
class NearbyDonation {
  final String id;
  final String title;
  final DonationStatus status;
  final double distanceKm;
  final String storageType;
  final int capacity;
  final String imageUrl;
  final String expiryLabel;
  const NearbyDonation({
    required this.id,
    required this.title,
    required this.status,
    required this.distanceKm,
    required this.storageType,
    required this.capacity,
    required this.imageUrl,
    required this.expiryLabel,
  });
}
final _mockNearby = [
  const NearbyDonation(
    id: '1',
    title: 'Assorted Organic Vegetables',
    status: DonationStatus.ready,
    distanceKm: 0.8,
    storageType: 'تبريد',
    capacity: 50,
    imageUrl:
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200',
    expiryLabel: 'جاهز للاستلام',
  ),
  const NearbyDonation(
    id: '2',
    title: 'Artisan Ka\'ak Bakery Batch',
    status: DonationStatus.expiringSoon,
    distanceKm: 1.2,
    storageType: 'جاف',
    capacity: 20,
    imageUrl:
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200',
    expiryLabel: 'ينتهي خلال ساعتين',
  ),
  const NearbyDonation(
    id: '3',
    title: 'Mansaf & Sides – Al-Malaki Hotel',
    status: DonationStatus.ready,
    distanceKm: 2.1,
    storageType: 'تبريد',
    capacity: 80,
    imageUrl:
        'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200',
    expiryLabel: 'جاهز للاستلام',
  ),
  const NearbyDonation(
    id: '4',
    title: 'Seasonal Fruit Box – Jordan Valley',
    status: DonationStatus.expiringSoon,
    distanceKm: 3.4,
    storageType: 'تبريد',
    capacity: 35,
    imageUrl:
        'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=200',
    expiryLabel: 'ينتهي خلال 4 ساعات',
  ),
  const NearbyDonation(
    id: '5',
    title: 'Canned Hummus & Dry Goods',
    status: DonationStatus.claimed,
    distanceKm: 1.7,
    storageType: 'جاف',
    capacity: 100,
    imageUrl:
        'https://images.unsplash.com/photo-1584568694244-14fbdf83bd30?w=200',
    expiryLabel: 'تم الحجز',
  ),
];
class FindDonationsMapBody extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const FindDonationsMapBody({super.key, required this.onOpenDrawer});
  @override
  State<FindDonationsMapBody> createState() => _FindDonationsMapBodyState();
}
class _FindDonationsMapBodyState extends State<FindDonationsMapBody> {
  String _filter = 'الكل';
  String _charitySize = 'كبيرة';
  String _storage = 'تبريد';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  final Set<String> _claimedIds = {};
  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
  List<NearbyDonation> get _filtered {
    return _mockNearby.where((d) {
      if (_filter == 'جاهز' && d.status != DonationStatus.ready) return false;
      if (_filter == 'يوشك على الانتهاء' &&
          d.status != DonationStatus.expiringSoon) return false;
      if (_searchQuery.isNotEmpty &&
          !d.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        return false;
      return true;
    }).toList();
  }
  void _onViewAll() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AllDonationsSheet(donations: _filtered),
    );
  }
  void _onClaim(NearbyDonation item) {
    if (_claimedIds.contains(item.id) || item.status == DonationStatus.claimed)
      return;
    setState(() => _claimedIds.add(item.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✓ تم حجز "${item.title}" بنجاح!',
          style: ZadTextStyles.bodyMd
              .copyWith(color: Colors.white, fontFamily: 'Inter'),
        ),
        backgroundColor: ZadColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  void _onItemTap(NearbyDonation item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DonationDetailSheet(
        item: item,
        isClaimed: _claimedIds.contains(item.id),
        onClaim: () => _onClaim(item),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: ZadColors.background,
      body: Column(
        children: [
          Container(
            color: ZadColors.surface,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onOpenDrawer,
                          child:
                              const Icon(Icons.menu, color: ZadColors.primary),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'ZAD',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: ZadColors.primary,
                          ),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: ZadColors.surfaceContainerHigh,
                          child: ClipOval(
                            child: Image.network(
                              'https://i.pravatar.cc/80?img=5',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person,
                                  color: ZadColors.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: TextField(
                      controller: _searchCtrl,
                      style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن تبرعات قريبة منك...',
                        prefixIcon: const Icon(Icons.search,
                            color: ZadColors.onSurfaceVariant),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: ZadColors.onSurfaceVariant),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: ZadColors.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: ZadColors.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: ZadColors.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: ZadColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'حجم الجمعية: $_charitySize',
                          icon: Icons.people_outline,
                          isActive: true,
                          onTap: () => setState(() {
                            _charitySize =
                                _charitySize == 'كبيرة' ? 'صغيرة' : 'كبيرة';
                          }),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'التخزين: $_storage',
                          icon: Icons.inventory_2_outlined,
                          isActive: false,
                          onTap: () => setState(() {
                            _storage = _storage == 'تبريد' ? 'جاف' : 'تبريد';
                          }),
                        ),
                        const SizedBox(width: 8),
                        ...[
                          'الكل',
                          'جاهز',
                          'يوشك على الانتهاء',
                        ].map((f) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _FilterChip(
                                label: f,
                                isActive: _filter == f,
                                onTap: () => setState(() => _filter = f),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: ZadColors.outlineVariant),
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            color: ZadColors.surfaceContainerLow,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(painter: _MapGridPainter()),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: ZadColors.secondary,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(color: Color(0x33000000), blurRadius: 8)
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'استلام عاجل: 12 كجم',
                            style: ZadTextStyles.labelLg.copyWith(
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 80,
                  child: _MapPin(color: ZadColors.primary, isActive: false),
                ),
                Positioned(
                  top: 50,
                  left: 160,
                  child: _MapPin(color: ZadColors.secondary, isActive: true),
                ),
                Positioned(
                  top: 100,
                  right: 80,
                  child: _MapPin(color: ZadColors.primary, isActive: false),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ZadColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Color(0x44000000), blurRadius: 8)
                        ],
                      ),
                      child: const Icon(Icons.my_location,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Text(
                    'خريطة ZAD – عمّان، الأردن',
                    style: ZadTextStyles.labelSm.copyWith(
                      color: ZadColors.onSurfaceVariant,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: ZadColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مُوصى به لك',
                          style: ZadTextStyles.labelMd.copyWith(
                            color: ZadColors.primary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'مقترح لك',
                              style: ZadTextStyles.headlineLg
                                  .copyWith(fontFamily: 'Inter'),
                            ),
                            TextButton(
                              onPressed: _onViewAll,
                              style: TextButton.styleFrom(
                                foregroundColor: ZadColors.primary,
                                textStyle: ZadTextStyles.labelLg
                                    .copyWith(fontFamily: 'Inter'),
                              ),
                              child: const Text('عرض الكل'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search_off,
                                    size: 48, color: ZadColors.outlineVariant),
                                const SizedBox(height: 12),
                                Text(
                                  'لا توجد نتائج',
                                  style: ZadTextStyles.headlineMd.copyWith(
                                    color: ZadColors.onSurfaceVariant,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              final item = filtered[i];
                              final isClaimed = _claimedIds.contains(item.id);
                              return _NearbyDonationCard(
                                item: item,
                                isClaimed: isClaimed,
                                onTap: () => _onItemTap(item),
                                onClaim: () => _onClaim(item),
                              );
                            },
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
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    this.icon,
    required this.isActive,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? ZadColors.primaryContainer
              : ZadColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive ? ZadColors.primary : ZadColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isActive
                    ? ZadColors.onPrimaryContainer
                    : ZadColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: ZadTextStyles.labelSm.copyWith(
                color: isActive
                    ? ZadColors.onPrimaryContainer
                    : ZadColors.onSurfaceVariant,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCFD8DC)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6;
    canvas.drawLine(Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(Offset(size.width * 0.35, 0),
        Offset(size.width * 0.35, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.7), roadPaint);
  }
  @override
  bool shouldRepaint(_) => false;
}
class _MapPin extends StatelessWidget {
  final Color color;
  final bool isActive;
  const _MapPin({required this.color, required this.isActive});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 36 : 28,
          height: isActive ? 36 : 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)
            ],
          ),
          child: Icon(
            Icons.restaurant,
            color: Colors.white,
            size: isActive ? 20 : 14,
          ),
        ),
        Container(
          width: 2,
          height: 8,
          color: color,
        ),
      ],
    );
  }
}
class _NearbyDonationCard extends StatelessWidget {
  final NearbyDonation item;
  final bool isClaimed;
  final VoidCallback onTap;
  final VoidCallback onClaim;
  const _NearbyDonationCard({
    required this.item,
    required this.isClaimed,
    required this.onTap,
    required this.onClaim,
  });
  Color get _statusColor {
    if (isClaimed || item.status == DonationStatus.claimed)
      return ZadColors.onSurfaceVariant;
    if (item.status == DonationStatus.expiringSoon) return ZadColors.secondary;
    return ZadColors.primary;
  }
  Color get _statusBg {
    if (isClaimed || item.status == DonationStatus.claimed)
      return ZadColors.surfaceContainerHighest;
    if (item.status == DonationStatus.expiringSoon)
      return ZadColors.secondaryFixed;
    return ZadColors.primaryFixed.withValues(alpha: 0.4);
  }
  String get _statusLabel {
    if (isClaimed) return 'تم الحجز';
    if (item.status == DonationStatus.claimed) return 'تم الحجز';
    if (item.status == DonationStatus.expiringSoon) return item.expiryLabel;
    return 'جاهز';
  }
  bool get _isExpiring =>
      item.status == DonationStatus.expiringSoon && !isClaimed;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ZadColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _isExpiring
                    ? ZadColors.secondary
                    : ZadColors.outlineVariant,
                width: _isExpiring ? 4 : 1,
              ),
              top: const BorderSide(color: ZadColors.outlineVariant),
              right: const BorderSide(color: ZadColors.outlineVariant),
              bottom: const BorderSide(color: ZadColors.outlineVariant),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: ZadColors.surfaceContainerHigh,
                        child: const Icon(Icons.fastfood,
                            size: 32, color: ZadColors.onSurfaceVariant),
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
                              item.title,
                              style: ZadTextStyles.headlineMd.copyWith(
                                fontSize: 15,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (isClaimed ||
                                    item.status == DonationStatus.claimed)
                                ? null
                                : onClaim,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: (isClaimed ||
                                        item.status == DonationStatus.claimed)
                                    ? ZadColors.surfaceContainerHigh
                                    : ZadColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (isClaimed ||
                                        item.status == DonationStatus.claimed)
                                    ? 'محجوز'
                                    : 'احجز',
                                style: ZadTextStyles.labelMd.copyWith(
                                  color: (isClaimed ||
                                          item.status == DonationStatus.claimed)
                                      ? ZadColors.onSurfaceVariant
                                      : Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _statusBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _statusLabel,
                          style: ZadTextStyles.labelSm.copyWith(
                            color: _statusColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 13, color: ZadColors.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Text(
                            '${item.distanceKm} كم',
                            style: ZadTextStyles.labelSm.copyWith(
                              color: ZadColors.onSurfaceVariant,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.inventory_2_outlined,
                              size: 13, color: ZadColors.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Text(
                            item.storageType,
                            style: ZadTextStyles.labelSm.copyWith(
                              color: ZadColors.onSurfaceVariant,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.people_outline,
                              size: 13, color: ZadColors.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Text(
                            'سعة: ${item.capacity}+',
                            style: ZadTextStyles.labelSm.copyWith(
                              color: ZadColors.onSurfaceVariant,
                              fontFamily: 'Inter',
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
        ),
      ),
    );
  }
}
class _DonationDetailSheet extends StatelessWidget {
  final NearbyDonation item;
  final bool isClaimed;
  final VoidCallback onClaim;
  const _DonationDetailSheet({
    required this.item,
    required this.isClaimed,
    required this.onClaim,
  });
  @override
  Widget build(BuildContext context) {
    final isUnavailable = isClaimed || item.status == DonationStatus.claimed;
    return Container(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: ZadColors.surfaceContainerHigh,
                      child: const Icon(Icons.fastfood,
                          size: 48, color: ZadColors.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(item.title,
                  style:
                      ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: ZadColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${item.distanceKm} كم • ${item.storageType} • سعة ${item.capacity}+',
                    style: ZadTextStyles.bodyMd.copyWith(
                      color: ZadColors.onSurfaceVariant,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.expiryLabel,
                style: ZadTextStyles.labelMd.copyWith(
                  color: item.status == DonationStatus.expiringSoon
                      ? ZadColors.secondary
                      : ZadColors.primary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DonationDetailsScreen(
                        donation: DonationDetailsScreen.demo,
                      ),
                    ));
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('عرض التفاصيل الكاملة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ZadColors.primary,
                    side: const BorderSide(color: ZadColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: ZadTextStyles.labelMd.copyWith(fontFamily: 'Inter'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      label: const Text('إغلاق'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ZadColors.primary,
                        side: const BorderSide(color: ZadColors.outlineVariant),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isUnavailable
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              onClaim();
                            },
                      icon: Icon(isUnavailable
                          ? Icons.check_circle
                          : Icons.bookmark_add_outlined),
                      label: Text(isUnavailable ? 'تم الحجز' : 'احجز الآن'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZadColors.primary,
                        foregroundColor: ZadColors.onPrimary,
                        disabledBackgroundColor: ZadColors.surfaceContainerHigh,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        textStyle:
                            ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _AllDonationsSheet extends StatelessWidget {
  final List<NearbyDonation> donations;
  const _AllDonationsSheet({required this.donations});
  Color _statusColor(DonationStatus s) {
    switch (s) {
      case DonationStatus.ready: return ZadColors.primary;
      case DonationStatus.expiringSoon: return ZadColors.secondary;
      case DonationStatus.claimed: return ZadColors.onSurfaceVariant;
    }
  }
  String _statusLabel(DonationStatus s) {
    switch (s) {
      case DonationStatus.ready: return 'جاهز';
      case DonationStatus.expiringSoon: return 'يوشك';
      case DonationStatus.claimed: return 'محجوز';
    }
  }
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
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
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: ZadColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('جميع التبرعات القريبة',
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
                itemCount: donations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final d = donations[i];
                  final color = _statusColor(d.status);
                  return Container(
                    padding: const EdgeInsets.all(12),
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
                            width: 56, height: 56,
                            child: Image.network(d.imageUrl, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    color: ZadColors.surfaceContainerHigh,
                                    child: const Icon(Icons.fastfood, color: ZadColors.onSurfaceVariant))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.title,
                                  style: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter')),
                              const SizedBox(height: 2),
                              Text('${d.distanceKm} كم • ${d.storageType}',
                                  style: ZadTextStyles.labelSm.copyWith(
                                      color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                              Text(d.expiryLabel,
                                  style: ZadTextStyles.labelSm.copyWith(
                                      color: color, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(_statusLabel(d.status),
                              style: ZadTextStyles.labelSm.copyWith(
                                  color: color, fontFamily: 'Inter')),
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