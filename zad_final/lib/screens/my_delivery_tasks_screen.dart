import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'donation_details_screen.dart';
import 'navigate_verify_delivery_screen.dart';
enum TaskStatus { inProgress, upcoming, completed }
class DeliveryTask {
  final String id;
  final String donationTitle;
  final double weightKg;
  final String pickupName;
  final String pickupAddress;
  final String dropoffName;
  final String dropoffAddress;
  final String deadline;
  final TaskStatus status;
  final String imageUrl;
  final String carbonSaved;
  const DeliveryTask({
    required this.id,
    required this.donationTitle,
    required this.weightKg,
    required this.pickupName,
    required this.pickupAddress,
    required this.dropoffName,
    required this.dropoffAddress,
    required this.deadline,
    required this.status,
    required this.imageUrl,
    required this.carbonSaved,
  });
}
class MyDeliveryTasksBody extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const MyDeliveryTasksBody({super.key, required this.onOpenDrawer});
  @override
  State<MyDeliveryTasksBody> createState() => _MyDeliveryTasksBodyState();
}
class _MyDeliveryTasksBodyState extends State<MyDeliveryTasksBody> {
  static const _imgMeals =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAAPWhe58R79uTdES2-B1VovO0e0jRlpmSVrnaQRdUVARAvP9yQi9B6WJqUVvy6pJ9O4PWOGaMIkS0Dwbwefx-BT4g71uTz_eKi0zwSL8R96QSS6DSSHrI_EG3qq_o6D2cYyHh9_mY-D9V-2lS5s8__grI2KzBYrvskGsBcSeYenbd2riVJXUNk9Ho2THz254u7YlPu0_vBFFwibMzOMto4JjG83FsB1mggk3GOFUXxlOh06vNIq2xqKE2_X8vu9FuSexUG9mELF_0';
  static const _imgProduce =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCPbdkRvOozJWOj8BDPs6V5tBbyO4Fxi0GNcqPrH_Hg8dS7ggga-l0REJ8mrWLW4r08bgLjWUk7g6lqzWjlYwBHaEQtgf094J_QZPMbh_EMnREQNEIsNfrWZ3z8of_VNPFAf_k8s2KrTY85XRfUn2MJ1m7XTlll7X5dileWyHTv_-4Cu-LWuPoKY4uBJSpVOmagXT9BFGqzxnXA9ECo0GvB3_JaSXDyZejXLob-dzBvqZPgXnEkcVOI6JL4UFQ9FjdODWPDLhZ8D-Q';
  final List<DeliveryTask> _tasks = [
    const DeliveryTask(
      id: 'T001',
      donationTitle: 'Mansaf Buffet – Grand Hotel Amman',
      weightKg: 25,
      pickupName: 'فندق جراند هيلز',
      pickupAddress: 'شارع الملكة نور، عبدون',
      dropoffName: 'مطبخ المدينة التطوعي',
      dropoffAddress: '45 شارع المجتمع، الحي الشرقي',
      deadline: '4:00 م اليوم',
      status: TaskStatus.inProgress,
      imageUrl: _imgMeals,
      carbonSaved: '3.2 كجم CO₂',
    ),
    const DeliveryTask(
      id: 'T002',
      donationTitle: 'Fresh Vegetables – Jordan Valley',
      weightKg: 15,
      pickupName: 'سوبرماركت كارفور',
      pickupAddress: 'مجمع مرج الحمام التجاري',
      dropoffName: 'جمعية الرحمة الأردنية',
      dropoffAddress: 'شارع الأردن، الزرقاء',
      deadline: '6:00 م اليوم',
      status: TaskStatus.inProgress,
      imageUrl: _imgProduce,
      carbonSaved: '1.8 كجم CO₂',
    ),
    const DeliveryTask(
      id: 'T003',
      donationTitle: 'Taboon Bread & Ka\'ak Surplus',
      weightKg: 8,
      pickupName: 'مخبز الأصيل',
      pickupAddress: 'شارع الجاردنز، وادي السير',
      dropoffName: 'ملجأ دار الأمل',
      dropoffAddress: 'المدينة الرياضية، عمّان',
      deadline: '7:30 م اليوم',
      status: TaskStatus.upcoming,
      imageUrl: _imgMeals,
      carbonSaved: '0.9 كجم CO₂',
    ),
    const DeliveryTask(
      id: 'T004',
      donationTitle: 'Fruits & Juices – Wholesale Market',
      weightKg: 10,
      pickupName: 'سوق الخضار الجديد',
      pickupAddress: 'أبو نصير، شمال عمّان',
      dropoffName: 'مدرسة النور الابتدائية',
      dropoffAddress: 'ضاحية الرشيد، عمّان',
      deadline: 'غداً 9:00 ص',
      status: TaskStatus.upcoming,
      imageUrl: _imgProduce,
      carbonSaved: '1.1 كجم CO₂',
    ),
  ];
  void _onAcceptTask(DeliveryTask task) {
    setState(() {
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _tasks[idx] = DeliveryTask(
          id: task.id,
          donationTitle: task.donationTitle,
          weightKg: task.weightKg,
          pickupName: task.pickupName,
          pickupAddress: task.pickupAddress,
          dropoffName: task.dropoffName,
          dropoffAddress: task.dropoffAddress,
          deadline: task.deadline,
          status: TaskStatus.inProgress,
          imageUrl: task.imageUrl,
          carbonSaved: task.carbonSaved,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم قبول مهمة "${task.donationTitle}" ✓',
          style: ZadTextStyles.bodyMd
              .copyWith(color: Colors.white, fontFamily: 'Inter'),
        ),
        backgroundColor: ZadColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  void _onStartNavigation(DeliveryTask task) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => NavigateVerifyDeliveryScreen(
        mission: DeliveryMission(
          id: task.id,
          title: 'إعادة توزيع: ${task.weightKg.toStringAsFixed(0)}كجم ${task.donationTitle}',
          pickupAddress: task.pickupAddress,
          dropoffAddress: task.dropoffAddress,
          minutesLeft: 12,
          weightKg: task.weightKg,
        ),
      ),
    ));
  }
  void _onScanQR(DeliveryTask task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ZadColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('مسح رمز QR',
            style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: ZadColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ZadColors.outlineVariant),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner,
                      size: 60, color: ZadColors.primary),
                  const SizedBox(height: 8),
                  Text('امسح الرمز الموجود\nعلى الطرد',
                      textAlign: TextAlign.center,
                      style: ZadTextStyles.labelMd.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'المهمة: ${task.donationTitle}',
              style: ZadTextStyles.bodyMd
                  .copyWith(color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ZadColors.primary),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم التحقق من الاستلام ✓ ${task.donationTitle}',
                      style: ZadTextStyles.bodyMd
                          .copyWith(color: Colors.white, fontFamily: 'Inter')),
                  backgroundColor: ZadColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: const Text('تأكيد الاستلام',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  void _onViewDonationDetails(DeliveryTask task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DonationDetailsScreen(
          donation: DonationDetail(
            id: task.id,
            title: task.donationTitle,
            category: 'مواد غذائية',
            imageUrl: task.imageUrl,
            weightKg: task.weightKg,
            expiryLabel: task.deadline,
            isUrgent: task.status == TaskStatus.inProgress,
            tempCelsius: 3.2,
            stabilityPct: 0.85,
            collectionAddress: task.pickupAddress,
            distanceKm: '1.5 كم',
            pickupLoggedTime: '10:45 ص',
            kitchenClearanceTime: '09:12 ص',
            donorName: task.pickupName,
            donorImageUrl: task.imageUrl,
          ),
        ),
      ),
    );
  }
  List<DeliveryTask> get _inProgress =>
      _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
  List<DeliveryTask> get _upcoming =>
      _tasks.where((t) => t.status == TaskStatus.upcoming).toList();
  double get _totalCarbon => _tasks.fold(0, (sum, t) {
        final match = RegExp(r'(\d+\.?\d*)').firstMatch(t.carbonSaved);
        return sum + (match != null ? double.parse(match.group(1)!) : 0);
      });
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: ZadColors.surface,
          elevation: 0,
          leading: IconButton(
            onPressed: widget.onOpenDrawer,
            icon: const Icon(Icons.menu, color: ZadColors.primary),
          ),
          title: Text('ZAD',
              style: ZadTextStyles.headlineLg.copyWith(
                color: ZadColors.primary,
                fontWeight: FontWeight.w900,
                fontFamily: 'Inter',
                letterSpacing: -0.5,
              )),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
                height: 1, color: ZadColors.outlineVariant),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المهام النشطة',
                    style: ZadTextStyles.headlineXl.copyWith(
                        fontFamily: 'Inter',
                        color: ZadColors.onSurface)),
                const SizedBox(height: 4),
                Text(
                  'لديك ${_inProgress.length} توصيلة جارية و${_upcoming.length} قادمة اليوم.',
                  style: ZadTextStyles.bodyMd.copyWith(
                      color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _InProgressCard(
                task: _inProgress[i],
                onScanQR: () => _onScanQR(_inProgress[i]),
                onNavigate: () => _onStartNavigation(_inProgress[i]),
                onViewDetails: () => _onViewDonationDetails(_inProgress[i]),
              ),
            ),
            childCount: _inProgress.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ZadColors.primary,
                  ZadColors.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco, color: Colors.white, size: 40),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('أثرك اليوم',
                          style: ZadTextStyles.headlineMd.copyWith(
                              color: Colors.white,
                              fontFamily: 'Inter')),
                      Text(
                        'وفّرت ${_totalCarbon.toStringAsFixed(1)} كجم CO₂ بتوصيلاتك اليوم.',
                        style: ZadTextStyles.bodyMd.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_upcoming.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text('المهام القادمة',
                  style: ZadTextStyles.headlineMd
                      .copyWith(fontFamily: 'Inter')),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _UpcomingCard(
                task: _upcoming[i],
                onAccept: () => _onAcceptTask(_upcoming[i]),
                onViewDetails: () => _onViewDonationDetails(_upcoming[i]),
              ),
            ),
            childCount: _upcoming.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
