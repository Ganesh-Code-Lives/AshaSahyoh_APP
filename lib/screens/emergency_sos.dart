import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmergencySOS extends StatelessWidget {
  final VoidCallback onBack;

  const EmergencySOS({super.key, required this.onBack});

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back, color: AppTheme.textMain)),
                  const Text('Emergency SOS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.volume_up, color: AppTheme.textSecondary)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // SOS Button
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.border, width: 2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(width: 256, height: 256, decoration: BoxDecoration(color: const Color(0xFFFEE2E2).withOpacity(0.4), shape: BoxShape.circle)),
                            Container(width: 192, height: 192, decoration: BoxDecoration(color: const Color(0xFFFECACA).withOpacity(0.6), shape: BoxShape.circle)),
                            Container(width: 128, height: 128, decoration: BoxDecoration(color: const Color(0xFFFCA5A5).withOpacity(0.8), shape: BoxShape.circle)),
                            
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC2626),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFB91C1C), width: 4),
                                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('SOS', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                                    Text('Tap to send alert', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Share Live Location
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.border, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Share Live Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                              Switch(value: false, onChanged: (v){}, activeThumbColor: AppTheme.primary),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Share with:', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                Text('Asha Kumari (Caregiver)', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w500)),
                                Text('+91 98765 43210', style: TextStyle(color: AppTheme.textSecondary)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person_add, size: 16),
                            label: const Text('Change Caregiver'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primary,
                              side: const BorderSide(color: Color(0xFFC4B5FD), width: 2),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Emergency Contacts
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text('Emergency Contacts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                         const SizedBox(height: 12),
                         const _ContactItem(name: 'Ravi Sharma', relation: 'Brother - +91 99887 76455'),
                         const SizedBox(height: 12),
                         const _ContactItem(name: 'Sunita Verma', relation: 'Neighbor - +91 88776 65544'),
                         const SizedBox(height: 12),
                         OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person_add, size: 16),
                            label: const Text('Add Emergency Contact'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primary,
                              side: const BorderSide(color: Color(0xFFC4B5FD), width: 2, style: BorderStyle.none), // Dotted border hard to do with OutlinedButton standard
                              backgroundColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ).copyWith(
                              side: WidgetStateProperty.all(const BorderSide(color: Color(0xFFC4B5FD), width: 2)), // Reverting to solid for simplicity or use CustomPaint for dotted
                            ),
                          ),
                       ],
                     ),
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

class _ContactItem extends StatelessWidget {
  final String name;
  final String relation;

  const _ContactItem({required this.name, required this.relation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                Text(relation, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFA7F3D0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.phone, color: Color(0xFF059669)),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.edit, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
