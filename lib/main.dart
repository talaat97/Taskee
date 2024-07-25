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
      home: const HomePage(),
    );
  }
}
/* class TestNotifaction extends StatelessWidget {
  const TestNotifaction({super.key});
-
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: () {
                NotifyHelper.showBasicNotification();
              },
              leading: const Icon(Icons.notifications),
              title: const Text('simple notifaction'),
              trailing: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: () {
                  NotifyHelper.cancelNotifaction(0);
                },
              ),
            ),
            ListTile(
              onTap: () {
                NotifyHelper.showPeriodicallyNotification();
              },
              leading: const Icon(Icons.notifications_active),
              title: const Text('periodica notifaction'),
              trailing: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: () {
                  NotifyHelper.cancelNotifaction(1);
                },
              ),
            ),
            ListTile(
              onTap: () {
                NotifyHelper.showScudleNotification();
              },
              leading: const Icon(Icons.notification_add_sharp),
              title: const Text('showScudle Notification '),
              trailing: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: () {
                  NotifyHelper.cancelNotifaction(2);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
