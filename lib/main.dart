import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_api_pagination_demo/DB/todohelper.dart';
import 'package:getx_api_pagination_demo/view/homescreen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized() ;
  await  TodoDatabaseHelper.instance.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple
      ),
      home:  HomeView(),
    );
  }
}
