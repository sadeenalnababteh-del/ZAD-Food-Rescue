import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

String _imageForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'urgent':
      return 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200';
    case 'fresh':
      return 'https://images.unsplash.com/photo-1518843875459-f738682238a6?w=200';
    case 'moderate':
      return 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200';
    default:
      return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200';
  }
}

class ProviderDashboardBody extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const ProviderDashboardBody({super.key, required this.onOpenDrawer});

  @override
  State<ProviderDashboardBody> createState() => _ProviderDashboardBodyState();
}

class _ProviderDashboardBodyState extends State<ProviderDashboardBody> {
  void _onAddDonation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddDonationSheet(),
    );
  }

  void _onDonationTap(QueryDocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _DonationDetailSheet(doc: doc),
    );
  }

  void _onNotificationsTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _NotificationsSheet(),
    );
  }

  Future<void> _onDeleteDonation(String docId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف التبرع', style: TextStyle(fontFamily: 'Inter')),
        content: Text(
          'هل تريد حذف "$title"؟ هذا الإجراء لا يمكن التراجع عنه.',
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Inter')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: ZadColors.error),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await DonationService.deleteDonation(docId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم حذف "$title" بنجاح',
            style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter'),
          ),
          backgroundColor: ZadColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الحذف: ${e.toString()}',
              style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter')),
          backgroundColor: ZadColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZadColors.background,
      body: CustomScrollView(
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
                  label: const Text('3'),
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
                        'https://i.pravatar.cc/80?img=8',
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
                    'The Impact Hub',
                    style: ZadTextStyles.headlineXl.copyWith(fontFamily: 'Inter'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Real-time donation tracking and sustainability metrics.',
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
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: const _ImpactBento(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
              child: Text(
                'Current Donations',
                style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: DonationService.getMyDonations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator(color: ZadColors.primary)),
                  ),
                );
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ZadColors.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'خطأ في تحميل البيانات: ${snapshot.error}',
                        style: ZadTextStyles.bodyMd.copyWith(
                            color: ZadColors.onErrorContainer, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                );
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: ZadColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ZadColors.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.volunteer_activism_outlined,
                              size: 48, color: ZadColors.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد تبرعات بعد',
                            style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'اضغط + لإضافة أول تبرع',
                            style: ZadTextStyles.bodyMd.copyWith(
                                color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final doc = docs[i];
                    final data = doc.data() as Map<String, dynamic>;
                    return _DonationCard(
                      doc: doc,
                      onTap: () => _onDonationTap(doc),
                      onDelete: () => _onDeleteDonation(doc.id, data['title'] ?? ''),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddDonation,
        tooltip: 'Add Donation',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

class _ImpactBento extends StatelessWidget {
  const _ImpactBento();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SurfaceCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL IMPACT',
                    style: ZadTextStyles.labelMd.copyWith(
                      color: ZadColors.onSurfaceVariant,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Icon(Icons.eco, color: ZadColors.primary),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: '124',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: ZadColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: ' kg Saved',
                      style: ZadTextStyles.headlineMd.copyWith(
                        color: ZadColors.primary.withValues(alpha: 0.8),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: ZadColors.outlineVariant),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatColumn(label: 'Tax-Deductible Value', value: '412.50 JD'),
                  _StatColumn(
                    label: 'Donations',
                    value: '18 Items',
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SurfaceCard(
                child: Column(
                  children: [
                    const Icon(Icons.water_drop, color: ZadColors.tertiary, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      '3,400L',
                      style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Water Saved',
                      style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SurfaceCard(
                child: Column(
                  children: [
                    const Icon(Icons.co2, color: ZadColors.secondary, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      '240kg',
                      style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'CO\u2082 Diverted',
                      style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;
  const _StatColumn({
    required this.label,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: ZadTextStyles.labelSm.copyWith(
            color: ZadColors.onSurfaceVariant,
            fontFamily: 'Inter',
          ),
        ),
        Text(value, style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
      ],
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;
  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: child,
    );
  }
}

class _DonationCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _DonationCard({required this.doc, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final title = data['title'] as String? ?? 'تبرع';
    final weightKg = (data['weightKg'] as num?)?.toDouble() ?? 0.0;
    final status = data['status'] as String? ?? 'متاح';
    final isUrgent = data['isUrgent'] as bool? ?? false;
    final category = data['category'] as String? ?? '';

    final statusColor = status == 'محجوز' ? ZadColors.secondary : ZadColors.primary;
    final urgencyColor = isUrgent ? ZadColors.error : ZadColors.primary;
    final urgencyLabel = isUrgent ? 'عاجل' : category;

    return Dismissible(
      key: Key(doc.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: ZadColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text('حذف', style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontSize: 12)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Material(
        color: ZadColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ZadColors.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.network(
                      _imageForCategory(category),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: ZadColors.surfaceContainerHigh,
                        child: const Icon(Icons.fastfood,
                            color: ZadColors.onSurfaceVariant, size: 30),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: ZadTextStyles.headlineMd.copyWith(
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${weightKg.toStringAsFixed(1)} kg',
                            style: ZadTextStyles.labelMd.copyWith(
                              color: ZadColors.onSurfaceVariant,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        urgencyLabel.toUpperCase(),
                        style: ZadTextStyles.labelSm.copyWith(
                          color: urgencyColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: ZadTextStyles.labelSm.copyWith(
                            color: statusColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: ZadColors.error, size: 20),
                  tooltip: 'حذف',
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
  final QueryDocumentSnapshot doc;
  const _DonationDetailSheet({required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final title = data['title'] as String? ?? 'تبرع';
    final weightKg = (data['weightKg'] as num?)?.toDouble() ?? 0.0;
    final status = data['status'] as String? ?? 'متاح';
    final category = data['category'] as String? ?? '';
    final address = data['collectionAddress'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
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
              Text(title, style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
              const SizedBox(height: 16),
              _DetailRow(icon: Icons.scale_outlined, label: 'الوزن', value: '${weightKg.toStringAsFixed(1)} كجم'),
              _DetailRow(icon: Icons.category_outlined, label: 'الفئة', value: category),
              _DetailRow(icon: Icons.location_on_outlined, label: 'موقع التسليم', value: address),
              _DetailRow(icon: Icons.info_outline, label: 'الحالة', value: status),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: ZadColors.primary, size: 18),
          const SizedBox(width: 10),
          Text('$label: ',
              style: ZadTextStyles.labelMd
                  .copyWith(color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
          Expanded(
            child: Text(value,
                style: ZadTextStyles.labelMd.copyWith(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'title': 'طلب استلام جديد', 'body': 'طلبت جمعية الرحمة استلام تبرعك', 'time': 'منذ 5 دقائق', 'icon': Icons.notifications_active_outlined, 'color': ZadColors.primary},
      {'title': 'تم تسليم التبرع', 'body': 'تم توصيل Mansaf & Rice Trays بنجاح', 'time': 'منذ ساعتين', 'icon': Icons.check_circle_outline, 'color': ZadColors.secondary},
      {'title': 'تبرع على وشك الانتهاء', 'body': 'Ka\'ak & Za\'atar Bread – باقي ساعتان', 'time': 'منذ 3 ساعات', 'icon': Icons.timer_outlined, 'color': ZadColors.error},
    ];
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
                width: 40,
                height: 4,
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
                  Text('الإشعارات',
                      style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إغلاق',
                        style: TextStyle(fontFamily: 'Inter', color: ZadColors.primary)),
                  ),
                ],
              ),
            ),
            const Divider(color: ZadColors.outlineVariant),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final n = notifications[i];
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
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: (n['color'] as Color).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(n['icon'] as IconData,
                              color: n['color'] as Color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n['title'] as String,
                                  style: ZadTextStyles.labelLg
                                      .copyWith(fontFamily: 'Inter')),
                              const SizedBox(height: 2),
                              Text(n['body'] as String,
                                  style: ZadTextStyles.bodyMd.copyWith(
                                      color: ZadColors.onSurfaceVariant,
                                      fontFamily: 'Inter')),
                              const SizedBox(height: 2),
                              Text(n['time'] as String,
                                  style: ZadTextStyles.labelSm.copyWith(
                                      color: ZadColors.outline,
                                      fontFamily: 'Inter')),
                            ],
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

class _AddDonationSheet extends StatefulWidget {
  const _AddDonationSheet();

  @override
  State<_AddDonationSheet> createState() => _AddDonationSheetState();
}

class _AddDonationSheetState extends State<_AddDonationSheet> {
  final _titleCtrl = TextEditingController();
  final _kgCtrl = TextEditingController();
  int _urgencyIndex = 1;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();
  static const _urgencies = ['Urgent', 'Fresh', 'Moderate'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _kgCtrl.dispose();
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
          child: Form(
            key: _formKey,
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
                Text(
                  'Add Donation',
                  style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleCtrl,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(labelText: 'Food Item Name'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _kgCtrl,
                  keyboardType: TextInputType.number,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  validator: (v) =>
                      (v == null || double.tryParse(v) == null) ? 'Enter a valid number' : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Urgency Level',
                  style: ZadTextStyles.labelMd.copyWith(
                    color: ZadColors.onSurfaceVariant,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(_urgencies.length, (i) {
                    final selected = i == _urgencyIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _urgencyIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? ZadColors.primaryContainer
                                : ZadColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected ? ZadColors.primary : ZadColors.outlineVariant,
                            ),
                          ),
                          child: Text(
                            _urgencies[i],
                            textAlign: TextAlign.center,
                            style: ZadTextStyles.labelMd.copyWith(
                              color: selected
                                  ? ZadColors.onPrimaryContainer
                                  : ZadColors.onSurfaceVariant,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZadColors.primary,
                      foregroundColor: ZadColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Create Donation'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      await DonationService.addDonation(
        title: _titleCtrl.text.trim(),
        weightKg: double.parse(_kgCtrl.text.trim()),
        category: _urgencies[_urgencyIndex],
        expiryLabel: _urgencies[_urgencyIndex],
        collectionAddress: 'عمّان، الأردن',
        isUrgent: _urgencyIndex == 0,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إنشاء التبرع "${_titleCtrl.text.trim()}" بنجاح!',
            style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter'),
          ),
          backgroundColor: ZadColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ: ${e.toString()}',
            style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter'),
          ),
          backgroundColor: ZadColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
