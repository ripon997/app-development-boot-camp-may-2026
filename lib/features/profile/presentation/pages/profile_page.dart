import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 16),
                    const Text(
                      'Raihan Ripon',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ripon365cse@gmail.com',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 32),
                    _sectionLabel('Account'),
                    const SizedBox(height: 10),
                    _settingsCard([
                      _SettingsRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Personal Info',
                        onTap: () {},
                      ),
                      _SettingsRow(
                        icon: Icons.shield_outlined,
                        label: 'Security',
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _sectionLabel('Preferences'),
                    const SizedBox(height: 10),
                    _settingsCard([
                      _SettingsRow(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'Currency',
                        trailing: const Text(
                          'USD (\$)',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                        onTap: () {},
                      ),
                      _SettingsRow(
                        icon: Icons.translate_rounded,
                        label: 'Language',
                        trailing: const Text(
                          'English',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _sectionLabel('Appearance'),
                    const SizedBox(height: 10),
                    _settingsCard([
                      _ToggleRow(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark Mode',
                        statusLabel: _darkMode ? 'On' : 'Off',
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _sectionLabel('Support'),
                    const SizedBox(height: 10),
                    _settingsCard([
                      _SettingsRow(
                        icon: Icons.help_outline_rounded,
                        label: 'Help Center',
                        onTap: () {},
                      ),
                      _SettingsRow(
                        icon: Icons.policy_outlined,
                        label: 'Privacy Policy',
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 32),
                    _logoutButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mintCircle,
            ),
            child: ClipOval(
              child: Container(
                color: AppColors.mintCircle,
                child: const Icon(Icons.person_rounded, size: 22, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'MExpense',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: 3),
            color: AppColors.mintCircle,
          ),
          child: ClipOval(
            child: Container(
              color: AppColors.mintCircle,
              child: const Icon(Icons.person_rounded, size: 52, color: AppColors.primary),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit_rounded, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.divider),
            rows[i],
          ],
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.login),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.expense, size: 22),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.expense,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.mintCircle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 22),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String statusLabel;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.statusLabel,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.mintCircle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            statusLabel,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.accent,
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.divider,
          ),
        ],
      ),
    );
  }
}
