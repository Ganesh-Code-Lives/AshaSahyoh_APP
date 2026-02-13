import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SchemesFinder extends StatelessWidget {
  final VoidCallback onBack;

  const SchemesFinder({super.key, required this.onBack});

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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back, color: AppTheme.textMain)),
                      const Text('Scheme Finder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.mic, color: AppTheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search disability schemes...',
                      prefixIcon: null,
                      suffixIcon: Icon(Icons.mic, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Filter Chips
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(label: 'All', isSelected: true),
                        SizedBox(width: 8),
                        _FilterChip(label: 'Disability Type'),
                        SizedBox(width: 8),
                        _FilterChip(label: 'Age'),
                        SizedBox(width: 8),
                        _FilterChip(label: 'Education'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Schemes List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _SchemeCard(
                    title: 'Disability Pension Scheme',
                    department: 'Dept of Social Justice & Empowerment',
                    description: 'Provides monthly financial assistance to persons with benchmark disabilities.',
                    readAloudColor: Color(0xFFBE185D),
                    readAloudBg: Color(0xFFFBCFE8),
                  ),
                  SizedBox(height: 16),
                  _SchemeCard(
                    title: 'Aids & Assistive Devices Grant',
                    department: 'Ministry of Health and Family Welfare',
                    description: 'Financial aid for purchasing durable, sophisticated and scientifically manufactured modern aids.',
                    readAloudColor: Color(0xFF0284C7),
                    readAloudBg: Color(0xFFBAE6FD),
                  ),
                  SizedBox(height: 16),
                  _SchemeCard(
                    title: 'Concessional Travel Pass',
                    department: 'Ministry of Railways',
                    description: 'Offers concessions on train fares for persons with disabilities across various classes of travel.',
                    readAloudColor: Color(0xFF065F46),
                    readAloudBg: Color(0xFFA7F3D0),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textMain,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final String title;
  final String department;
  final String description;
  final Color readAloudColor;
  final Color readAloudBg;

  const _SchemeCard({
    required this.title,
    required this.department,
    required this.description,
    required this.readAloudColor,
    required this.readAloudBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16))),
              const Icon(Icons.bookmark_border, color: AppTheme.textSecondary),
            ],
          ),
          const SizedBox(height: 4),
          Text(department, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(color: AppTheme.textMain)),
          const SizedBox(height: 16),
          
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: readAloudBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.volume_up, size: 16, color: readAloudColor),
                  const SizedBox(width: 8),
                  Text('Read Aloud', style: TextStyle(color: readAloudColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
