import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DocumentVault extends StatelessWidget {
  final VoidCallback onBack;

  const DocumentVault({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
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
                      const Text('Document Vault', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.grid_view, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search your documents...',
                      prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                      suffixIcon: Icon(Icons.mic, color: AppTheme.textSecondary),
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
                        _FilterChip(label: 'Certificates'),
                        SizedBox(width: 8),
                        _FilterChip(label: 'ID Proofs'),
                        SizedBox(width: 8),
                        _FilterChip(label: 'Medical'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Documents List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _DocumentCard(
                    title: 'Disability Certificate',
                    date: 'Uploaded: 10 Jul 2023',
                    icon: Icons.description,
                    iconColor: Color(0xFFBE185D),
                    bgColor: Color(0xFFFBCFE8),
                  ),
                  SizedBox(height: 12),
                  _DocumentCard(
                    title: 'Aadhaar Card',
                    date: 'Uploaded: 15 Aug 2023',
                    icon: Icons.credit_card,
                    iconColor: Color(0xFF0284C7),
                    bgColor: Color(0xFFBAE6FD),
                  ),
                  SizedBox(height: 12),
                  _DocumentCard(
                    title: 'Medical Prescription',
                    date: 'Uploaded: 05 Sep 2023',
                    icon: Icons.assignment, // ClipboardList
                    iconColor: Color(0xFF065F46),
                    bgColor: Color(0xFFA7F3D0),
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

class _DocumentCard extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _DocumentCard({required this.title, required this.date, required this.icon, required this.iconColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppTheme.textMain)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}
