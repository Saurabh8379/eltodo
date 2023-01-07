import 'package:eltodo/services/todo_service.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';

class TodosByCategory extends StatefulWidget {
  final String category;

  const TodosByCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<TodosByCategory> createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  final List<Todo> _todoList = [];
  final TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getTodosByCategory();
  }

  getTodosByCategory() async {
    var todos = _todoService.todosByCategory(widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos by category'),
      ),
      body: Column(
        children: [
          Text(widget.category),
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return Text(_todoList[index].title ?? 'title');
                  }))
        ],
      ),
    );
  }
}
