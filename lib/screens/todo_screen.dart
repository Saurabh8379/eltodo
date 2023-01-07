import 'package:eltodo/models/todo.dart';
import 'package:eltodo/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/category_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitle = TextEditingController();

  var _todoDescription = TextEditingController();

  var _todoDate = TextEditingController();
  var _todoService = TodoService();
  var todoObj = Todo();
  var _categoryService = CategoryService();

  var _categories = <DropdownMenuItem>[];

  // var _category = <DropdownMenuItem>[];

  // final List<DropdownMenuItem> _categories =
  // <DropdownMenuItem<String>>[];

  var _selectedValue;

  @override
  void initstate() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    // var _categoryService = CategoryService();

    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          value: category['name'],
          child: Text(category['name']),
        ));
      });
    });
  }

  DateTime _date = DateTime.now();

  _selectTodoDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
        _todoDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  _showSnackBar(message) {
    var snackBar = SnackBar(
      content: message,
    );
    //_scaffoldKey.currentState!.showSnackBar(_snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _todoTitle,
            decoration: const InputDecoration(
              hintText: 'Todo title',
              labelText: 'Cook food',
            ),
          ),
          TextField(
            controller: _todoDescription,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Todo decoration',
              labelText: 'Cook rice and curry',
            ),
          ),
          TextField(
            controller: _todoDate,
            decoration: InputDecoration(
                hintText: 'YY-MM-DD',
                labelText: 'YY-MM-DD',
                prefixIcon: InkWell(
                    onTap: () {
                      _selectTodoDate(context);
                    },
                    child: const Icon(Icons.calendar_today))),
          ),
          DropdownButtonFormField(
            value: _selectedValue,
            items: _categories,
            hint: const Text('Select one category'),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          ElevatedButton(
              onPressed: () async {
                todoObj.title = _todoTitle.text;
                todoObj.description = _todoDescription.text;
                todoObj.todoDate = _todoDate.text;
                todoObj.category = _selectedValue.toString();
                todoObj.isFinished = 0;
                // var _todoService = TodoService();
                var result = _todoService.insertTodo(todoObj);
                if (result > 0) {
                  _showSnackBar(const Text(
                    'Category information saved successfully',
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ));
                  _loadCategories();
                } else {
                  _showSnackBar(const Text(
                    'Category information could not save',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ));
                }
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}
