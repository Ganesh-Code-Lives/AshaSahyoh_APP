import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

class ReminderService {
  static const String _remindersKey = 'saved_reminders';

  // Load all reminders
  static Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersJson = prefs.getString(_remindersKey);
    
    if (remindersJson == null) return [];

    try {
      final List<dynamic> decoded = json.decode(remindersJson);
      return decoded.map((item) => Reminder.fromJson(item)).toList();
    } catch (e) {
      print('Error loading reminders: $e');
      return [];
    }
  }

  // Save all reminders
  static Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(reminders.map((r) => r.toJson()).toList());
    await prefs.setString(_remindersKey, encoded);
  }

  // Add a reminder
  static Future<void> addReminder(Reminder reminder) async {
    final reminders = await loadReminders();
    reminders.add(reminder);
    await saveReminders(reminders);
  }

  // Update a reminder
  static Future<void> updateReminder(Reminder updatedReminder) async {
    final reminders = await loadReminders();
    final index = reminders.indexWhere((r) => r.id == updatedReminder.id);
    if (index != -1) {
      reminders[index] = updatedReminder;
      await saveReminders(reminders);
    }
  }

  // Delete a reminder
  static Future<void> deleteReminder(String id) async {
    final reminders = await loadReminders();
    reminders.removeWhere((r) => r.id == id);
    await saveReminders(reminders);
  }
}
