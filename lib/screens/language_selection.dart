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

  final Map<String, Color> baseColors = {
    'en': const Color(0xFFFBCFE8),
    'hi': const Color(0xFFBAE6FD),
    'mr': const Color(0xFFA7F3D0),
  };

  final Map<String, Color> activeLightColors = {
    'en': const Color(0xFFFCE7F3),
    'hi': const Color(0xFFE0F2FE),
    'mr': const Color(0xFFD1FAE5),
  };

  final Map<String, Color> borderColors = {
    'en': const Color(0xFFF472B6),
    'hi': const Color(0xFF0284C7),
    'mr': const Color(0xFF059669),
  };

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
                
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: languages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final code = lang['code']!;
                    final isActive = selectedLanguage == code;
                    
                    return InkWell(
                      onTap: () => setState(() => selectedLanguage = code),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isActive ? activeLightColors[code] : baseColors[code],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? borderColors[code]! : baseColors[code]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang['name']!, 
                                    style: const TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold, 
                                      color: Colors.black87
                                    )
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lang['nativeName']!, 
                                    style: const TextStyle(
                                      fontSize: 14, 
                                      color: Colors.black54
                                    )
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isActive ? 1.0 : 0.0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: borderColors[code],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check, 
                                  size: 18, 
                                  color: Colors.white
                                ),
                              ),
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
