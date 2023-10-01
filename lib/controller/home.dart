import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../DB/todohelper.dart';
import '../enum/todo_status.dart';
import '../models/todo_model.dart';
import '../service/todo_service.dart';

class HomeController extends GetxController {
  // Future<List<TodoModel>> fetchPaginatedData(int page) async {
  //   final dio = Dio();
  //   final response = await dio.get();
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => TodoModel.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load data from API');
  //   }
  // }

  // Future<void> addTodo(List<TodoModel> todo) async {
  //   try {
  //     await TodoDatabaseHelper.instance.insertPaginatedData(todo);
  //   } catch (e) {
  //     // Handle any errors if necessary
  //     debugPrint("[HATA] [HomeController] [addTodo] --> $e");
  //   }
  // }
  Future<void> addTodo(List<TodoModel> todo) async {
    try {
      final existingIds = await TodoDatabaseHelper.instance.getAllTodoIds();
      final newTodos =
          todo.where((newTodo) => !existingIds.contains(newTodo.id)).toList();

      await TodoDatabaseHelper.instance.insertPaginatedData(newTodos);
    } catch (e) {
      // Handle any errors if necessary
      debugPrint("[HATA] [HomeController] [addTodo] --> $e");
    }
  }

  final TodoService _todoService = TodoService.instance;

  // void loadMore() async {
  //   if (!hasReachedMax.value && status.value == TodoStatus.success) {
  //     try {
  //       final fetchedTodos = await _todoService.fetchTodos(todos.length);
  //       if (fetchedTodos.isEmpty) {
  //         hasReachedMax(true);
  //       } else {
  //         todos.addAll(fetchedTodos);
  //
  //         addTodo(todos);
  //
  //       }
  //     } catch (e) {
  //       // Handle any errors if necessary
  //       debugPrint("[HATA] [HomeController] [loadMore] --> $e");
  //     }
  //   }
  // }
  var todos = <TodoModel>[].obs;
  var hasReachedMax = false.obs;
  var status = TodoStatus.initial.obs;

  @override
  void onInit() {
    super.onInit();
    onTodoFetch();
  }

  Future<void> onTodoFetch() async {
    try {
      if (hasReachedMax.value) return;
      if (status.value == TodoStatus.initial) {
        final fetchedTodos = await _todoService.fetchTodos();
        todos.assignAll(fetchedTodos);
        status(TodoStatus.success);
      } else {
        final fetchedTodos = await _todoService.fetchTodos(todos.length);
        if (fetchedTodos.isEmpty) {
          hasReachedMax(true);
        } else {
          todos.addAll(fetchedTodos);
          addTodo(todos);
        }
      }
    } catch (e) {
      status(TodoStatus.error);
    }
  }

  Future<void> onRefresh() async {
    status(TodoStatus.initial);
    await Future.delayed(Duration(seconds: 1));
    onTodoFetch();
  }
}
