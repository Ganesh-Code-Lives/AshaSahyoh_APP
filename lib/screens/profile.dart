import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../models/user_models.dart';
import 'personal_details.dart';
import 'disability_details.dart';

class Profile extends StatefulWidget {
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
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _headerSlide;
  late Animation<double> _bodyFade;
  String? _profileImageBase64;
  bool _isAvatarPressed = false;

  String fullName = '';
  String email = '';
  String dateOfBirth = '';
  String gender = '';
  String address = '';
  bool hasDisability = false;
  String disabilityType = '';
  String disabilityPercentage = '';
  String certificateNumber = '';
  List<String> assistiveDevices = [];
  String? mobile;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadProfileData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    ));

    _bodyFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImageBase64 = prefs.getString('profileImageBase64');
    });
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'AshaSahyog User';
      email = prefs.getString('email') ?? 'user@example.com';
      dateOfBirth = prefs.getString('dateOfBirth') ?? '';
      gender = prefs.getString('gender') ?? '';
      address = prefs.getString('address') ?? '';
      hasDisability = prefs.getBool('hasDisability') ?? false;
      disabilityType = prefs.getString('disabilityType') ?? '';
      disabilityPercentage = prefs.getString('disabilityPercentage') ?? '';
      certificateNumber = prefs.getString('certificateNumber') ?? '';
      assistiveDevices = prefs.getStringList('assistiveDevices') ?? [];
      mobile = prefs.getString('phoneNumber');
    });
  }

  Future<void> _handleImageChange() async {
    if (_profileImageBase64 != null) {
      final shouldChange = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change Photo'),
          content: const Text('Do you want to change your profile photo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Change'),
            ),
          ],
        ),
      );
      if (shouldChange != true) return;
    }
    await _pickImage();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64String = base64Encode(bytes);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImageBase64', base64String);
        if (mounted) {
          setState(() {
            _profileImageBase64 = base64String;
          });
        }
      }
    } catch (e) {
      debugPrint("Image picking failed: $e");
    }
  }

  Future<void> _openEditOptions() async {
    final choice = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Personal Info'),
              onTap: () => Navigator.pop(context, 0),
            ),
            ListTile(
              leading: const Icon(Icons.accessible),
              title: const Text('Edit Disability Info'),
              onTap: () => Navigator.pop(context, 1),
            ),
          ],
        );
      },
    );

    if (choice == 0) {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PersonalDetails(
          onComplete: (_) {},
          initialData: {
            'fullName': fullName,
            'email': email,
            'dateOfBirth': dateOfBirth,
            'gender': gender,
            'address': address,
          },
          isEditing: true,
        ),
      ));
      _loadProfileData();
    } else if (choice == 1) {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DisabilityDetails(
          onComplete: (_) {},
          initialData: {
            'hasDisability': hasDisability,
            'disabilityType': disabilityType,
            'disabilityPercentage': disabilityPercentage,
            'certificateNumber': certificateNumber,
            'assistiveDevices': assistiveDevices,
          },
          isEditing: true,
        ),
      ));
      _loadProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SlideTransition(
              position: _headerSlide,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                  ),
                  
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
                              onPressed: widget.onBack,
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
                              onPressed: _openEditOptions,
                              icon: const Icon(Icons.settings, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -50,
                    child: Column(
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: _handleImageChange,
                            onHighlightChanged: (isHighlighted) {
                              setState(() {
                                _isAvatarPressed = isHighlighted;
                              });
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: _isAvatarPressed ? AppTheme.border : Colors.white, 
                                  width: 4
                                ),
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
                                  color: const Color(0xFFF3E8FF),
                                  child: _profileImageBase64 != null
                                      ? Image.memory(base64Decode(_profileImageBase64!), fit: BoxFit.cover)
                                      : const Icon(Icons.person, size: 50, color: AppTheme.primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            FadeTransition(
              opacity: _bodyFade,
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  Text(
                    fullName.isNotEmpty ? fullName : 'AshaSahyog User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email.isNotEmpty ? email : 'user@example.com',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _SectionCard(
                          title: 'Personal Information',
                          icon: Icons.person_outline_rounded,
                          children: [
                            _InfoRow(label: 'Full Name', value: fullName),
                            _InfoDivider(),
                            _InfoRow(label: 'Mobile', value: mobile != null ? '+91 $mobile' : null),
                            _InfoDivider(),
                            _InfoRow(label: 'Date of Birth', value: dateOfBirth.isNotEmpty ? DateTime.tryParse(dateOfBirth)?.toLocal().toString().split(' ')[0] : null),
                            _InfoDivider(),
                            _InfoRow(label: 'Gender', value: gender),
                            _InfoDivider(),
                            _InfoRow(label: 'Address', value: address, isLast: true),
                          ],
                        ),

                        const SizedBox(height: 20),

                        _SectionCard(
                          title: 'Disability Details',
                          icon: Icons.accessible_forward_rounded,
                          children: [
                            if (hasDisability) ...[
                              _InfoRow(label: 'Type', value: disabilityType),
                              _InfoDivider(),
                              _InfoRow(label: 'Percentage', value: disabilityPercentage.isNotEmpty ? '$disabilityPercentage%' : null),
                              _InfoDivider(),
                              _InfoRow(label: 'Cert. Number', value: certificateNumber, isLast: true),
                            ] else
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('No disability details provided.', style: TextStyle(color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border, width: 2),
                          ),
                          child: Column(
                            children: [
                              _SettingsTile(
                                icon: Icons.language,
                                color: const Color(0xFF0284C7), 
                                bgColor: const Color(0xFFE0F2FE), 
                                title: 'Language & Accessibility',
                              ),
                              Divider(height: 1, color: AppTheme.border, indent: 56, endIndent: 20),
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

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: widget.onLogout,
                            icon: const Icon(Icons.logout_rounded, color: Color(0xFFBE185D)),
                            label: const Text('Log Out', style: TextStyle(color: Color(0xFFBE185D), fontSize: 16, fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFECACA)),
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
          ],
        ),
      ),
    );
  }
}


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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 2),
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
          Divider(height: 1, color: AppTheme.border),
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
      child: Divider(height: 1, color: AppTheme.border),
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
