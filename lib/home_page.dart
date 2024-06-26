import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'utils/todoTile.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _selectedDueDate;

  void createNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.yellow[300],
          content: Container(
            height: 260,
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Add New Task",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  items: ['High', 'Medium', 'Low'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Priority',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(_selectedDueDate == null
                        ? 'No due date set'
                        : DateFormat.yMMMd().format(_selectedDueDate!)),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
                ButtonBar(
                  overflowDirection: VerticalDirection.down,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          Provider.of<TodoProvider>(context, listen: false)
                              .addTask(
                              _controller.text,
                              _selectedPriority,
                              _selectedDueDate ?? DateTime.now());
                          _controller.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow,
        title: Text(
          'To-Do List',
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewTask(context),
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          // Filtered list of tasks based on search input
          final filteredTodos = todoProvider.todos.where((todo) =>
              todo.name.toLowerCase().contains(_controller.text.toLowerCase()));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Search by title',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild on text change
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = filteredTodos.elementAt(index);
                    return Dismissible(
                      key: Key(todo.id.toString()),
                      onDismissed: (direction) {
                        todoProvider.removeTask(index);
                      },
                      background: Container(color: Colors.red),
                      child: ToDoTile(
                        taskCompleted: todo.isCompleted,
                        taskName: todo.name,
                        taskPriority: todo.priority,
                        dueDate: todo.dueDate,
                        onChanged: (value) {
                          todoProvider.toggleTask(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
