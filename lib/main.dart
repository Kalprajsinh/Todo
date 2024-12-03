import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToDoListScreen(),
    );
  }
}

class Task {
  final String title;
  final String desc;
  final String priority;

  Task(this.title, this.desc, this.priority);
}

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {

  final List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.desc} \n Priority: ${task.priority}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Popup(task: task, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Popup(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void Popup({Task? task, int? index}) {
    final title = TextEditingController(text: task?.title ?? '');
    final descriptionController =
    TextEditingController(text: task?.desc ?? '');
    String priority = task?.priority ?? 'Low';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(task == null ? 'Add Task' : 'Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  DropdownButton<String>(
                    value: priority,
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => priority = value);
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'Low',
                          child: Text('Low')
                      ),
                      DropdownMenuItem(value: 'Medium',
                          child: Text('Medium')
                      ),
                      DropdownMenuItem(value: 'High',
                          child: Text('High')
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (title.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      setState(() {
                        if (task == null) {
                          tasks.add(Task(
                              title.text,
                              descriptionController.text,
                              priority));
                        } else if (index != null) {
                          tasks[index] = Task(
                              title.text,
                              descriptionController.text,
                              priority);
                        }
                        tasks.sort((a, b) {
                          const priorityMap = {'High': 1, 'Medium': 2, 'Low': 3};
                          return priorityMap[a.priority]!
                              .compareTo(priorityMap[b.priority]!);
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
