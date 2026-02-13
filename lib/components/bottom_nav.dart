import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final String active;
  final Function(String) onNavigate;

  const BottomNav({super.key, required this.active, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('home', Icons.home, 'Home'),
          _buildNavItem('schemes', Icons.description, 'Schemes'),
          
          // SOS Button
          InkWell(
            onTap: () => onNavigate('sos'),
            borderRadius: BorderRadius.circular(28),
            child: Container(
              margin: const EdgeInsets.only(bottom: 24), // -mt-8 effect
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: active == 'sos' ? AppTheme.primaryDark : AppTheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active == 'sos' ? AppTheme.primaryDark : AppTheme.primary,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: const Center(
                child: Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          _buildNavItem('support', Icons.headset_mic, 'Support'),
          _buildNavItem('profile', Icons.group, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String key, IconData icon, String label) {
    final isActive = active == key;
    final color = isActive ? AppTheme.primary : AppTheme.textSecondary;
    
    return InkWell(
      onTap: () => onNavigate(key),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
