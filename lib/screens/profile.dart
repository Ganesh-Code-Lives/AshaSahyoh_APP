import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_models.dart';

class Profile extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onLogout;
  final PersonalDetailsData? personalData;
  final DisabilityDetailsData? disabilityData;
  final String? mobile;

  const Profile({
    super.key,
    required this.onBack,
    required this.onLogout,
    this.personalData,
    this.disabilityData,
    this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC), // Brand background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 1. Gradient Background
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6A1B9A), Color(0xFF8B5CF6)], // Royal Purple -> lighter
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                  ),
                ),
                
                // 2. Back Button & Title
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: onBack,
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          const Spacer(),
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Avatar (floating halfway)
                Positioned(
                  bottom: -50,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Container(
                            color: const Color(0xFFE5E7EB),
                            child: const Icon(Icons.person, size: 50, color: Color(0xFF9CA3AF)),
                            // Placeholder for image
                            // child: Image.asset('assets/images/avatar.png', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60), // Space for floating avatar

            // --- User Name & Email ---
            Text(
              personalData?.fullName ?? 'AshaSahyog User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              personalData?.email ?? 'user@example.com',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // --- Content Sections ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Personal Information Card
                  _SectionCard(
                    title: 'Personal Information',
                    icon: Icons.person_outline_rounded,
                    children: [
                      _InfoRow(label: 'Full Name', value: personalData?.fullName),
                      _InfoDivider(),
                      _InfoRow(label: 'Mobile', value: mobile != null ? '+91 $mobile' : null),
                      _InfoDivider(),
                      _InfoRow(label: 'Date of Birth', value: personalData?.dateOfBirth?.toLocal().toString().split(' ')[0]),
                      _InfoDivider(),
                      _InfoRow(label: 'Gender', value: personalData?.gender),
                      _InfoDivider(),
                      _InfoRow(label: 'Address', value: personalData?.address, isLast: true),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Disability Information Card
                  _SectionCard(
                    title: 'Disability Details',
                    icon: Icons.accessible_forward_rounded,
                    children: [
                      if (disabilityData?.hasDisability == true) ...[
                        _InfoRow(label: 'Type', value: disabilityData?.disabilityType),
                        _InfoDivider(),
                        _InfoRow(label: 'Percentage', value: disabilityData?.percentage != null ? '${disabilityData!.percentage}%' : null),
                        _InfoDivider(),
                        _InfoRow(label: 'Cert. Number', value: disabilityData?.certificateNumber, isLast: true),
                      ] else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('No disability details provided.', style: TextStyle(color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Settings / Quick Links Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                         BoxShadow(
                          color: const Color(0xFF6A1B9A).withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: Icons.language,
                          color: const Color(0xFF0284C7), 
                          bgColor: const Color(0xFFE0F2FE), 
                          title: 'Language & Accessibility',
                        ),
                        const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 56, endIndent: 20),
                        _SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          color: const Color(0xFFBE185D), 
                          bgColor: const Color(0xFFFCE7F3), 
                          title: 'Change Password',
                        ),
                        const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 56, endIndent: 20),
                        _SettingsTile(
                          icon: Icons.help_outline_rounded,
                          color: const Color(0xFF059669), 
                          bgColor: const Color(0xFFD1FAE5), 
                          title: 'Help & Support',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                      label: const Text('Log Out', style: TextStyle(color: Color(0xFFEF4444), fontSize: 16, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        backgroundColor: const Color(0xFFFEF2F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool isLast;

  const _InfoRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: Color(0xFFF3F4F6)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String title;

  const _SettingsTile({required this.icon, required this.color, required this.bgColor, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF374151),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF), size: 20),
      onTap: () {},
    );
  }
}
