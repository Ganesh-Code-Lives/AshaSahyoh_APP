import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Support extends StatelessWidget {
  final VoidCallback onBack;

  const Support({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Clean background
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. Header ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded, size: 28, color: Color(0xFF111827)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Help & Assistance',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Voice accessibility action
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF), // Light purple bg
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.volume_up_rounded, color: AppTheme.primary, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            // --- Scrollable Content ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 2. Emergency Warning Banner ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2), // Light Red
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 24),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "In case of immediate danger call 112",
                              style: TextStyle(
                                color: Color(0xFF991B1B),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Call 112",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- 3. Quick Emergency Grid ---
                    const Text(
                      'Quick Emergency',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 16),
                    
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Manual Grid implementation for better control than GridView inside ScrollView
                        final double itemWidth = (constraints.maxWidth - 16) / 2;
                        final double itemHeight = 140;

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _EmergencyCard(
                              width: itemWidth,
                              height: itemHeight,
                              title: "Ambulance",
                              number: "108",
                              icon: Icons.medical_services_outlined,
                              colorTheme: const Color(0xFFDC2626), // Red
                              bgColor: const Color(0xFFFEF2F2),
                            ),
                            _EmergencyCard(
                              width: itemWidth,
                              height: itemHeight,
                              title: "Police",
                              number: "100",
                              icon: Icons.local_police_outlined,
                              colorTheme: const Color(0xFF2563EB), // Blue
                              bgColor: const Color(0xFFEFF6FF),
                            ),
                            _EmergencyCard(
                              width: itemWidth,
                              height: itemHeight,
                              title: "Fire",
                              number: "101",
                              icon: Icons.local_fire_department_outlined,
                              colorTheme: const Color(0xFFEA580C), // Orange
                              bgColor: const Color(0xFFFFF7ED),
                            ),
                            _EmergencyCard(
                              width: itemWidth,
                              height: itemHeight,
                              title: "Women Help",
                              number: "1091",
                              icon: Icons.female_rounded,
                              colorTheme: const Color(0xFFDB2777), // Pink
                              bgColor: const Color(0xFFFDF2F8),
                            ),
                          ],
                        );
                      }
                    ),

                    const SizedBox(height: 32),

                    // --- 4. Government Helpline Section ---
                    const Text(
                      'Government Helpline Numbers',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 16),
                    
                    _HelplineCard(
                      title: 'Disability Helpline',
                      number: '1800-222-014',
                      icon: Icons.accessible_forward,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: AppTheme.primary,
                    ),
                    const SizedBox(height: 12),
                    _HelplineCard(
                      title: 'Health Ministry',
                      number: '1075',
                      icon: Icons.health_and_safety_outlined,
                      iconBg: const Color(0xFFE0F2FE),
                      iconColor: const Color(0xFF0284C7),
                    ),
                    const SizedBox(height: 12),
                    _HelplineCard(
                      title: 'Senior Citizen Helpline',
                      number: '14567',
                      icon: Icons.elderly_rounded,
                      iconBg: const Color(0xFFDCFCE7),
                      iconColor: const Color(0xFF16A34A),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String number;
  final IconData icon;
  final Color colorTheme;
  final Color bgColor;

  const _EmergencyCard({
    required this.width,
    required this.height,
    required this.title,
    required this.number,
    required this.icon,
    required this.colorTheme,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border, width: 2), // Added border to match Home Screen
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          splashColor: colorTheme.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: colorTheme, size: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  "$title ($number)",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Call Now",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorTheme,
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

class _HelplineCard extends StatelessWidget {
  final String title;
  final String number;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _HelplineCard({
    required this.title,
    required this.number,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7), // Light green
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.call, size: 16, color: Color(0xFF16A34A)),
                      const SizedBox(width: 6),
                      const Text(
                        "Call",
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
