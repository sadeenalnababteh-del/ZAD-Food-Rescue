import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../services/firebase_service.dart';

enum IncidentType { tempViolation, qualityFail, packagingIssue, other }

IncidentType _typeFromString(String? s) {
  switch (s) {
    case 'انتهاك درجة حرارة':
      return IncidentType.tempViolation;
    case 'فشل جودة':
      return IncidentType.qualityFail;
    case 'مشكلة تغليف':
      return IncidentType.packagingIssue;
    default:
      return IncidentType.other;
  }
}

final _metrics = [
  {'label': 'إجمالي الرفض', 'value': '42', 'color': ZadColors.secondary, 'sub': '+12% الشهر الماضي', 'icon': Icons.cancel_outlined},
  {'label': 'انتهاكات حرارة', 'value': '28', 'color': ZadColors.primary, 'sub': '66% من الحوادث', 'icon': Icons.thermostat},
  {'label': 'خسارة الأثر', 'value': '184كجم', 'color': ZadColors.tertiary, 'sub': 'هدر غذائي مقدّر', 'icon': Icons.eco_outlined},
  {'label': 'متوسط الاستجابة', 'value': '14د', 'color': ZadColors.onSurface, 'sub': 'ضمن معيار الخدمة', 'icon': Icons.timer_outlined},
];

class SafetyIncidentLogScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const SafetyIncidentLogScreen({super.key, this.onOpenDrawer});

  @override
  State<SafetyIncidentLogScreen> createState() => _SafetyIncidentLogScreenState();
}

class _SafetyIncidentLogScreenState extends State<SafetyIncidentLogScreen> {
  IncidentType? _filterType;

  void _applyFilter(IncidentType? type) {
    setState(() => _filterType = type);
  }

