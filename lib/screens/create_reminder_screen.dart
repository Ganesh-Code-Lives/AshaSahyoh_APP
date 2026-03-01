import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/reminder.dart';
import '../theme/app_theme.dart';

class CreateReminderScreen extends StatefulWidget {
  final Reminder? existingReminder;
  final Function(Reminder) onSave;

  const CreateReminderScreen({
    super.key,
    this.existingReminder,
    required this.onSave,
  });

  @override
  State<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  ReminderType _selectedType = ReminderType.appointment;
  RepeatType _selectedRepeat = RepeatType.none;

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      final r = widget.existingReminder!;
      _titleController.text = r.title;
      _descriptionController.text = r.description;
      _selectedDate = r.date;
      _selectedTime = r.time;
      _selectedType = r.type;
      _selectedRepeat = r.repeatType;
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveReminder() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
        return;
      }

      String colorTag = 'appointment';
      if (_selectedType == ReminderType.medication) {
        colorTag = 'medication';
      } else if (_selectedType == ReminderType.custom) {
        colorTag = 'custom';
      }

      final reminder = Reminder(
        id: widget.existingReminder?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        date: _selectedDate!,
        time: _selectedTime!,
        repeatType: _selectedRepeat,
        colorTag: colorTag,
        createdAt: widget.existingReminder?.createdAt ?? DateTime.now(),
        isCompleted: widget.existingReminder?.isCompleted ?? false,
      );

      widget.onSave(reminder);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.existingReminder == null ? 'New Reminder' : 'Edit Reminder'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textMain,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
              ),
              validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<ReminderType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
              ),
              items: const [
                DropdownMenuItem(value: ReminderType.appointment, child: Text('Appointment')),
                DropdownMenuItem(value: ReminderType.medication, child: Text('Medication')),
                DropdownMenuItem(value: ReminderType.custom, child: Text('Custom')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
                      ),
                      child: Text(
                        _selectedDate == null ? 'Select Date' : DateFormat('dd MMM yyyy').format(_selectedDate!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
                      ),
                      child: Text(
                        _selectedTime == null ? 'Select Time' : _selectedTime!.format(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<RepeatType>(
              value: _selectedRepeat,
              decoration: InputDecoration(
                labelText: 'Repeat',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
              ),
              items: const [
                DropdownMenuItem(value: RepeatType.none, child: Text('None')),
                DropdownMenuItem(value: RepeatType.daily, child: Text('Daily')),
                DropdownMenuItem(value: RepeatType.weekly, child: Text('Weekly')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedRepeat = val);
              },
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _saveReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Reminder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
