import 'package:eltodo/screens/categories_screen.dart';
import 'package:eltodo/screens/home_screen.dart';
import 'package:eltodo/screens/todos_by_category.dart';
import 'package:eltodo/services/category_service.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  final _categoryList = <Widget>[];
  final _categoryService = CategoryService();

  @override
  void initstate() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TodosByCategory(category: category['name'])));
          },
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text("El Todo"),
            accountEmail: const Text("Category & Priority based Todo App"),
            currentAccountPicture: GestureDetector(
              child: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: Colors.red),
          ),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ListTile(
            title: const Text("Categories"),
            leading: const Icon(Icons.view_list),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CategoriesScreen()));
            },
          ),
          Divider(),
          Column(
            children: _categoryList,
          )
        ],
      ),
    );
  }
}
