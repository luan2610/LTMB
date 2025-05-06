// TaskFormScreen.dart
import 'package:flutter/material.dart';
import '../Database Helper/TaskDataBaseHelper.dart';
import '../Models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  DateTime _selectedDate = DateTime.now();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _isCompleted = widget.task!.isCompleted;
    } else {
      _title = '';
      _description = '';
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = Task(
        id: widget.task?.id,
        title: _title,
        description: _description,
        dueDate: _selectedDate,
        isCompleted: _isCompleted,
      );

      if (widget.task == null) {
        await TaskDatabaseHelper.instance.insertTask(newTask);
      } else {
        await TaskDatabaseHelper.instance.updateTask(newTask);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Thêm công việc' : 'Sửa công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) => value!.isEmpty ? 'Không được để trống' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Mô tả'),
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Hạn chót: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text('Chọn ngày'),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Hoàn thành'),
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (val) => setState(() => _isCompleted = val!),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.task == null ? 'Thêm' : 'Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}