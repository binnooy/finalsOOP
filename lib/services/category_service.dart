import 'package:hive_flutter/hive_flutter.dart';

class CategoryService {
  static const String boxName = 'categories';

  // Singleton
  static final CategoryService _instance = CategoryService._internal();

  CategoryService._internal();

  factory CategoryService() {
    return _instance;
  }

  // Get the Hive box (smust call initBox first)
  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<String>(boxName);
    }
    return Hive.box<String>(boxName);
  }

  // Initialize the box (call once in main.dart)
  Future<void> initBox() async {
    final box = await _getBox();
    if (box.isEmpty) {
      await _addDefaultCategories(box);
    }
  }

  // Add default categories
  Future<void> _addDefaultCategories(Box<String> box) async {
    final defaults = [
      'Food',
      'Transport',
      'Entertainment',
      'Bills',
      'Health',
      'Shopping',
      'Salary',
      'Freelance',
      'Other',
    ];
    for (var category in defaults) {
      await box.add(category);
    }
  }

  // Get all categories
  Future<List<String>> getAll() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Add a new category
  Future<void> add(String category) async {
    final box = await _getBox();
    if (!box.values.contains(category)) {
      await box.add(category);
    }
  }

  // Check if category exists
  Future<bool> exists(String category) async {
    final box = await _getBox();
    return box.values.contains(category);
  }

  // Delete a category
  Future<void> delete(String category) async {
    final box = await _getBox();
    final index = box.values.toList().indexOf(category);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }
}
