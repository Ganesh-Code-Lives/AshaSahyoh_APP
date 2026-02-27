import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class PersonalDetails extends StatefulWidget {
  final Function(Map<String, dynamic>) onComplete;
  final Map<String, dynamic>? initialData;
  final bool isEditing;

  const PersonalDetails({
    super.key,
    required this.onComplete,
    this.initialData,
    this.isEditing = false,
  });

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  String _gender = '';
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _fullNameController.text = data['fullName'] ?? '';
      _emailController.text = data['email'] ?? '';
      _dateOfBirthController.text = data['dateOfBirth'] ?? '';
      _gender = data['gender'] ?? '';
      _addressController.text = data['address'] ?? '';
    }
  }
  
  // To update UI on change to enable/disable button
  void _updateState() {
     setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  bool get _isValid =>
      _fullNameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _dateOfBirthController.text.isNotEmpty &&
      _gender.isNotEmpty;

  void _handleContinue() async {
    if (_isValid) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', _fullNameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('dateOfBirth', _dateOfBirthController.text);
      await prefs.setString('gender', _gender);
      await prefs.setString('address', _addressController.text);

      widget.onComplete({
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'dateOfBirth': _dateOfBirthController.text,
        'gender': _gender,
        'address': _addressController.text,
      });

      if (widget.isEditing) {
        // when editing we simply pop back to previous screen
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              onChanged: _updateState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Progress
                  Row(
                    children: [
                      Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(width: 8),
                      Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(width: 8),
                      Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(width: 8),
                      Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  const Text('Personal Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  const SizedBox(height: 8),
                  const Text('Please provide your personal information', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                  const SizedBox(height: 32),
                  
                  // Full Name
                  const Text('Full Name *', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(hintText: 'Enter your full name'),
                  ),
                  const SizedBox(height: 16),
                  
                  // Email
                  const Text('Email *', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Enter your email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  
                  // Date of Birth
                  const Text('Date of Birth *', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dateOfBirthController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: const InputDecoration(
                      hintText: 'YYYY-MM-DD', // Typically localized
                      suffixIcon: Icon(Icons.calendar_today, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Gender using Dropdown
                  const Text('Gender *', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _gender.isEmpty ? null : _gender,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                      DropdownMenuItem(value: 'prefer-not-to-say', child: Text('Prefer not to say')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    hint: const Text('Select gender'),
                  ),
                  const SizedBox(height: 16),
                  
                  // Address
                  const Text('Address (Optional)', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Enter your address'),
                  ),
                  const SizedBox(height: 100), // Spacing for bottom button
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: _isValid ? AppTheme.primaryGradient : null,
            color: _isValid ? null : AppTheme.primary.withOpacity(0.1),
          ),
          child: ElevatedButton(
            onPressed: _isValid ? _handleContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: _isValid ? Colors.white : AppTheme.primary.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
