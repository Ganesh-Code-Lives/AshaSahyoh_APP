import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Reminders extends StatelessWidget {
  final VoidCallback onBack;

  const Reminders({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.border, width: 2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back, color: AppTheme.textMain)),
                      const Text('Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: AppTheme.textMain)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search reminders...',
                      prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            
            // Reminders List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _ReminderCard(
                    title: 'Doctor\'s Appointment',
                    subtitle: 'Dr. Mehta - Cardiology',
                    badge: 'Today',
                    badgeColor: Color(0xFFDDD6FE),
                    badgeTextColor: AppTheme.primary,
                    time: '2:00 PM',
                    icon: Icons.access_time,
                    bgColor: Color(0xFFF3E8FF),
                    borderColor: AppTheme.border,
                  ),
                  SizedBox(height: 12),
                  _ReminderCard(
                    title: 'Medication Reminder',
                    subtitle: 'Take Paracetamol (500mg)',
                    badge: 'Daily',
                    badgeColor: Color(0xFF6EE7B7),
                    badgeTextColor: Color(0xFF065F46),
                    time: '8:00 AM, 8:00 PM',
                    icon: Icons.access_time,
                    bgColor: Color(0xFFD1FAE5),
                    borderColor: Color(0xFFA7F3D0),
                  ),
                  SizedBox(height: 12),
                  _ReminderCard(
                    title: 'Renew Disability Certificate',
                    subtitle: 'Visit local government office',
                    time: '25 July 2024',
                    icon: Icons.calendar_today,
                    bgColor: Color(0xFFFCE7F3),
                    borderColor: Color(0xFFFBCFE8),
                  ),
                  SizedBox(height: 12),
                   _ReminderCard(
                    title: 'Physiotherapy Session',
                    subtitle: 'Home visit session',
                    badge: 'Completed',
                    badgeColor: Color(0xFFE5E7EB),
                    badgeTextColor: AppTheme.textSecondary,
                    time: '18 July 2024',
                    icon: Icons.calendar_today,
                    bgColor: Colors.white,
                    borderColor: Color(0xFFE5E7EB),
                    isCompleted: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final String time;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final bool isCompleted;

  const _ReminderCard({
    required this.title,
    required this.subtitle,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    required this.time,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Opacity(
        opacity: isCompleted ? 0.6 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Dot / Check
            Container(
              margin: const EdgeInsets.only(top: 4, right: 12),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.primary : null,
                border: Border.all(color: AppTheme.primary, width: 2),
                shape: BoxShape.circle,
              ),
              child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isCompleted ? AppTheme.textSecondary : AppTheme.textMain,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(badge!, style: TextStyle(color: badgeTextColor, fontSize: 12)),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(icon, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(time, style: const TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