class _InProgressCard extends StatelessWidget {
  final DeliveryTask task;
  final VoidCallback onScanQR;
  final VoidCallback onNavigate;
  final VoidCallback onViewDetails;
  const _InProgressCard({
    required this.task,
    required this.onScanQR,
    required this.onNavigate,
    required this.onViewDetails,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZadColors.outlineVariant),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: ZadColors.primary, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('جارٍ التنفيذ',
                    style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.primary,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter')),
                const Spacer(),
                GestureDetector(
                  onTap: onViewDetails,
                  child: Text('التفاصيل',
                      style: ZadTextStyles.labelSm.copyWith(
                          color: ZadColors.primary,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Inter')),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.network(
                      task.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: ZadColors.surfaceContainerHigh,
                          child: const Icon(Icons.fastfood,
                              color: ZadColors.onSurfaceVariant)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.donationTitle,
                          style: ZadTextStyles.headlineMd.copyWith(
                              fontFamily: 'Inter')),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.scale_outlined,
                              size: 13,
                              color: ZadColors.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Text('${task.weightKg} كجم',
                              style: ZadTextStyles.labelSm.copyWith(
                                  color: ZadColors.onSurfaceVariant,
                                  fontFamily: 'Inter')),
                          const SizedBox(width: 10),
                          const Icon(Icons.eco_outlined,
                              size: 13, color: ZadColors.primary),
                          const SizedBox(width: 3),
                          Text(task.carbonSaved,
                              style: ZadTextStyles.labelSm.copyWith(
                                  color: ZadColors.primary,
                                  fontFamily: 'Inter')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ZadColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _RouteRow(
                      icon: Icons.location_on,
                      color: ZadColors.primary,
                      label: 'الاستلام',
                      name: task.pickupName,
                      address: task.pickupAddress),
                  Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: Column(
                      children: List.generate(
                        3,
                        (_) => Container(
                          width: 2,
                          height: 5,
                          margin: const EdgeInsets.symmetric(vertical: 1),
                          color: ZadColors.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                  _RouteRow(
                      icon: Icons.local_shipping,
                      color: ZadColors.secondary,
                      label: 'التسليم',
                      name: task.dropoffName,
                      address: task.dropoffAddress),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(Icons.schedule,
                    size: 14, color: ZadColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('موعد التسليم: ${task.deadline}',
                    style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onScanQR,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ZadColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.qr_code_scanner,
                        size: 16, color: ZadColors.primary),
                    label: Text('مسح QR',
                        style: ZadTextStyles.labelMd.copyWith(
                            color: ZadColors.primary, fontFamily: 'Inter')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onNavigate,
                    style: FilledButton.styleFrom(
                      backgroundColor: ZadColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.navigation,
                        size: 16, color: Colors.white),
                    label: Text('ابدأ التنقل',
                        style: ZadTextStyles.labelMd.copyWith(
                            color: Colors.white, fontFamily: 'Inter')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _UpcomingCard extends StatelessWidget {
  final DeliveryTask task;
  final VoidCallback onAccept;
  final VoidCallback onViewDetails;
  const _UpcomingCard({
    required this.task,
    required this.onAccept,
    required this.onViewDetails,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule,
                  size: 16, color: ZadColors.tertiary),
              const SizedBox(width: 6),
              Text('مهمة قادمة',
                  style: ZadTextStyles.labelSm.copyWith(
                      color: ZadColors.tertiary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter')),
            ],
          ),
          const SizedBox(height: 8),
          Text(task.donationTitle,
              style: ZadTextStyles.headlineMd
                  .copyWith(fontFamily: 'Inter')),
          const SizedBox(height: 4),
          Text(
            '${task.pickupName} → ${task.dropoffName}',
            style: ZadTextStyles.bodyMd.copyWith(
                color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 4),
          Text('موعد الاستلام: ${task.deadline}',
              style: ZadTextStyles.labelSm.copyWith(
                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: ZadColors.outlineVariant),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('التفاصيل',
                      style: ZadTextStyles.labelMd.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onAccept,
                  style: FilledButton.styleFrom(
                    backgroundColor: ZadColors.tertiary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('قبول المهمة',
                      style: ZadTextStyles.labelMd.copyWith(
                          color: Colors.white, fontFamily: 'Inter')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _RouteRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String name;
  final String address;
  const _RouteRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.name,
    required this.address,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: ZadTextStyles.labelSm.copyWith(
                      color: ZadColors.onSurfaceVariant,
                      fontFamily: 'Inter')),
              Text(name,
                  style: ZadTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.w700, fontFamily: 'Inter')),
              Text(address,
                  style: ZadTextStyles.labelSm.copyWith(
                      color: ZadColors.onSurfaceVariant,
                      fontFamily: 'Inter')),
            ],
          ),
        ),
      ],
    );
  }
}