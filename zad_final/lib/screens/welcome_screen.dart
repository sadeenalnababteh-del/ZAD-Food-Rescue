import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ZadColors.background,
      drawer: _WelcomeDrawer(),
      body: CustomScrollView(
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
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
                child: GestureDetector(
                  onTap: _onGetStarted,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: ZadColors.surfaceContainerHigh,
                    child: ClipOval(
                      child: Image.network(
                        'https://i.pravatar.cc/80?img=12',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: ZadColors.onSurfaceVariant,
                        ),
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
          SliverToBoxAdapter(child: _HeroSection(onGetStarted: _onGetStarted)),
          SliverToBoxAdapter(child: _ImpactSection()),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
  void _onGetStarted() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}
class _WelcomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: ZadColors.surfaceContainerHigh,
                    child: const Icon(Icons.person,
                        color: ZadColors.onSurfaceVariant),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to ZAD',
                        style: ZadTextStyles.headlineMd.copyWith(
                          color: ZadColors.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        'Please login to continue',
                        style: ZadTextStyles.bodyMd.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: ZadColors.outlineVariant),
            ListTile(
              leading: const Icon(Icons.login, color: ZadColors.primary),
              title: Text(
                'Login / Register',
                style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline,
                  color: ZadColors.onSurfaceVariant),
              title: Text(
                'About ZAD',
                style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
class _HeroSection extends StatelessWidget {
  final VoidCallback onGetStarted;
  const _HeroSection({required this.onGetStarted});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 580,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, __, ___) =>
                Container(color: ZadColors.onBackground),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE6000000)],
                stops: [0.2, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: ZadColors.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Mission Driven',
                    style: ZadTextStyles.labelLg.copyWith(
                      color: ZadColors.onPrimaryContainer,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Reduce Waste,\nFeed the Community',
                  style: ZadTextStyles.headlineXl.copyWith(
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Join ZAD in bridging the gap between food surplus and community need. Together, we can ensure no nutritious meal goes to waste.',
                  style: ZadTextStyles.bodyLg.copyWith(
                    color: ZadColors.surfaceVariant,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onGetStarted,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Get Started'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZadColors.primary,
                      foregroundColor: ZadColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle:
                          ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
                    ),
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
class _ImpactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ZadColors.surfaceContainerLow,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'REAL-TIME IMPACT',
            style: ZadTextStyles.labelMd.copyWith(
              color: ZadColors.primary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Communities are growing',
            style: ZadTextStyles.headlineLg.copyWith(fontFamily: 'Inter'),
          ),
          const SizedBox(height: 16),
          _BentoCard(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ZadColors.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.eco,
                      color: ZadColors.onPrimaryContainer),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '124kg Saved',
                        style: ZadTextStyles.headlineXl.copyWith(
                          color: ZadColors.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        'Estimated carbon footprint reduction this month.',
                        style: ZadTextStyles.bodyMd.copyWith(
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.volunteer_activism,
                          color: ZadColors.secondary),
                      const SizedBox(height: 24),
                      Text('500+',
                          style: ZadTextStyles.headlineMd
                              .copyWith(fontFamily: 'Inter')),
                      Text(
                        'Active Donors',
                        style: ZadTextStyles.labelSm.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BentoCard(
                  leftBorderColor: ZadColors.secondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.schedule, color: ZadColors.primary),
                      const SizedBox(height: 24),
                      Text('15min',
                          style: ZadTextStyles.headlineMd
                              .copyWith(fontFamily: 'Inter')),
                      Text(
                        'Avg Pickup Time',
                        style: ZadTextStyles.labelSm.copyWith(
                          color: ZadColors.onSurfaceVariant,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
class _BentoCard extends StatelessWidget {
  final Widget child;
  final Color? leftBorderColor;
  const _BentoCard({required this.child, this.leftBorderColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZadColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: leftBorderColor != null ? 20 : 16,
                top: 16,
                right: 16,
                bottom: 16,
              ),
              child: child,
            ),
            if (leftBorderColor != null)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: leftBorderColor),
              ),
          ],
        ),
      ),
    );
  }
}