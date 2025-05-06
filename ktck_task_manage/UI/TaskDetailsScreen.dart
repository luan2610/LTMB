// TaskDetailScreen.dart
import 'package:flutter/material.dart';
import '../Models/task.dart';
import 'TaskFromScreen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết công việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tiêu đề:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(task.title),
            SizedBox(height: 16),
            Text('Mô tả:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(task.description),
            SizedBox(height: 16),
            Text('Trạng thái:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(task.isCompleted ? 'Hoàn thành' : 'Chưa hoàn thành'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(task: task),
                  ),
                );
              },
              child: Text('Sửa công việc'),
            ),
          ],
        ),
      ),
    );
  }
}