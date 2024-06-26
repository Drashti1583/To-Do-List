import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    _loadTasks();
  }

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List tasksList = jsonDecode(tasksString);
      _todos = tasksList.map((task) => Todo.fromJson(task)).toList();
      notifyListeners();
    }
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = jsonEncode(_todos.map((task) => task.toJson()).toList());
    prefs.setString('tasks', tasksString);
  }

  void _scheduleNotification(Todo todo) async {
    var androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Channel for task notifications',
      importance: Importance.high,
    );

    var generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      todo.id,
      'Task Due',
      '${todo.name} is due today!',
      tz.TZDateTime.from(todo.dueDate, tz.local),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void addTask(String taskName, String priority, DateTime dueDate) {
    final newTodo = Todo(
      name: taskName,
      priority: priority,
      dueDate: dueDate, description: '',
    );
    _todos.add(newTodo);
    _saveTasks();
    _scheduleNotification(newTodo);
    notifyListeners();
  }

  void toggleTask(int index) {
    _todos[index].toggleCompleted();
    _saveTasks();
    notifyListeners();
  }

  void removeTask(int index) {
    flutterLocalNotificationsPlugin.cancel(_todos[index].id);
    _todos.removeAt(index);
    _saveTasks();
    notifyListeners();
  }
}
