import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/firebase_service.dart';
class LoginScreen extends StatefulWidget {
  final int initialRole;
  const LoginScreen({super.key, this.initialRole = 0});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  late int _selectedRole;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  static const _roles = ['Provider', 'Charity', 'Volunteer'];
  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZadColors.surface,
      body: Stack(
        children: [
          _BackgroundDecoration(),
          SafeArea(
            child: Column(
              children: [
                _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        Text(
                          'Welcome back',
                          style: ZadTextStyles.headlineXl.copyWith(fontFamily: 'Inter'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fight food waste and bridge the gap between\nabundance and need.',
                          style: ZadTextStyles.bodyMd.copyWith(
                            color: ZadColors.onSurfaceVariant,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        if (_errorMessage != null) ...[
                          _ErrorBanner(message: _errorMessage!),
                          const SizedBox(height: 16),
                        ],
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: ZadColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ZadColors.outlineVariant),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'I am a...',
                                  style: ZadTextStyles.labelLg.copyWith(
                                    color: ZadColors.onSurfaceVariant,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _RoleSelector(
                                  roles: _roles,
                                  selectedIndex: _selectedRole,
                                  onChanged: (i) => setState(() {
                                    _selectedRole = i;
                                    _errorMessage = null;
                                  }),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Email Address',
                                  style: ZadTextStyles.labelMd.copyWith(
                                    color: ZadColors.onSurfaceVariant,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                                  onChanged: (_) => setState(() => _errorMessage = null),
                                  decoration: const InputDecoration(
                                    hintText: 'name@organization.com',
                                  ),
                                  validator: (v) =>
                                      (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Password',
                                      style: ZadTextStyles.labelMd.copyWith(
                                        color: ZadColors.onSurfaceVariant,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _isLoading ? null : _onForgotPassword,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: ZadTextStyles.labelSm.copyWith(
                                          color: ZadColors.primary,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _passwordCtrl,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _onLogin(),
                                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                                  onChanged: (_) => setState(() => _errorMessage = null),
                                  decoration: InputDecoration(
                                    hintText: '••••••••',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: ZadColors.onSurfaceVariant,
                                        size: 20,
                                      ),
                                      onPressed: () =>
                                          setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  validator: (v) =>
                                      (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _onLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ZadColors.primary,
                                      foregroundColor: ZadColors.onPrimary,
                                      disabledBackgroundColor:
                                          ZadColors.primary.withValues(alpha: 0.6),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      textStyle:
                                          ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text('Login'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: GestureDetector(
                                    onTap: _isLoading ? null : _onRegister,
                                    child: RichText(
                                      text: TextSpan(
                                        style: ZadTextStyles.bodyMd.copyWith(
                                          color: ZadColors.onSurfaceVariant,
                                          fontFamily: 'Inter',
                                        ),
                                        children: [
                                          const TextSpan(text: 'New to ZAD? '),
                                          TextSpan(
                                            text: 'Register New Account',
                                            style: ZadTextStyles.bodyMd.copyWith(
                                              color: ZadColors.primary,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: _ImpactTeaser(
                                value: '124kg',
                                label: 'Food Saved Today',
                                valueColor: ZadColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _ImpactTeaser(
                                value: '42',
                                label: 'Active Pickups',
                                valueColor: ZadColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '© 2024 ZAD Efficiency Systems. All rights reserved.',
                    style: ZadTextStyles.labelSm
                        .copyWith(color: ZadColors.outline, fontFamily: 'Inter'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await AuthService.signIn(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'لا يوجد حساب بهذا البريد الإلكتروني.';
          break;
        case 'wrong-password':
          msg = 'كلمة المرور غير صحيحة، حاول مجدداً.';
          break;
        case 'invalid-email':
          msg = 'صيغة البريد الإلكتروني غير صحيحة.';
          break;
        case 'too-many-requests':
          msg = 'محاولات كثيرة، حاول لاحقاً.';
          break;
        case 'invalid-credential':
          msg = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
          break;
        case 'network-request-failed':
          msg = 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة.';
          break;
        case 'operation-not-allowed':
          msg = 'تسجيل الدخول بالبريد الإلكتروني غير مفعّل في Firebase Console.';
          break;
        default:
          msg = '[${e.code}] ${e.message ?? "حدث خطأ"}';
      }
      setState(() {
        _isLoading = false;
        _errorMessage = msg;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'خطأ: ${e.toString()}';
      });
    }
  }
  void _onForgotPassword() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'أدخل بريدك الإلكتروني أولاً لإعادة تعيين كلمة المرور.');
      return;
    }
    AuthService.sendPasswordResetEmail(email).then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك.',
            style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter'),
          ),
          backgroundColor: ZadColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }).catchError((_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'تعذر إرسال رابط إعادة التعيين، تحقق من البريد الإلكتروني.');
    });
  }
  void _onRegister() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _RegisterSheet(),
    );
  }
}
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ZadColors.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ZadColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: ZadColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: ZadTextStyles.bodyMd.copyWith(
                color: ZadColors.onErrorContainer,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _RoleSelector extends StatelessWidget {
  final List<String> roles;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const _RoleSelector({
    required this.roles,
    required this.selectedIndex,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(roles.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? ZadColors.primaryContainer : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: selected
                      ? [const BoxShadow(color: Color(0x1A000000), blurRadius: 4)]
                      : null,
                ),
                child: Text(
                  roles[i],
                  textAlign: TextAlign.center,
                  style: ZadTextStyles.labelMd.copyWith(
                    color: selected ? ZadColors.onPrimaryContainer : ZadColors.onSurfaceVariant,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
class _ImpactTeaser extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  const _ImpactTeaser({required this.value, required this.label, required this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZadColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZadColors.outlineVariant),
      ),
      child: Column(
        children: [
          Text(value,
              style: ZadTextStyles.headlineLg.copyWith(color: valueColor, fontFamily: 'Inter')),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: ZadTextStyles.labelSm.copyWith(
              color: ZadColors.onSurfaceVariant,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: ZadColors.surface,
        border: Border(bottom: BorderSide(color: ZadColors.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Icon(Icons.arrow_back, color: ZadColors.primary),
              ),
              const SizedBox(width: 16),
              Text(
                'ZAD',
                style: ZadTextStyles.headlineLg.copyWith(
                  color: ZadColors.primary,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: ZadColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: ZadColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
class _BackgroundDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ZadColors.primaryFixed.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ZadColors.secondaryFixedDim.withValues(alpha: 0.15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _RegisterSheet extends StatefulWidget {
  const _RegisterSheet();
  @override
  State<_RegisterSheet> createState() => _RegisterSheetState();
}
class _RegisterSheetState extends State<_RegisterSheet> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedRole = 0;
  bool _obscure = true;
  bool _isSaving = false;
  static const _roles = ['Provider', 'Charity', 'Volunteer'];
  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      await AuthService.register(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        name: _nameCtrl.text.trim(),
        role: _roles[_selectedRole],
      );
      if (!mounted) return;
      final nav = Navigator.of(context);
      nav.pop();
      nav.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'هذا البريد الإلكتروني مسجل مسبقاً.';
          break;
        case 'weak-password':
          msg = 'كلمة المرور ضعيفة، استخدم 6 أحرف على الأقل.';
          break;
        case 'invalid-email':
          msg = 'صيغة البريد الإلكتروني غير صحيحة.';
          break;
        case 'operation-not-allowed':
          msg = 'التسجيل بالبريد الإلكتروني غير مفعّل — فعّله من Firebase Console.';
          break;
        case 'network-request-failed':
          msg = 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة.';
          break;
        default:
          msg = '[${e.code}] ${e.message ?? "تعذر إنشاء الحساب"}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter')),
          backgroundColor: ZadColors.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      setState(() => _isSaving = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: ${e.toString()}', style: ZadTextStyles.bodyMd.copyWith(color: Colors.white, fontFamily: 'Inter')),
          backgroundColor: ZadColors.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      setState(() => _isSaving = false);
    }
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
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: ZadColors.outlineVariant,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Text('إنشاء حساب جديد',
                    style: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter')),
                const SizedBox(height: 4),
                Text('انضم إلى مجتمع ZAD لإنقاذ الطعام في الأردن',
                    style: ZadTextStyles.bodyMd
                        .copyWith(color: ZadColors.onSurfaceVariant, fontFamily: 'Inter')),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ZadColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: List.generate(_roles.length, (i) {
                      final sel = i == _selectedRole;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedRole = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? ZadColors.primaryContainer : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(_roles[i],
                                textAlign: TextAlign.center,
                                style: ZadTextStyles.labelMd.copyWith(
                                  color: sel
                                      ? ZadColors.onPrimaryContainer
                                      : ZadColors.onSurfaceVariant,
                                  fontFamily: 'Inter',
                                )),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameCtrl,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                  validator: (v) => (v == null || v.isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                  validator: (v) => (v == null || !v.contains('@')) ? 'بريد غير صالح' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  style: ZadTextStyles.bodyMd.copyWith(fontFamily: 'Inter'),
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: ZadColors.onSurfaceVariant, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? '6 أحرف على الأقل' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZadColors.primary,
                      foregroundColor: ZadColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: ZadTextStyles.headlineMd.copyWith(fontFamily: 'Inter'),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('إنشاء الحساب'),
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