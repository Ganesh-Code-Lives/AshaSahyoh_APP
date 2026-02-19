import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../theme/app_theme.dart';

class SchemesFinder extends StatefulWidget {
  final VoidCallback onBack;

  const SchemesFinder({super.key, required this.onBack});

  @override
  State<SchemesFinder> createState() => _SchemesFinderState();
}

class _SchemesFinderState extends State<SchemesFinder> {
  List<dynamic> _schemes = [];
  List<dynamic> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  Future<void> _loadSchemes() async {
    try {
      final jsonString = await rootBundle.loadString('assets/schemes.json');
      final data = jsonDecode(jsonString);
      final list = (data['schemes'] as List<dynamic>?) ?? [];
      setState(() {
        _schemes = list;
        _filtered = List.from(_schemes);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _onSearch(String q) {
    final term = q.trim().toLowerCase();
    if (term.isEmpty) {
      setState(() => _filtered = List.from(_schemes));
      return;
    }
    setState(() {
      _filtered = _schemes.where((s) {
        final name = (s['scheme_name'] ?? '').toString().toLowerCase();
        final summary = (s['summary'] ?? '').toString().toLowerCase();
        final category = (s['category'] ?? '').toString().toLowerCase();
        return name.contains(term) || summary.contains(term) || category.contains(term);
      }).toList();
    });
  }

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
                      IconButton(onPressed: widget.onBack, icon: const Icon(Icons.arrow_back, color: AppTheme.textMain)),
                      const Text('Scheme Finder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.mic, color: AppTheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    onChanged: _onSearch,
                    decoration: const InputDecoration(
                      hintText: 'Search disability schemes...',
                      prefixIcon: null,
                      suffixIcon: Icon(Icons.mic, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips (static for now)
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? const Center(child: Text('No schemes found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (context, index) {
                            final item = _filtered[index];
                            final title = item['scheme_name'] ?? '';
                            final department = item['category'] ?? '';
                            final description = item['summary'] ?? '';
                            // pick color set by index
                            final colors = [
                              [Color(0xFFBE185D), Color(0xFFFBCFE8)],
                              [Color(0xFF0284C7), Color(0xFFBAE6FD)],
                              [Color(0xFF065F46), Color(0xFFA7F3D0)],
                              [Color(0xFF92400E), Color(0xFFFDE68A)],
                            ];
                            final pick = colors[index % colors.length];
                            return Column(
                              children: [
                                _SchemeCard(
                                  title: title,
                                  department: department,
                                  description: description,
                                  readAloudColor: pick[0],
                                  readAloudBg: pick[1],
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
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
