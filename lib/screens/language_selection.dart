import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageSelection extends StatefulWidget {
  final Function(String) onComplete;

  const LanguageSelection({super.key, required this.onComplete});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String selectedLanguage = '';

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
    {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी'},
  ];

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
                // Progress Indicator
                Row(
                  children: [
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.purpleLight, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.purpleLight, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(width: 8),
                    Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppTheme.purpleLight, borderRadius: BorderRadius.circular(2)))),
                  ],
                ),
                const SizedBox(height: 32),
                
                const Text(
                  'Select Your Language',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose your preferred language for the app',
                  style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 32),
                
                // Language List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: languages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isActive = selectedLanguage == lang['code'];
                    return InkWell(
                      onTap: () => setState(() => selectedLanguage = lang['code']!),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isActive ? AppTheme.primary : Colors.transparent, 
                            width: 2
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lang['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textMain)),
                                  const SizedBox(height: 4),
                                  Text(lang['nativeName']!, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isActive ? AppTheme.primary : AppTheme.purpleLight.withOpacity(0.3),
                                shape: BoxShape.circle,
                                border: isActive ? null : Border.all(color: AppTheme.purpleLight),
                              ),
                              child: isActive 
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
            gradient: selectedLanguage.isNotEmpty ? AppTheme.primaryGradient : null,
            color: selectedLanguage.isNotEmpty ? null : AppTheme.primary.withOpacity(0.1),
          ),
          child: ElevatedButton(
            onPressed: selectedLanguage.isNotEmpty ? () => widget.onComplete(selectedLanguage) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: selectedLanguage.isNotEmpty ? Colors.white : AppTheme.primary.withOpacity(0.5),
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
