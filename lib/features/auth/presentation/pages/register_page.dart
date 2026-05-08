import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _passwordVisible = false;
  bool _agreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Securely manage your personal and business expenses with ease.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 32),
                _fieldLabel('Full Name'),
                const SizedBox(height: 8),
                _inputField(
                  controller: _nameCtrl,
                  hint: 'Enter your full name',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20),
                _fieldLabel('Email Address'),
                const SizedBox(height: 8),
                _inputField(
                  controller: _emailCtrl,
                  hint: 'mail@example.com',
                  icon: Icons.mail_outline_rounded,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _fieldLabel('Password'),
                const SizedBox(height: 8),
                _passwordField(),
                const SizedBox(height: 20),
                _fieldLabel('Confirm Password'),
                const SizedBox(height: 8),
                _confirmField(),
                const SizedBox(height: 20),
                _termsRow(),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _orDivider(),
                const SizedBox(height: 24),
                _socialButtons(),
                const SizedBox(height: 28),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'MExpense',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? inputType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: _inputDecoration(hint: hint, icon: icon),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordCtrl,
      obscureText: !_passwordVisible,
      decoration: _inputDecoration(
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
        suffix: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
    );
  }

  Widget _confirmField() {
    return TextFormField(
      controller: _confirmCtrl,
      obscureText: true,
      decoration: _inputDecoration(hint: '••••••••', icon: Icons.lock_outline_rounded),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _termsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: AppColors.divider, width: 1.5),
            activeColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: const TextSpan(
              text: 'I agree to the ',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _orDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR REGISTER WITH',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }

  Widget _socialButtons() {
    return const Row(
      children: [
        Expanded(child: _SocialBtn(icon: Icons.g_mobiledata_rounded, label: 'Google')),
        SizedBox(width: 16),
        Expanded(child: _SocialBtn(icon: Icons.apple_rounded, label: 'Apple')),
      ],
    );
  }

  void _submit() {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms of Service')),
      );
      return;
    }
    context.go(AppRoutes.home);
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SocialBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
