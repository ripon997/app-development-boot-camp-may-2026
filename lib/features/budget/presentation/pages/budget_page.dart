import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTotalBudgetCard(),
                        const SizedBox(height: 28),
                        _buildCategoryBudgetHeader(context),
                        const SizedBox(height: 14),
                        _buildBudgetItem(
                          icon: Icons.home_outlined,
                          iconBg: const Color(0xFFE8F5EE),
                          iconColor: AppColors.primary,
                          title: 'Rent & Utilities',
                          subtitle: 'Next due in 5 days',
                          spent: 1200,
                          total: 1200,
                          statusLabel: 'Paid',
                          statusColor: AppColors.income,
                          barColor: AppColors.primary,
                          borderColor: AppColors.primary,
                          percent: 1.0,
                        ),
                        const SizedBox(height: 12),
                        _buildBudgetItem(
                          icon: Icons.restaurant_outlined,
                          iconBg: const Color(0xFFFFF5E6),
                          iconColor: const Color(0xFFFF922B),
                          title: 'Dining & Drinks',
                          subtitle: '⚠ Approaching limit',
                          subtitleColor: const Color(0xFFFF922B),
                          spent: 450,
                          total: 500,
                          statusLabel: '\$50 Remaining',
                          statusColor: const Color(0xFFFF922B),
                          barColor: const Color(0xFFFF922B),
                          borderColor: const Color(0xFFFF922B),
                          percent: 0.9,
                        ),
                        const SizedBox(height: 12),
                        _buildBudgetItem(
                          icon: Icons.shopping_cart_outlined,
                          iconBg: const Color(0xFFFFEEEE),
                          iconColor: AppColors.expense,
                          title: 'Groceries',
                          subtitle: '⊙ Over budget',
                          subtitleColor: AppColors.expense,
                          spent: 650,
                          total: 600,
                          spentColor: AppColors.expense,
                          statusLabel: '-\$50 Excess',
                          statusColor: AppColors.expense,
                          barColor: AppColors.expense,
                          borderColor: AppColors.expense,
                          percent: 1.0,
                          isOverBudget: true,
                        ),
                        const SizedBox(height: 12),
                        _buildBudgetItem(
                          icon: Icons.directions_bus_outlined,
                          iconBg: const Color(0xFFF0EEFF),
                          iconColor: const Color(0xFF6C63FF),
                          title: 'Travel',
                          subtitle: 'Within safe limits',
                          spent: 150,
                          total: 400,
                          statusLabel: '\$250 Remaining',
                          statusColor: const Color(0xFF6C63FF),
                          barColor: const Color(0xFF6C63FF),
                          borderColor: const Color(0xFF6C63FF),
                          percent: 0.375,
                        ),
                        const SizedBox(height: 32),
                        _buildCreateButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 88,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add_rounded),
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
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.mintCircle),
            child: const Icon(Icons.person_rounded, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          const Text(
            'MExpense',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
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

  Widget _buildTotalBudgetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Total Budget',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _DonutPainter(progress: 0.70),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$2,450',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'of \$3,500',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DonutLegend(color: AppColors.primary, label: '70% Spent'),
              SizedBox(width: 24),
              _DonutLegend(color: AppColors.divider, label: '\$1,050 Left'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBudgetHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Category Budgets',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'View All',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    required double spent,
    required double total,
    Color? spentColor,
    required String statusLabel,
    required Color statusColor,
    required Color barColor,
    required Color borderColor,
    required double percent,
    bool isOverBudget = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor ?? AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${spent.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: spentColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '/ \$${total.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: isOverBudget ? 1.0 : percent,
              backgroundColor: barColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(barColor),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              Text(
                '${(isOverBudget ? (spent / total * 100) : percent * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 0,
        ),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
        label: const Text(
          'Create New Budget',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _DonutLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _DonutLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double progress;

  const _DonutPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;
    const strokeWidth = 18.0;

    final bgPaint = Paint()
      ..color = const Color(0xFFE8F0ED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    const fullAngle = 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullAngle,
      false,
      bgPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullAngle * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.progress != progress;
}
