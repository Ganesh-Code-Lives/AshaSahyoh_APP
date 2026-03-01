import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class DisabilityDetails extends StatefulWidget {
  final Function(Map<String, dynamic>) onComplete;
  final Map<String, dynamic>? initialData;
  final bool isEditing;

  const DisabilityDetails({
    super.key,
    required this.onComplete,
    this.initialData,
    this.isEditing = false,
  });

  @override
  State<DisabilityDetails> createState() => _DisabilityDetailsState();
}

class _DisabilityDetailsState extends State<DisabilityDetails> {
  bool _hasDisability = false;
  String _disabilityType = '';
  final _percentageController = TextEditingController();
  final _certificateController = TextEditingController();
  final List<String> _selectedDevices = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _hasDisability = data['hasDisability'] == true;
      _disabilityType = data['disabilityType'] ?? '';
      _percentageController.text = data['disabilityPercentage'] ?? '';
      _certificateController.text = data['certificateNumber'] ?? '';
      if (data['assistiveDevices'] is List<String>) {
        _selectedDevices.addAll(List<String>.from(data['assistiveDevices']));
      }
    }
  }

  final List<String> _availableDevices = [
    "Wheelchair",
    "Hearing Aid",
    "Cane",
    "Prosthetics",
    "Screen Reader",
    "Other",
  ];

  void _toggleDevice(String device) {
    setState(() {
      if (_selectedDevices.contains(device)) {
        _selectedDevices.remove(device);
      } else {
        _selectedDevices.add(device);
      }
    });
  }

  void _handleContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedProfile', true);
    await prefs.setString('disabilityType', _disabilityType);
    await prefs.setString('disabilityPercentage', _percentageController.text);
    await prefs.setString('certificateNumber', _certificateController.text);
    await prefs.setStringList('assistiveDevices', _selectedDevices);
    
    widget.onComplete({
      'hasDisability': _hasDisability,
      'disabilityType': _disabilityType,
      'disabilityPercentage': _percentageController.text,
      'certificateNumber': _certificateController.text,
      'assistiveDevices': _selectedDevices,
    });

    if (widget.isEditing) {
      Navigator.of(context).pop(true);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                const Text('Disability Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                const SizedBox(height: 8),
                const Text('(Optional) This helps us provide better services', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: Text('I have a disability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textMain))),
                      Switch(
                        value: _hasDisability,
                        onChanged: (val) => setState(() => _hasDisability = val),
                        activeThumbColor: AppTheme.primary,
                      ),
                    ],
                  ),
                ),

                if (_hasDisability) ...[
                  const SizedBox(height: 24),
                  
                  const Text('Type of Disability', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _disabilityType.isEmpty ? null : _disabilityType,
                    items: const [
                      DropdownMenuItem(value: 'visual', child: Text('Visual Impairment')),
                      DropdownMenuItem(value: 'hearing', child: Text('Hearing Impairment')),
                      DropdownMenuItem(value: 'mobility', child: Text('Mobility Impairment')),
                      DropdownMenuItem(value: 'cognitive', child: Text('Cognitive Impairment')),
                      DropdownMenuItem(value: 'speech', child: Text('Speech Impairment')),
                      DropdownMenuItem(value: 'multiple', child: Text('Multiple Disabilities')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (val) => setState(() => _disabilityType = val!),
                    decoration: const InputDecoration(hintText: 'Select disability type'),
                  ),
                  const SizedBox(height: 16),

                  const Text('Disability Percentage (if known)', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _percentageController,
                    decoration: const InputDecoration(hintText: 'Enter percentage'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('Disability Certificate Number (if available)', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _certificateController,
                    decoration: const InputDecoration(hintText: 'Enter certificate number'),
                  ),
                  const SizedBox(height: 24),

                  const Text('Assistive Devices Used (if any)', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableDevices.map((device) {
                      final isSelected = _selectedDevices.contains(device);
                      return InkWell(
                        onTap: () => _toggleDevice(device),
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primary : Colors.white,
                            border: Border.all(
                              color: isSelected ? AppTheme.primary : AppTheme.border,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            device,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : AppTheme.textMain,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.purpleVeryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.privacy_tip_outlined, size: 20, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This information is kept confidential and is used only to personalize your experience and suggest relevant schemes.',
                          style: TextStyle(color: AppTheme.primary.withOpacity(0.8), fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: AppTheme.primaryGradient,
          ),
          child: ElevatedButton(
            onPressed: _handleContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Complete Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
