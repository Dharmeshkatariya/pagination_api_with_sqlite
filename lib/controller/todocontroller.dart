// import 'package:get/get.dart';
// import 'package:flutter/foundation.dart' show debugPrint;
//
// import '../enum/todo_status.dart';
// import '../models/todo_model.dart';
// import '../service/todo_service.dart';
//
//
// class TodoController extends GetxController {
//   final TodoService _todoService = TodoService.instance;
//
//   final _todos = <TodoModel>[].obs;
//   List<TodoModel> get todos => _todos;
//
//   final _hasReachedMax = false.obs;
//   bool get hasReachedMax => _hasReachedMax.value;
//
//   final _status = TodoStatus.initial.obs;
//   TodoStatus get status => _status.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initial Event
//     _onTodoFetch();
//   }
//
//   Future<void> _onTodoFetch() async {
//     try {
//       if (hasReachedMax) return;
//       if (status == TodoStatus.initial) {
//         final todos = await _todoService.fetchTodos();
//         _todos.assignAll(todos);
//         _status(TodoStatus.success);
//       } else {
//         final todos = await _todoService.fetchTodos(_todos.length);
//         if (todos.isEmpty) {
//           _hasReachedMax(true);
//         } else {
//           _todos.addAll(todos);
//         }
//       }
//     } catch (e) {
//       debugPrint("[HATA] [TodoController] [_onTodoFetch] --> $e");
//       _status(TodoStatus.error);
//     }
//   }
//
//   Future<void> onRefresh() async {
//     _status(TodoStatus.initial);
//     await Future.delayed(const Duration(seconds: 1));
//     _onTodoFetch();
//   }
// }