  void _onLogNew() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LogIncidentSheet(),
    );
  }

  void _onExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جارٍ تصدير التقرير...',
            style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter')),
        backgroundColor: ZadColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _onDeleteIncident(String docId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الحادثة', style: TextStyle(fontFamily: 'Inter')),
        content: Text(
          'هل تريد حذف حادثة "$title"؟ هذا الإجراء لا يمكن التراجع عنه.',
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
      await DonationService.deleteIncident(docId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف الحادثة بنجاح',
              style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter')),
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
            title: Text('ZAD',
                style: ZadTextStyles.headlineLg.copyWith(
                    color: ZadColors.primary,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Inter')),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, color: ZadColors.outlineVariant),
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
                Text('سجل الحوادث',
                    style: ZadTextStyles.headlineXl.copyWith(fontFamily: 'Inter')),
                const SizedBox(height: 4),
                Text('مراجعة الشحنات المرفوضة وانتهاكات الجودة في شبكة التوزيع.',
                    style: ZadTextStyles.bodyMd.copyWith(
                        color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.6,
                  children: _metrics.map((m) => _MetricCard(data: m)).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text('الحوادث الأخيرة',
                          style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
                    ),
                    GestureDetector(
                      onTap: _showFilterSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _filterType != null
                              ? ZadColors.primaryContainer.withValues(alpha: 0.3)
                              : ZadColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: _filterType != null ? ZadColors.primary : ZadColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list,
                                size: 16,
                                color: _filterType != null
                                    ? ZadColors.primary
                                    : ZadColors.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Text('تصفية',
                                style: ZadTextStyles.labelMd.copyWith(
                                    color: _filterType != null
                                        ? ZadColors.primary
                                        : ZadColors.onSurfaceVariant,
                                    fontFamily: 'Inter')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: DonationService.getIncidents(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ZadColors.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'خطأ في التحميل: ${snapshot.error}',
                        style: ZadTextStyles.bodyMd.copyWith(
                            color: ZadColors.onErrorContainer, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                );
              }
              var docs = snapshot.data?.docs ?? [];
              if (_filterType != null) {
                final typeStr = _filterType == IncidentType.tempViolation
                    ? 'انتهاك درجة حرارة'
                    : _filterType == IncidentType.qualityFail
                        ? 'فشل جودة'
                        : _filterType == IncidentType.packagingIssue
                            ? 'مشكلة تغليف'
                            : 'أخرى';
                docs = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  return data['type'] == typeStr;
                }).toList();
              }
              if (docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: ZadColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ZadColors.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 40, color: ZadColors.primary),
                          const SizedBox(height: 8),
                          Text('لا توجد حوادث مسجلة',
                              style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
                          const SizedBox(height: 4),
                          Text('اضغط "تسجيل حادثة" لإضافة سجل جديد',
                              style: ZadTextStyles.bodyMd.copyWith(
                                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final doc = docs[i];
                    final data = doc.data() as Map<String, dynamic>;
                    return _IncidentCard(
                      docId: doc.id,
                      data: data,
                      onDelete: () => _onDeleteIncident(
                          doc.id, data['title'] as String? ?? ''),
                    );
                  },
                ),
              );
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _onLogNew,
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text('تسجيل حادثة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZadColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: ZadTextStyles.labelMd.copyWith(fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onExport,
                      icon: const Icon(Icons.download_outlined, size: 18),
                      label: const Text('تصدير التقرير'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ZadColors.primary,
                        side: const BorderSide(color: ZadColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: ZadTextStyles.labelMd.copyWith(fontFamily: 'Inter'),
                      ),
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ZadColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تصفية حسب النوع',
                style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
            const SizedBox(height: 16),
            _FilterChip(
                label: 'الكل',
                selected: _filterType == null,
                onTap: () {
                  _applyFilter(null);
                  Navigator.pop(context);
                }),
            _FilterChip(
                label: 'انتهاك حراري',
                selected: _filterType == IncidentType.tempViolation,
                onTap: () {
                  _applyFilter(IncidentType.tempViolation);
                  Navigator.pop(context);
                }),
            _FilterChip(
                label: 'فشل جودة',
                selected: _filterType == IncidentType.qualityFail,
                onTap: () {
                  _applyFilter(IncidentType.qualityFail);
                  Navigator.pop(context);
                }),
            _FilterChip(
                label: 'مشكلة تغليف',
                selected: _filterType == IncidentType.packagingIssue,
                onTap: () {
                  _applyFilter(IncidentType.packagingIssue);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? ZadColors.primaryContainer.withValues(alpha: 0.3)
              : ZadColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? ZadColors.primary : ZadColors.outlineVariant),
        ),
        child: Text(label,
            style: ZadTextStyles.bodyMd.copyWith(
                color: selected ? ZadColors.primary : ZadColors.onSurface,
                fontFamily: 'Inter')),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(data['icon'] as IconData, color: data['color'] as Color, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text((data['label'] as String),
                    style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Text(data['value'] as String,
              style: ZadTextStyles.headlineLg
                  .copyWith(color: data['color'] as Color, fontFamily: 'Inter')),
          Text(data['sub'] as String,
              style: ZadTextStyles.labelSm
                  .copyWith(color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
        ],
      ),
    );
  }
}

class _IncidentCard extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;
  final VoidCallback onDelete;
  const _IncidentCard({required this.docId, required this.data, required this.onDelete});

  @override
  State<_IncidentCard> createState() => _IncidentCardState();
}

class _IncidentCardState extends State<_IncidentCard> {
  bool _expanded = false;

  IncidentType get _type => _typeFromString(widget.data['type'] as String?);

  Color get _borderColor {
    switch (_type) {
      case IncidentType.tempViolation:
        return ZadColors.error;
      case IncidentType.qualityFail:
        return ZadColors.tertiaryContainer;
      case IncidentType.packagingIssue:
        return ZadColors.outlineVariant;
      case IncidentType.other:
        return ZadColors.outlineVariant;
    }
  }

  String get _typeLabel {
    switch (_type) {
      case IncidentType.tempViolation:
        return 'مرفوض: انتهاك حراري';
      case IncidentType.qualityFail:
        return 'مرفوض: فشل جودة';
      case IncidentType.packagingIssue:
        return 'مرفوض: مشكلة تغليف';
      case IncidentType.other:
        return 'مرفوض: أخرى';
    }
  }

  Color get _labelBg {
    switch (_type) {
      case IncidentType.tempViolation:
        return ZadColors.errorContainer;
      case IncidentType.qualityFail:
        return ZadColors.tertiaryContainer;
      case IncidentType.packagingIssue:
        return ZadColors.surfaceContainerHighest;
      case IncidentType.other:
        return ZadColors.surfaceContainerHighest;
    }
  }

  Color get _labelText {
    switch (_type) {
      case IncidentType.tempViolation:
        return ZadColors.onErrorContainer;
      case IncidentType.qualityFail:
        return ZadColors.onTertiaryContainer;
      case IncidentType.packagingIssue:
        return ZadColors.onSurfaceVariant;
      case IncidentType.other:
        return ZadColors.onSurfaceVariant;
    }
  }

  String _formatTimestamp(dynamic ts) {
    if (ts == null) return '';
    if (ts is Timestamp) {
      final dt = ts.toDate();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} • ${dt.day}/${dt.month}/${dt.year}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final batchNumber = widget.data['batchNumber'] as String? ?? '';
    final title = widget.data['title'] as String? ?? '';
    final detail = widget.data['detail'] as String? ?? '';
    final origin = widget.data['origin'] as String? ?? '';
    final note = widget.data['note'] as String? ?? '';
    final timestamp = widget.data['timestamp'];

    return Dismissible(
      key: Key(widget.docId),
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
        widget.onDelete();
        return false;
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
        child: GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: ZadColors.surface,
              border: Border(
                left: BorderSide(color: _borderColor, width: 4),
                top: const BorderSide(color: ZadColors.outlineVariant),
                right: const BorderSide(color: ZadColors.outlineVariant),
                bottom: const BorderSide(color: ZadColors.outlineVariant),
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _labelBg,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(_typeLabel,
                                      style: ZadTextStyles.labelSm.copyWith(
                                          color: _labelText, fontFamily: 'Inter')),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              batchNumber.isNotEmpty ? 'دفعة #$batchNumber: $title' : title,
                              style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(_formatTimestamp(timestamp),
                              style: ZadTextStyles.labelSm.copyWith(
                                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: widget.onDelete,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(Icons.delete_outline,
                                      color: ZadColors.error, size: 18),
                                ),
                              ),
                              Icon(
                                _expanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: ZadColors.onSurfaceVariant,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (detail.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: ZadColors.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(detail,
                              style: ZadTextStyles.bodyMd.copyWith(
                                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                        ),
                      ],
                    ),
                  ],
                  if (origin.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: ZadColors.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(origin,
                              style: ZadTextStyles.bodyMd.copyWith(
                                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter'),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: _expanded && note.isNotEmpty
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ZadColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('"$note"',
                              style: ZadTextStyles.bodyMd.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: ZadColors.onSurfaceVariant,
                                  fontFamily: 'Inter')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogIncidentSheet extends StatefulWidget {
  const _LogIncidentSheet();

  @override
  State<_LogIncidentSheet> createState() => _LogIncidentSheetState();
}

class _LogIncidentSheetState extends State<_LogIncidentSheet> {
  final _batchCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  IncidentType _type = IncidentType.tempViolation;
  bool _submitting = false;
  final _formKey = GlobalKey<FormState>();

  static const _typeLabels = {
    IncidentType.tempViolation: 'انتهاك حراري',
    IncidentType.qualityFail: 'فشل جودة',
    IncidentType.packagingIssue: 'مشكلة تغليف',
    IncidentType.other: 'أخرى',
  };

  @override
  void dispose() {
    _batchCtrl.dispose();
    _titleCtrl.dispose();
    _originCtrl.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                Text('تسجيل حادثة جديدة',
                    style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
                const SizedBox(height: 20),
                Text('نوع الحادثة',
                    style: ZadTextStyles.labelMd.copyWith(
                        color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: IncidentType.values
                      .map((t) => GestureDetector(
                            onTap: () => setState(() => _type = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _type == t
                                    ? ZadColors.primaryContainer.withValues(alpha: 0.4)
                                    : ZadColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                    color: _type == t
                                        ? ZadColors.primary
                                        : ZadColors.outlineVariant),
                              ),
                              child: Text(_typeLabels[t]!,
                                  style: ZadTextStyles.labelMd.copyWith(
                                      color: _type == t
                                          ? ZadColors.primary
                                          : ZadColors.onSurfaceVariant,
                                      fontFamily: 'Inter')),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _batchCtrl,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(
                      labelText: 'رقم الدفعة (مثال: SC-903)',
                      border: OutlineInputBorder()),
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtrl,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(
                      labelText: 'اسم المنتج / الشحنة',
                      border: OutlineInputBorder()),
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _originCtrl,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(
                      labelText: 'المصدر / الجهة المرسِلة',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteCtrl,
                  maxLines: 3,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(
                      labelText: 'ملاحظات الحادثة',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZadColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text('تسجيل الحادثة',
                            style: ZadTextStyles.headlineMd
                                .copyWith(color: Colors.white, fontFamily: 'Inter')),
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
    setState(() => _submitting = true);
    final typeStr = _type == IncidentType.tempViolation
        ? 'انتهاك درجة حرارة'
        : _type == IncidentType.qualityFail
            ? 'فشل جودة'
            : _type == IncidentType.packagingIssue
                ? 'مشكلة تغليف'
                : 'أخرى';
    try {
      await DonationService.logIncident(
        batchNumber: _batchCtrl.text.trim(),
        title: _titleCtrl.text.trim(),
        type: typeStr,
        detail: 'تم التسجيل يدوياً',
        origin: _originCtrl.text.trim().isEmpty ? 'غير محدد' : _originCtrl.text.trim(),
        note: _noteCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تسجيل الحادثة بنجاح',
              style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter')),
          backgroundColor: ZadColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: ${e.toString()}',
              style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter')),
          backgroundColor: ZadColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
