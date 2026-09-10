import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
class AchievementBadge {
  final String label;
  final IconData icon;
  final Color color;
  final bool earned;
  const AchievementBadge({
    required this.label,
    required this.icon,
    required this.color,
    required this.earned,
  });
}
class LeaderboardEntry {
  final int rank;
  final String name;
  final int points;
  final String avatarUrl;
  final bool isMe;
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.points,
    required this.avatarUrl,
    this.isMe = false,
  });
}
final _mockBadges = const [
  AchievementBadge(
      label: 'أول إنقاذ',
      icon: Icons.star_outline,
      color: ZadColors.primary,
      earned: true),
  AchievementBadge(
      label: '7 أيام متواصلة',
      icon: Icons.local_fire_department,
      color: ZadColors.tertiary,
      earned: true),
  AchievementBadge(
      label: 'فئة البطل',
      icon: Icons.shield_outlined,
      color: ZadColors.onSurfaceVariant,
      earned: false),
  AchievementBadge(
      label: 'نادي الـ 1000',
      icon: Icons.workspace_premium_outlined,
      color: ZadColors.onSurfaceVariant,
      earned: false),
];
final _mockLeaderboard = const [
  LeaderboardEntry(
      rank: 1,
      name: 'سارة ج.',
      points: 3890,
      avatarUrl: 'https://i.pravatar.cc/80?img=1'),
  LeaderboardEntry(
      rank: 2,
      name: 'مارك ت.',
      points: 3210,
      avatarUrl: 'https://i.pravatar.cc/80?img=2'),
  LeaderboardEntry(
      rank: 3,
      name: 'نور أ.',
      points: 2870,
      avatarUrl: 'https://i.pravatar.cc/80?img=3'),
  LeaderboardEntry(
      rank: 4,
      name: 'عمر خ.',
      points: 2640,
      avatarUrl: 'https://i.pravatar.cc/80?img=4'),
  LeaderboardEntry(
      rank: 5,
      name: 'ليلى س.',
      points: 2540,
      avatarUrl: 'https://i.pravatar.cc/80?img=6'),
  LeaderboardEntry(
      rank: 6,
      name: 'رياض م.',
      points: 2500,
      avatarUrl: 'https://i.pravatar.cc/80?img=7'),
  LeaderboardEntry(
      rank: 7,
      name: 'دانا ف.',
      points: 2480,
      avatarUrl: 'https://i.pravatar.cc/80?img=9'),
  LeaderboardEntry(
      rank: 8,
      name: 'أنت',
      points: 2450,
      avatarUrl: 'https://i.pravatar.cc/80?img=8',
      isMe: true),
];
class ProfileLeaderboardBody extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const ProfileLeaderboardBody({super.key, required this.onOpenDrawer});
  @override
  State<ProfileLeaderboardBody> createState() => _ProfileLeaderboardBodyState();
}
class _ProfileLeaderboardBodyState extends State<ProfileLeaderboardBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }
  void _onViewAllRankings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FullLeaderboardSheet(entries: _mockLeaderboard),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZadColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
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
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Builder(
                  builder: (ctx) {
                    final u = FirebaseAuth.instance.currentUser;
                    final initial = (u?.displayName?.isNotEmpty == true)
                        ? u!.displayName![0].toUpperCase()
                        : 'Z';
                    return CircleAvatar(
                      radius: 18,
                      backgroundColor: ZadColors.primaryContainer,
                      child: Text(
                        initial,
                        style: ZadTextStyles.labelLg.copyWith(
                          color: ZadColors.onPrimaryContainer,
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabCtrl,
              labelColor: ZadColors.primary,
              unselectedLabelColor: ZadColors.onSurfaceVariant,
              indicatorColor: ZadColors.primary,
              indicatorWeight: 3,
              labelStyle: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
              tabs: const [
                Tab(text: 'ملفي الشخصي'),
                Tab(text: 'المتصدرون'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _ProfileTab(onViewAllRankings: _onViewAllRankings),
            _LeaderboardTab(onViewAllRankings: _onViewAllRankings),
          ],
        ),
      ),
    );
  }
}
class _ProfileTab extends StatelessWidget {
  final VoidCallback onViewAllRankings;
  const _ProfileTab({required this.onViewAllRankings});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'مستخدم ZAD';
    final email = user?.email ?? '';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'Z';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          color: ZadColors.surface,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: ZadColors.primaryContainer,
                    child: Text(
                      initial,
                      style: ZadTextStyles.headlineXl.copyWith(
                        color: ZadColors.onPrimaryContainer,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ZadColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: ZadColors.surface, width: 2),
                    ),
                    child: Text(
                      'م 8',
                      style: ZadTextStyles.labelSm.copyWith(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                displayName,
                style: ZadTextStyles.headlineLg.copyWith(fontFamily: 'Inter'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: ZadTextStyles.bodyMd.copyWith(
                  color: ZadColors.onSurfaceVariant,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RoleBadge(
                      label: 'أفضل منقذ',
                      icon: Icons.verified_outlined,
                      color: ZadColors.primary),
                  const SizedBox(width: 8),
                  _RoleBadge(
                      label: 'حارس البيئة',
                      icon: Icons.eco,
                      color: ZadColors.tertiary),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: ZadColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ZadColors.outlineVariant),
                ),
                child: Column(
                  children: [
                    Text(
                      '2,450',
                      style: ZadTextStyles.headlineXl.copyWith(
                        color: ZadColors.primary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      'إجمالي النقاط',
                      style: ZadTextStyles.labelMd.copyWith(
                        color: ZadColors.onSurfaceVariant,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _FirestoreStatusCard(),
        ),
        const SizedBox(height: 8),
        Container(
          color: ZadColors.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أثرك البيئي',
                style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ZadColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.co2,
                        color: ZadColors.onPrimaryContainer, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '124 كجم ثاني أكسيد كربون محمي',
                            style: ZadTextStyles.headlineMd.copyWith(
                              color: ZadColors.onPrimaryContainer,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+12% مقارنة بالشهر الماضي',
                            style: ZadTextStyles.labelSm.copyWith(
                              color:
                                  ZadColors.onPrimaryContainer.withValues(alpha: 0.8),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ImpactMetricCard(
                      icon: Icons.restaurant,
                      iconColor: ZadColors.secondary,
                      value: '842',
                      label: 'وجبات أعيد توزيعها',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ImpactMetricCard(
                      icon: Icons.water_drop,
                      iconColor: ZadColors.tertiary,
                      value: '12 ألف لتر',
                      label: 'بصمة مياه محفوظة',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: ZadColors.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'شارات الإنجاز',
                    style:
                        ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                  ),
                  TextButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => _AllBadgesSheet(badges: _mockBadges),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: ZadColors.primary,
                      textStyle:
                          ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                    ),
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _mockBadges.map((b) => _BadgeCard(badge: b)).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: ZadColors.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المتصدرون الإقليميون',
                style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
              ),
              const SizedBox(height: 12),
              ..._mockLeaderboard.take(3).map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _LeaderboardRow(entry: e),
                  )),
              const Divider(color: ZadColors.outlineVariant),
              _LeaderboardRow(
                entry: _mockLeaderboard.firstWhere((e) => e.isMe),
                showDivider: false,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onViewAllRankings,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ZadColors.primary,
                    side: const BorderSide(color: ZadColors.outline),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('عرض كامل الترتيب'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
class _LeaderboardTab extends StatelessWidget {
  final VoidCallback onViewAllRankings;
  const _LeaderboardTab({required this.onViewAllRankings});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ZadColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.leaderboard,
                  color: ZadColors.onPrimaryContainer, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المتصدر الإقليمي',
                      style: ZadTextStyles.headlineMd.copyWith(
                        color: ZadColors.onPrimaryContainer,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      'عمّان، الأردن – يتجدد أسبوعياً',
                      style: ZadTextStyles.labelSm.copyWith(
                        color: ZadColors.onPrimaryContainer.withValues(alpha: 0.8),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: _PodiumCard(
                    entry: _mockLeaderboard[1], height: 100, rank: 2)),
            const SizedBox(width: 8),
            Expanded(
                child: _PodiumCard(
                    entry: _mockLeaderboard[0], height: 130, rank: 1)),
            const SizedBox(width: 8),
            Expanded(
                child: _PodiumCard(
                    entry: _mockLeaderboard[2], height: 80, rank: 3)),
          ],
        ),
        const SizedBox(height: 24),
        ..._mockLeaderboard.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _LeaderboardRow(entry: e),
            )),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onViewAllRankings,
            style: OutlinedButton.styleFrom(
              foregroundColor: ZadColors.primary,
              side: const BorderSide(color: ZadColors.outline),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('عرض كامل الترتيب'),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
class _RoleBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _RoleBadge(
      {required this.label, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: ZadTextStyles.labelSm.copyWith(
              color: color,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
class _ImpactMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  const _ImpactMetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
          ),
          Text(
            label,
            style: ZadTextStyles.labelSm.copyWith(
              color: ZadColors.onSurfaceVariant,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
class _BadgeCard extends StatelessWidget {
  final AchievementBadge badge;
  const _BadgeCard({required this.badge});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: badge.earned
            ? badge.color.withValues(alpha: 0.10)
            : ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badge.earned
              ? badge.color.withValues(alpha: 0.3)
              : ZadColors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: badge.earned
                  ? badge.color.withValues(alpha: 0.15)
                  : ZadColors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              badge.icon,
              color: badge.earned ? badge.color : ZadColors.outlineVariant,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              badge.label,
              style: ZadTextStyles.labelSm.copyWith(
                color: badge.earned
                    ? ZadColors.onSurface
                    : ZadColors.onSurfaceVariant,
                fontFamily: 'Inter',
                fontWeight: badge.earned ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool showDivider;
  const _LeaderboardRow({required this.entry, this.showDivider = false});
  Color get _rankColor {
    if (entry.rank == 1) return const Color(0xFFFFD700);
    if (entry.rank == 2) return const Color(0xFFC0C0C0);
    if (entry.rank == 3) return const Color(0xFFCD7F32);
    return ZadColors.onSurfaceVariant;
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: entry.isMe
            ? ZadColors.primaryContainer.withValues(alpha: 0.15)
            : ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isMe
              ? ZadColors.primary.withValues(alpha: 0.3)
              : ZadColors.outlineVariant,
          width: entry.isMe ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              entry.rank.toString(),
              style: ZadTextStyles.headlineMd.copyWith(
                color: _rankColor,
                fontWeight: FontWeight.w900,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
            backgroundColor: ZadColors.surfaceContainerHigh,
            child: ClipOval(
              child: Image.network(
                entry.avatarUrl,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: ZadColors.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.name,
              style: ZadTextStyles.labelLg.copyWith(
                color: entry.isMe ? ZadColors.primary : ZadColors.onSurface,
                fontFamily: 'Inter',
                fontWeight: entry.isMe ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${entry.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} نقطة',
            style: ZadTextStyles.labelMd.copyWith(
              color: ZadColors.onSurfaceVariant,
              fontFamily: 'Inter',
            ),
          ),
          if (entry.rank <= 3) ...[
            const SizedBox(width: 6),
            Icon(Icons.trending_up, size: 16, color: _rankColor),
          ],
        ],
      ),
    );
  }
}
class _PodiumCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final double height;
  final int rank;
  const _PodiumCard(
      {required this.entry, required this.height, required this.rank});
  Color get _color {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    return const Color(0xFFCD7F32);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: rank == 1 ? 28 : 22,
          backgroundColor: ZadColors.surfaceContainerHigh,
          child: ClipOval(
            child: Image.network(
              entry.avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, color: ZadColors.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry.name,
          style: ZadTextStyles.labelSm.copyWith(fontFamily: 'Inter'),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.points} ن',
          style: ZadTextStyles.labelSm.copyWith(
            color: ZadColors.onSurfaceVariant,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: _color.withValues(alpha: 0.5)),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: _color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _FullLeaderboardSheet extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  const _FullLeaderboardSheet({required this.entries});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
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
                    'كامل الترتيب',
                    style:
                        ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
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
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _LeaderboardRow(entry: entries[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _AllBadgesSheet extends StatelessWidget {
  final List<AchievementBadge> badges;
  const _AllBadgesSheet({required this.badges});
  static const _allBadges = [
    AchievementBadge(label: 'أول إنقاذ', icon: Icons.star_outline, color: ZadColors.primary, earned: true),
    AchievementBadge(label: '7 أيام متواصلة', icon: Icons.local_fire_department, color: ZadColors.tertiary, earned: true),
    AchievementBadge(label: 'فئة البطل', icon: Icons.shield_outlined, color: ZadColors.onSurfaceVariant, earned: false),
    AchievementBadge(label: 'نادي الـ 1000', icon: Icons.workspace_premium_outlined, color: ZadColors.onSurfaceVariant, earned: false),
    AchievementBadge(label: '30 يوماً متواصلة', icon: Icons.calendar_today_outlined, color: ZadColors.onSurfaceVariant, earned: false),
    AchievementBadge(label: 'المتبرع الذهبي', icon: Icons.emoji_events_outlined, color: ZadColors.onSurfaceVariant, earned: false),
  ];
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
                  Text('جميع الشارات',
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
              child: GridView.count(
                controller: controller,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                padding: const EdgeInsets.all(16),
                childAspectRatio: 1.3,
                children: _allBadges.map((b) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: b.earned
                        ? b.color.withValues(alpha: 0.1)
                        : ZadColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: b.earned ? b.color.withValues(alpha: 0.3) : ZadColors.outlineVariant,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(b.icon,
                          color: b.earned ? b.color : ZadColors.onSurfaceVariant,
                          size: 28),
                      const SizedBox(height: 6),
                      Text(b.label,
                          textAlign: TextAlign.center,
                          style: ZadTextStyles.labelMd.copyWith(
                            color: b.earned ? b.color : ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter',
                          )),
                      if (!b.earned)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('مقفل',
                              style: ZadTextStyles.labelSm.copyWith(
                                  color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                        ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirestoreStatusCard extends StatefulWidget {
  const _FirestoreStatusCard();
  @override
  State<_FirestoreStatusCard> createState() => _FirestoreStatusCardState();
}

class _FirestoreStatusCardState extends State<_FirestoreStatusCard> {
  _FsStatus _status = _FsStatus.loading;
  String _detail = '';

  @override
  void initState() {
    super.initState();
    _runCheck();
  }

  Future<void> _runCheck() async {
    setState(() { _status = _FsStatus.loading; _detail = ''; });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final ref = FirebaseFirestore.instance
          .collection('_connectivity_test')
          .doc(uid);
      await ref.set({'ping': DateTime.now().toIso8601String()});
      final snap = await ref.get();
      if (snap.exists) {
        setState(() { _status = _FsStatus.ok; _detail = 'قراءة وكتابة ناجحتان'; });
      } else {
        setState(() { _status = _FsStatus.error; _detail = 'الوثيقة غير موجودة بعد الكتابة'; });
      }
    } catch (e) {
      final msg = e.toString();
      setState(() { _status = _FsStatus.error; _detail = msg.length > 90 ? msg.substring(0, 90) : msg; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOk = _status == _FsStatus.ok;
    final isLoading = _status == _FsStatus.loading;
    final bg = isOk ? const Color(0xFFE6F4EA) : isLoading ? ZadColors.surfaceContainerLow : const Color(0xFFFCE8E6);
    final iconColor = isOk ? const Color(0xFF1E8E3E) : isLoading ? ZadColors.onSurfaceVariant : const Color(0xFFD93025);
    final label = isOk ? 'Firestore متصل ✅' : isLoading ? 'جارٍ فحص Firestore…' : 'Firestore غير متصل ❌';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          isLoading
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ZadColors.onSurfaceVariant))
              : Icon(isOk ? Icons.cloud_done_outlined : Icons.cloud_off_outlined, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: ZadTextStyles.labelLg.copyWith(color: iconColor, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
                if (_detail.isNotEmpty)
                  Text(_detail, style: ZadTextStyles.labelSm.copyWith(color: iconColor.withValues(alpha: 0.8), fontFamily: 'Inter')),
              ],
            ),
          ),
          if (!isLoading)
            GestureDetector(
              onTap: _runCheck,
              child: Icon(Icons.refresh, color: iconColor, size: 18),
            ),
        ],
      ),
    );
  }
}

enum _FsStatus { loading, ok, error }