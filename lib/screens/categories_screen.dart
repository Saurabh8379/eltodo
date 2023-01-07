import 'package:eltodo/models/category.dart';
import 'package:eltodo/services/category_service.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryName = TextEditingController();
  var _categoryDescription = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = [];

  var _editCategoryName = TextEditingController();

  var _editCategoryDescription = TextEditingController();

  var category = [];

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = [];
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.name = category['name'];
        model.id = category['id'];
        model.description = category['description'];
        _categoryList.add(model);
      });
    });
  }

  _showFormInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              ),
              TextButton(
                onPressed: () async {
                  _category.name = _categoryName.text;
                  _category.description = _categoryDescription.text;
                  var result = await _categoryService.saveCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    _showSnackBar(Text(
                      'Category information saved successfully',
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ));
                    getAllCategories();
                  } else {
                    _showSnackBar(Text(
                      'Category information could not save',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ));
                  }
                },
                child: const Text('save'),
              ),
            ],
            title: const Text("Category form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryName,
                    decoration: const InputDecoration(
                        labelText: 'Category name',
                        hintText: 'Write category name'),
                  ),
                  TextField(
                    controller: _categoryDescription,
                    decoration: const InputDecoration(
                        labelText: 'Category description',
                        hintText: 'Write category description'),
                  )
                ],
              ),
            ),
          );
        });
  }

  _editCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              ),
              TextButton(
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryName.text;
                  _category.description = _editCategoryDescription.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSnackBar(const Text('Success'));
                  }
                },
                child: const Text('Update'),
              ),
            ],
            title: const Text("Category edit form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryName,
                    decoration: const InputDecoration(
                        labelText: 'Category name',
                        hintText: 'Write category name'),
                  ),
                  TextField(
                    controller: _editCategoryDescription,
                    decoration: const InputDecoration(
                        labelText: 'Category description',
                        hintText: 'Write category description'),
                  )
                ],
              ),
            ),
          );
        });
  }

  _deleteCategoryDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  var result =
                      await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    Navigator.pop(context);
                    _showSnackBar(Text(
                      'Category information deleted successfully',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ));
                    getAllCategories();
                  } else {
                    _showSnackBar(Text(
                      'Category information could not delete',
                      style: TextStyle(color: Colors.yellow, fontSize: 15),
                    ));
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
            title: const Text("Are you sure, you want to delete?"),
          );
        });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getCategoryById(categoryId);
    setState(() {
      _editCategoryName.text = category[0]['name'] ?? 'No name';
      _editCategoryDescription.text =
          category[0]['description'] ?? 'No description';
    });

    _editCategoryDialog(context);
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
      // key: _scaffoldKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text("El Todo"),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
              leading: IconButton(
                  onPressed: () {
                    _editCategory(context, _categoryList[index].id);
                  },
                  icon: const Icon(Icons.edit)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_categoryList[index].name.toString()),
                  IconButton(
                      onPressed: () {
                        _deleteCategoryDialog(context, _categoryList[index].id);
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormInDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
