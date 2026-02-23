import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../components/bottom_nav.dart';
import 'schemes_finder.dart';
import 'hospital_locator.dart';
import 'document_vault.dart';
import 'reminders.dart';
import 'profile.dart';
import 'support.dart';
import 'emergency_sos.dart';
import '../models/user_models.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? personalData;
  final Map<String, dynamic>? disabilityData;
  final VoidCallback onLogout;

  const HomeScreen({super.key, this.personalData, this.disabilityData, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentScreen = 'home'; 
  
  String fullName = 'User';
  String phoneNumber = '';
  String email = '';
  String dateOfBirth = '';
  String gender = '';
  String address = '';
  String disabilityType = '';
  String disabilityPercentage = '';
  String certificateNumber = '';
  List<String> assistiveDevices = [];
  String? _profileImageBase64;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'User';
      phoneNumber = prefs.getString('phoneNumber') ?? '';
      email = prefs.getString('email') ?? '';
      dateOfBirth = prefs.getString('dateOfBirth') ?? '';
      gender = prefs.getString('gender') ?? '';
      address = prefs.getString('address') ?? '';
      disabilityType = prefs.getString('disabilityType') ?? '';
      disabilityPercentage = prefs.getString('disabilityPercentage') ?? '';
      certificateNumber = prefs.getString('certificateNumber') ?? '';
      assistiveDevices = prefs.getStringList('assistiveDevices') ?? [];
      _profileImageBase64 = prefs.getString('profileImageBase64');
    });
  }

  void _navigate(String screen) {
     if (screen == 'home') {
       _loadProfile();
     }
     setState(() {
       currentScreen = screen;
     });
  }

  @override
  Widget build(BuildContext context) {
    // Basic scaffold for Home, we can expand later for other screens
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Container(
           constraints: const BoxConstraints(maxWidth: 480),
           // Mimic the app-screen class
           margin: const EdgeInsets.symmetric(horizontal: 0), 
           decoration: const BoxDecoration(
             color: AppTheme.background,
           ),
           child: Column(
             children: [
               Expanded(
                 child: _buildBody(),
               ),
               BottomNav(active: currentScreen, onNavigate: _navigate),
             ],
           ),
        ),
      ),
    );
  }

  Widget _buildBody() {
     // TODO: Implement other screens
    if (currentScreen == 'schemes') return SchemesFinder(onBack: () => _navigate('home'));
    if (currentScreen == 'hospitals') return HospitalLocator(onBack: () => _navigate('home'));
    if (currentScreen == 'documents') return DocumentVault(onBack: () => _navigate('home'));
    if (currentScreen == 'reminders') return Reminders(onBack: () => _navigate('home'));
    if (currentScreen == 'profile') {
      return Profile(
        onBack: () => _navigate('home'),
        onLogout: widget.onLogout,
        personalData: PersonalDetailsData(
          fullName: fullName,
          email: email,
          dateOfBirth: dateOfBirth.length > 0 ? DateTime.tryParse(dateOfBirth) : null,
          gender: gender,
          address: address,
        ),
        disabilityData: DisabilityDetailsData(
          hasDisability: disabilityType.length > 0,
          disabilityType: disabilityType,
          percentage: disabilityPercentage.length > 0 ? disabilityPercentage : null,
          certificateNumber: certificateNumber.length > 0 ? certificateNumber : null,
          assistiveDevices: assistiveDevices,
        ),
        mobile: phoneNumber.length > 0 ? phoneNumber : '9876543210',
      );
    }
    if (currentScreen == 'support') return Support(onBack: () => _navigate('home'));
    if (currentScreen == 'sos') return EmergencySOS(onBack: () => _navigate('home'));

     // Default: Home Dashboard
     return SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
             // Header
             SafeArea(
               bottom: false,
               child: Column(
                 children: [
                   Container(
                     width: double.infinity,
                     padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                     decoration: const BoxDecoration(
                       color: AppTheme.purpleLight,
                        border: Border(bottom: BorderSide(color: AppTheme.border, width: 2)),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text(
                                 'Welcome back,',
                                 style: TextStyle(
                                   color: Color(0xFF6E29DA), // Branded Purple
                                   fontSize: 13,
                                   fontWeight: FontWeight.w500,
                                 ),
                               ),
                               const SizedBox(height: 2),
                               Text(
                                 fullName,
                                 style: const TextStyle(
                                   fontSize: 24, 
                                   fontWeight: FontWeight.bold, 
                                   color: Color(0xFF1F2937), // Dark Charcoal
                                 ),
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                               ),
                               const SizedBox(height: 4),
                                const Text(
                                 'How can we help you today?',
                                 style: TextStyle(
                                   color: Color(0xFF9CA3AF), // Light Grey
                                   fontSize: 13,
                                 ),
                               ),
                             ],
                           ),
                         ),
                         InkWell(
                           onTap: () => _navigate('profile'),
                           borderRadius: BorderRadius.circular(24),
                           child: Container(
                             width: 48,
                             height: 48,
                             decoration: BoxDecoration(
                               color: const Color(0xFFF3E8FF), // Very light purple bg
                               shape: BoxShape.circle,
                               border: Border.all(color: const Color(0xFFE9D5FF), width: 1),
                             ),
                             child: ClipOval(
                               clipBehavior: Clip.hardEdge,
                               child: _profileImageBase64 != null
                                    ? Image.memory(base64Decode(_profileImageBase64!), fit: BoxFit.cover, width: 48, height: 48)
                                    : const Icon(Icons.person, color: Color(0xFF7C3AED), size: 24),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
             ),

           Padding(
             padding: const EdgeInsets.all(24),
             child: Column(
               children: [
                 // Quick Actions Grid
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 140,
                    ),
                   children: [
                     _buildQuickActionCard(
                       'Find Schemes',
                       Icons.description,
                       const Color(0xFFC4B5FD), // Light Purple
                       AppTheme.primary,
                       () => _navigate('schemes'),
                     ),
                     _buildQuickActionCard(
                       'Nearby Hospitals',
                       Icons.add,
                       const Color(0xFFA7F3D0), // Light Green
                       const Color(0xFF059669), // Green
                       () => _navigate('hospitals'),
                     ),
                     _buildQuickActionCard(
                       'My Documents',
                       Icons.folder,
                       const Color(0xFFBAE6FD), // Light Blue
                       const Color(0xFF0284C7), // Blue
                       () => _navigate('documents'),
                     ),
                     _buildQuickActionCard(
                       'My Reminders',
                       Icons.notifications,
                       const Color(0xFFFBCFE8), // Light Pink
                       const Color(0xFFBE185D), // Pink
                       () => _navigate('reminders'),
                     ),
                   ],
                 ),

                 const SizedBox(height: 24),

                 // Today at a Glance
                 const Align(
                   alignment: Alignment.centerLeft,
                   child: Text('Today at a Glance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                 ),
                 const SizedBox(height: 16),
                 
                 _buildGlanceCard(
                   'Doctor\'s Appointment',
                   'Today at 2:00 PM',
                   Icons.calendar_today,
                   const Color(0xFFC4B5FD),
                   AppTheme.primary,
                 ),
                 const SizedBox(height: 12),
                 _buildGlanceCard(
                   'Disability Certificate Renewal',
                   'Due in 5 days',
                   Icons.warning,
                   const Color(0xFFFBCFE8), // Pink
                   const Color(0xFFBE185D),
                 ),

                 const SizedBox(height: 24),
                 
                 // Recommended Schemes
                 const Align(
                   alignment: Alignment.centerLeft,
                   child: Text('Recommended Schemes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                 ),
                 const SizedBox(height: 16),
                 SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: Row(
                     children: [
                       _buildSchemeCard('Financial Aid Program', 'Provides monthly financial assistance to persons with benchmark disabilities to support their basic needs...', AppTheme.primary),
                       const SizedBox(width: 12),
                       _buildSchemeCard('Assistive Devices', 'Offers financial assistance for purchasing durable, advanced, and scientifically designed assistive devices...', AppTheme.success),
                       const SizedBox(width: 12),
                       _buildSchemeCard('Concessional Travel Pass', 'Provides concessions on train fares for persons with disabilities across multiple travel classes...', AppTheme.primary),
                     ],
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
       borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.volume_up, size: 16, color: iconColor.withOpacity(0.7)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title, 
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: AppTheme.textMain,
                fontSize: 15,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlanceCard(String title, String subtitle, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
           Container(
             width: 40,
             height: 40,
             decoration: BoxDecoration(
               color: bgColor,
               borderRadius: BorderRadius.circular(8),
             ),
             child: Icon(icon, color: iconColor, size: 20),
           ),
           const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.textMain),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle, 
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(String title, String description, Color color) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(description, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size(double.infinity, 36),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
             child: const Text('Learn More', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
