import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _current = 0;

  static const _slides = [
    _SlideData(
      title: 'Master Your Money',
      subtitle: 'Easily track every expense and income\nwith a few taps.',
      cardLabel: 'Saving Goal',
      cardIcon: Icons.trending_up_rounded,
      illustrationWidget: _SavingGoalIllustration(),
    ),
    _SlideData(
      title: 'Smart Insights',
      subtitle: 'Get beautiful reports and understand\nwhere your money goes.',
      cardLabel: 'Analytics',
      cardIcon: Icons.bar_chart_rounded,
      illustrationWidget: _InsightsIllustration(),
    ),
    _SlideData(
      title: 'Stay in Control',
      subtitle: 'Set budgets and get alerts before\nyou overspend.',
      cardLabel: 'Budget Alert',
      cardIcon: Icons.notifications_outlined,
      illustrationWidget: _BudgetIllustration(),
    ),
  ];

  void _next() {
    if (_current < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 24, 0),
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _current = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _OnboardingSlide(data: _slides[i]),
              ),
            ),
            // Dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = i == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : const Color(0xFFCDD5D0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _current == _slides.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final _SlideData data;

  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Illustration frame
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Center(child: data.illustrationWidget),
                  // Card overlay at bottom
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              data.cardIcon,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.cardLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: const LinearProgressIndicator(
                                  value: 0.65,
                                  minHeight: 4,
                                  backgroundColor: Color(0xFFE5E7EB),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SlideData {
  final String title;
  final String subtitle;
  final String cardLabel;
  final IconData cardIcon;
  final Widget illustrationWidget;

  const _SlideData({
    required this.title,
    required this.subtitle,
    required this.cardLabel,
    required this.cardIcon,
    required this.illustrationWidget,
  });
}

// ── Illustrations ──────────────────────────────────────────────────────────

class _SavingGoalIllustration extends StatelessWidget {
  const _SavingGoalIllustration();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Simulated phone UI
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                _StatRow(label: 'Monthly Budget', value: '\$2,400', progress: 0.55),
                SizedBox(height: 12),
                _StatRow(label: 'Savings Goal', value: '\$800', progress: 0.80),
                SizedBox(height: 12),
                _StatRow(label: 'Investments', value: '\$1,200', progress: 0.40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsIllustration extends StatelessWidget {
  const _InsightsIllustration();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SPENT',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      const Text('\$2.4k',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.trending_up, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SAVINGS',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600)),
                              Text('+12%',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined,
                              color: Colors.white70, size: 14),
                          SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('BUDGET',
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600)),
                              Text('\$800',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weekly Spending',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary)),
                    Text('Last 7 Days',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: CustomPaint(painter: _SparklinePainter()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetIllustration extends StatelessWidget {
  const _BudgetIllustration();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                _BudgetItem(label: 'Food & Drinks', spent: 320, budget: 500, color: Color(0xFFFF6B6B)),
                SizedBox(height: 12),
                _BudgetItem(label: 'Transport', spent: 95, budget: 150, color: Color(0xFF4D96FF)),
                SizedBox(height: 12),
                _BudgetItem(label: 'Shopping', spent: 410, budget: 400, color: Color(0xFFCC5DE8), over: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;

  const _StatRow({
    required this.label,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ],
    );
  }
}

class _BudgetItem extends StatelessWidget {
  final String label;
  final double spent;
  final double budget;
  final Color color;
  final bool over;

  const _BudgetItem({
    required this.label,
    required this.spent,
    required this.budget,
    required this.color,
    this.over = false,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (spent / budget).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text('\$${spent.toInt()} / \$${budget.toInt()}',
                style: TextStyle(
                    color: over ? const Color(0xFFFF6B6B) : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 5,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = [0.7, 0.4, 0.6, 0.3, 0.5, 0.2, 0.45];
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * size.width / (points.length - 1);
        final prevY = size.height * (1 - points[i - 1]);
        final cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
