import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/reminder.dart';
import '../services/reminder_service.dart';
import 'create_reminder_screen.dart';

class Reminders extends StatefulWidget {
  final VoidCallback onBack;

  const Reminders({super.key, required this.onBack});

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  List<Reminder> _reminders = [];
  List<Reminder> _filteredReminders = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReminders();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredReminders = List.from(_reminders);
      } else {
        _filteredReminders = _reminders.where((r) {
          return r.title.toLowerCase().contains(query) || 
                 r.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);
    final reminders = await ReminderService.loadReminders();
      reminders.sort((a, b) {
      final aDateTime = DateTime(a.date.year, a.date.month, a.date.day, a.time.hour, a.time.minute);
      final bDateTime = DateTime(b.date.year, b.date.month, b.date.day, b.time.hour, b.time.minute);
      return aDateTime.compareTo(bDateTime);
    });
    setState(() {
      _reminders = reminders;
      _filteredReminders = List.from(_reminders);
      if (_searchController.text.isNotEmpty) {
        _onSearchChanged();
      }
      _isLoading = false;
    });
  }

  Future<void> _addReminder() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReminderScreen(
          onSave: (newReminder) async {
            await ReminderService.addReminder(newReminder);
            _loadReminders();
          },
        ),
      ),
    );
  }

  Future<void> _editReminder(Reminder reminder) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReminderScreen(
          existingReminder: reminder,
          onSave: (updatedReminder) async {
            await ReminderService.updateReminder(updatedReminder);
            _loadReminders();
          },
        ),
      ),
    );
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text('Are you sure you want to delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ReminderService.deleteReminder(reminder.id);
      _loadReminders();
    }
  }

  Future<void> _toggleCompletion(Reminder reminder) async {
    final updated = Reminder(
      id: reminder.id,
      title: reminder.title,
      description: reminder.description,
      type: reminder.type,
      date: reminder.date,
      time: reminder.time,
      repeatType: reminder.repeatType,
      colorTag: reminder.colorTag,
      createdAt: reminder.createdAt,
      isCompleted: !reminder.isCompleted,
    );
    await ReminderService.updateReminder(updated);
    _loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      const Text('Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search reminders...',
                      prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _filteredReminders.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredReminders.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final reminder = _filteredReminders[index];
                          return _ReminderCard(
                            reminder: reminder,
                            onEdit: () => _editReminder(reminder),
                            onDelete: () => _deleteReminder(reminder),
                            onToggleComplete: () => _toggleCompletion(reminder),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No reminders yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add a new reminder.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  const _ReminderCard({
    required this.reminder,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color? badgeColor;
    Color? badgeTextColor;
    IconData icon;

    switch (reminder.colorTag) {
      case 'appointment':
        bgColor = const Color(0xFFF3E8FF);
        borderColor = AppTheme.border;
        badgeColor = const Color(0xFFDDD6FE);
        badgeTextColor = AppTheme.primary;
        icon = Icons.calendar_today;
        break;
      case 'medication':
        bgColor = const Color(0xFFD1FAE5);
        borderColor = const Color(0xFFA7F3D0);
        badgeColor = const Color(0xFF6EE7B7);
        badgeTextColor = const Color(0xFF065F46);
        icon = Icons.local_hospital;
        break;
      case 'custom':
      default:
        bgColor = const Color(0xFFFCE7F3);
        borderColor = const Color(0xFFFBCFE8);
        badgeColor = const Color(0xFFF9A8D4);
        badgeTextColor = const Color(0xFF9D174D);
        icon = Icons.event;
        break;
    }

    if (reminder.isCompleted) {
      bgColor = Colors.white;
      borderColor = const Color(0xFFE5E7EB);
      badgeColor = const Color(0xFFE5E7EB);
      badgeTextColor = AppTheme.textSecondary;
    }

    String badgeText = '';
    if (reminder.isCompleted) {
      badgeText = 'Completed';
    } else if (reminder.repeatType != RepeatType.none) {
      badgeText = reminder.repeatType == RepeatType.daily ? 'Daily' : 'Weekly';
    } else {
      final today = DateTime.now();
      if (reminder.date.year == today.year && reminder.date.month == today.month && reminder.date.day == today.day) {
        badgeText = 'Today';
      } else {
        badgeText = DateFormat('MMM d').format(reminder.date);
      }
    }

    final formattedTime = reminder.time.format(context);
    final formattedDate = DateFormat('dd MMM yyyy').format(reminder.date);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Opacity(
        opacity: reminder.isCompleted ? 0.6 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onToggleComplete,
              child: Container(
                margin: const EdgeInsets.only(top: 4, right: 12),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: reminder.isCompleted ? AppTheme.primary : null,
                  border: Border.all(color: AppTheme.primary, width: 2),
                  shape: BoxShape.circle,
                ),
                child: reminder.isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: reminder.isCompleted ? AppTheme.textSecondary : AppTheme.textMain,
                                decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (badgeText.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(badgeText, style: TextStyle(color: badgeTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  
                  if (reminder.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(reminder.description, style: const TextStyle(color: AppTheme.textSecondary)),
                  ],
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(icon, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$formattedDate  •  $formattedTime', 
                          style: const TextStyle(color: AppTheme.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
            
          PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
