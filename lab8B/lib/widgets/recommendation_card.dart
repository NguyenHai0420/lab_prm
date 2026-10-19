import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String advice;
  final Color primaryColor;
  final Color backgroundColor;
  final Widget? trailingBadge;

  const RecommendationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.advice,
    required this.primaryColor,
    required this.backgroundColor,
    this.trailingBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                    ?trailingBadge,
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  advice,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
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
