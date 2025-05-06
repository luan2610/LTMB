import 'package:flutter/material.dart';
import '../Database Helper/TaskDataBaseHelper.dart';
import '../Models/task.dart';
import 'TaskFromScreen.dart';
import 'TaskDetailsScreen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskDatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _navigateToAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen()),
    );
    _loadTasks();
  }

  void _navigateToEditTask(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
    );
    _loadTasks();
  }

  void _deleteTask(Task task) async {
    await TaskDatabaseHelper.instance.deleteTask(task.id!);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: _tasks.isEmpty
          ? Center(child: Text('No tasks yet'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      task.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('Mô tả: ${task.description}'),
                        SizedBox(height: 2),
                        Text('Hạn chót: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (val) async {
                            task.isCompleted = val!;
                            await TaskDatabaseHelper.instance.updateTask(task);
                            _loadTasks();
                          },
                        ),
                        Text(
                          task.isCompleted ? '✔' : '✗',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(task: task),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        label: Text('Sửa'),
                        onPressed: () => _navigateToEditTask(task),
                      ),
                      SizedBox(width: 10),
                      TextButton.icon(
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text('Xóa'),
                        onPressed: () => _deleteTask(task),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
