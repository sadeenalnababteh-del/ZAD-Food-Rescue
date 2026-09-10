import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/firebase_service.dart';
import 'provider_dashboard_screen.dart';
import 'receiver_dashboard_screen.dart';
import 'find_donations_map_screen.dart';
import 'profile_leaderboard_screen.dart';
import 'welcome_screen.dart';
import 'my_donations_tracker_screen.dart';
import 'my_delivery_tasks_screen.dart';
import 'donation_details_screen.dart';
import 'global_sustainability_impact_screen.dart';
import 'safety_incident_log_screen.dart';

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}

const _navItems = [
  _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'لوحتي'),
  _NavItem(Icons.list_alt_outlined, Icons.list_alt, 'النشاط'),
  _NavItem(Icons.map_outlined, Icons.map, 'الخريطة'),
  _NavItem(Icons.person_outline, Icons.person, 'ملفي'),
];

class AppShell extends StatefulWidget {
  final int initialIndex;
  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return ProviderDashboardBody(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 1:
        return ReceiverDashboardBody(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 2:
        return FindDonationsMapBody(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 3:
        return ProfileLeaderboardBody(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      default:
        return ProviderDashboardBody(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ZadColors.background,
      drawer: _AppDrawer(
        onClose: () => Navigator.of(context).pop(),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: _ZadBottomNav(
        selectedIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _ZadBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _ZadBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ZadColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final isSelected = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: isSelected
                        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
                        : const EdgeInsets.symmetric(vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: ZadColors.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 22,
                          color: isSelected
                              ? ZadColors.onPrimaryContainer
                              : ZadColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: ZadTextStyles.labelSm.copyWith(
                            fontFamily: 'Inter',
                            color: isSelected
                                ? ZadColors.onPrimaryContainer
                                : ZadColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final VoidCallback onClose;
  const _AppDrawer({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'مستخدم ZAD';

    final drawerItems = [
      (Icons.track_changes_outlined, 'تبرعاتي', () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: ZadColors.background,
            body: MyDonationsTrackerBody(onOpenDrawer: () {}),
          ),
        ));
      }),
      (Icons.delivery_dining_outlined, 'مهام التوصيل', () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: ZadColors.background,
            body: MyDeliveryTasksBody(onOpenDrawer: () {}),
          ),
        ));
      }),
      (Icons.info_outline, 'تفاصيل تبرع', () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DonationDetailsScreen(donation: DonationDetailsScreen.demo),
        ));
      }),
      (Icons.analytics_outlined, 'تحليلات الأثر', () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: ZadColors.background,
            body: GlobalSustainabilityImpactScreen(onOpenDrawer: () {}),
          ),
        ));
      }),
      (Icons.security_outlined, 'سجل الحوادث', () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: ZadColors.background,
            body: SafetyIncidentLogScreen(onOpenDrawer: () {}),
          ),
        ));
      }),
      (Icons.settings_outlined, 'الإعدادات', () {
        Navigator.of(context).pop();
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => const _SettingsSheet(),
        );
      }),
    ];

    return Drawer(
      backgroundColor: ZadColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: ZadColors.primaryContainer,
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'Z',
                      style: ZadTextStyles.headlineMd.copyWith(
                        color: ZadColors.onPrimaryContainer,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: ZadTextStyles.headlineMd.copyWith(
                            color: ZadColors.primary,
                            fontFamily: 'Inter',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? '',
                          style: ZadTextStyles.bodyMd.copyWith(
                            color: ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: ZadColors.outlineVariant),
            const SizedBox(height: 8),
            ...drawerItems.map(
              (item) => ListTile(
                leading: Icon(item.$1, color: ZadColors.onSurfaceVariant),
                title: Text(
                  item.$2,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onTap: item.$3,
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: ZadColors.error),
              title: Text(
                'تسجيل الخروج',
                style: ZadTextStyles.bodyMd.copyWith(
                  color: ZadColors.error,
                  fontFamily: 'Inter',
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onTap: () async {
                Navigator.of(context).pop();
                await AuthService.signOut();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet();

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  bool _notifications = true;
  bool _urgentAlerts = true;
  bool _locationSharing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: ZadColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإعدادات',
                  style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: ZadColors.outlineVariant),
          const SizedBox(height: 8),
          _SettingsTile(
            title: 'الإشعارات',
            subtitle: 'تلقي تحديثات التبرعات والتوصيل',
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          _SettingsTile(
            title: 'تنبيهات عاجلة',
            subtitle: 'إشعارات فورية للتبرعات المنتهية قريباً',
            value: _urgentAlerts,
            onChanged: (v) => setState(() => _urgentAlerts = v),
          ),
          _SettingsTile(
            title: 'مشاركة الموقع',
            subtitle: 'السماح بتحديد الموقع للتوصيل الأمثل',
            value: _locationSharing,
            onChanged: (v) => setState(() => _locationSharing = v),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم حفظ الإعدادات بنجاح',
                      style: ZadTextStyles.bodyMd
                          .copyWith(color: Colors.white, fontFamily: 'Inter'),
                    ),
                    backgroundColor: ZadColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ZadColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
              ),
              child: const Text('حفظ الإعدادات'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter')),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ZadColors.primary,
          ),
        ],
      ),
    );
  }
}
