import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/db/db_helper.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/pages/home_page.dart';
import 'package:to_do_app/ui/pages/notification_screen.dart';
import 'package:to_do_app/ui/theme.dart';

DBHelper mydbHelper = DBHelper();
NotifyHelper mynot = NotifyHelper();
final TaskController _taskController = Get.put(TaskController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _taskController.getTasks();
  await GetStorage.init();
  await mynot.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().Theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const NotificationScreen( payload: 'asdas|asdasd|asdas|1',),
    );
  }
}
