import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enum/todo_status.dart';
import '../controller/home.dart';
import 'home_error_view.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Add the listener to the scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

        controller.onTodoFetch() ;
        // controller.loadMore(); // Load more data when scrolling reaches the bottom
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: Obx(
            () {
          if (controller.status.value == TodoStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.status.value == TodoStatus.success) {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.onRefresh();
              },
              child: ListView.builder(
                controller: _scrollController, // Attach the scroll controller
                itemCount: controller.hasReachedMax.value
                    ? controller.todos.length
                    : controller.todos.length + 1,
                itemBuilder: (context, index) {
                  if (index >= controller.todos.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return buildTodo(context, controller, index);
                  }
                },
              ),
            );
          } else {
            return HomeErrorView();
          }
        },
      ),
    );
  }

  ListTile buildTodo(
      BuildContext context, HomeController controller, int index) {
    final todo = controller.todos[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Text(
          '${todo.id}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: todo.completed
          ? Icon(Icons.check, color: Colors.green)
          : Icon(Icons.close, color: Colors.red),
    );
  }
}
// class HomeView extends StatelessWidget {
//   final HomeController controller = Get.put(HomeController());
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   Widget build(BuildContext context) {
//     // Add the listener to the scroll controller
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         // Fetch new data from the API when scrolling reaches the bottom
//         _fetchNewDataAndInsert();
//       }
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Todos'),
//       ),
//       body: Obx(
//             () {
//           if (controller.status.value == TodoStatus.initial) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (controller.status.value == TodoStatus.success) {
//             return RefreshIndicator(
//               onRefresh: () async {
//                 await controller.onRefresh();
//               },
//               child: ListView.builder(
//                 controller: _scrollController, // Attach the scroll controller
//                 itemCount: controller.hasReachedMax.value
//                     ? controller.todos.length
//                     : controller.todos.length + 1,
//                 itemBuilder: (context, index) {
//                   if (index >= controller.todos.length) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else {
//                     return buildTodo(context, controller, index);
//                   }
//                 },
//               ),
//             );
//           } else {
//             return HomeErrorView();
//           }
//         },
//       ),
//     );
//   }
//
//   // Future<void> _fetchNewDataAndInsert() async {
//   //   final newData = await fetchNewData(); // Fetch new data from the API
//   //   controller.insertNewData(newData); // Insert new data into the database
//   // }
//
//   ListTile buildTodo(
//       BuildContext context, HomeController controller, int index) {
//     final todo = controller.todos[index];
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//         child: Text(
//           '${todo.id}',
//           style: TextStyle(
//             color: Theme.of(context).primaryColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       title: Text(
//         todo.title,
//         style: TextStyle(
//           color: Theme.of(context).primaryColor,
//           fontWeight: FontWeight.w300,
//         ),
//       ),
//       trailing: todo.completed
//           ? Icon(Icons.check, color: Colors.green)
//           : Icon(Icons.close, color: Colors.red),
//     );
//   }
// }
