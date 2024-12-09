import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/ui/pages/add_task_page.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/task_tile.dart';
import '../../services/theme_services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

NotifyHelper mynot = NotifyHelper();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

File? _image;
bool theDarkMode = Get.isDarkMode;
final TaskController _taskController = Get.put(TaskController());
DateTime _selectDate = DateTime.now();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _saveImage(pickedFile.path);
      Navigator.pop(context); // Close the dialog
    }
  }

  Future<void> _saveImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_image', imagePath);
  }

  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('saved_image');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            print('debuug is work');

            ThemeServices().switchTheme();
            setState(() {
              theDarkMode = !Get.isDarkMode;
            });
          },
          icon: Icon(theDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_sharp),
        ),
        centerTitle: true,
        title: Text(
          'Home page',
          style: headingStyle.copyWith(
              color: theDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              mynot.cancelAllNotifaction();
              _taskController.deletAllTasks();
            },
            icon: const Icon(Icons.delete_outline),
            color: theDarkMode ? Colors.white : Colors.black,
          ),
          pickImage(context),
        ],
      ),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTasks(),
        ],
      ),
    );
  }

  _addTaskBar() {
    String today = DateFormat.yMMMMd().format(DateTime.now()).toString();
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(today, style: titleStyle),
              Text('Today', style: titleStyle),
            ],
          ),
          const Spacer(),
          MyButton(
            label: '+ add task',
            ontap: () async {
              await Get.to(const AddTaskPage());
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Material(
      elevation: 2,
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 130,
        dateTextStyle: titleStyle.copyWith(color: Colors.grey),
        dayTextStyle: titleStyle.copyWith(color: Colors.grey),
        monthTextStyle: titleStyle.copyWith(color: Colors.grey),
        initialSelectedDate: DateTime.now(),
        selectionColor: Theme.of(context).primaryColor,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          setState(() {
            _selectDate = date;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return ListView.builder(
            scrollDirection: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            itemBuilder: (BuildContext contex, int index) {
              Task task = _taskController.taskList[index];

              var date = DateFormat.jm().parse(task.startTime!);
              var mytime = DateFormat('HH:mm').format(date);
              mynot.scheduledNotification(
                int.parse(mytime.toString().split(':')[0]),
                int.parse(mytime.toString().split(':')[1]),
                task,
              );

              if (task.repeat == 'daily' ||
                  task.date == DateFormat.yMd().format(_selectDate) ||
                  (task.repeat == 'weekly' &&
                      _selectDate
                                  .difference(
                                      DateFormat.yMd().parse(task.date!))
                                  .inDays %
                              7 ==
                          0) ||
                  (task.repeat == 'monthly' &&
                      _selectDate.day ==
                          DateFormat.yMd().parse(task.date!).day)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1200),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(
                          context,
                          task,
                        ),
                        child: TaskTile(
                          task: task,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
            itemCount: _taskController.taskList.length,
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 3000),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 200, bottom: 50),
            child: Wrap(
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.vertical
                  : Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/task.svg',
                  height: 120,
                  semanticsLabel: 'task',
                  color: primaryClr.withOpacity(0.7),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    'No tasks added yet! , we are waiting  you motherfucker to add  tasks ❤',
                    style: subtitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 20),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'task Compleated',
                    onTap: () async {
                      mynot.cancelNotifaction(task);
                      await _taskController.markTaskCompleted(task);
                      Get.back();
                    },
                    clrOfText: Colors.white,
                    clr: primaryClr,
                  ),
            _buildBottomSheet(
              label: 'delete task ',
              onTap: () async {
                mynot.cancelNotifaction(task);
                await _taskController.deleteTasks(task);
                Get.back();
              },
              clrOfText: Colors.white,
              clr: pinkClr,
            ),
            Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
            _buildBottomSheet(
              label: 'Cancel',
              onTap: () {
                Get.back();
              },
              clrOfText: darkGreyClr,
              clr: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    required Color clrOfText,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[600]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: titleStyle.copyWith(color: clrOfText),
          ),
        ),
      ),
    );
  }

  Widget pickImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'images/bosbos.jpeg',
                          fit: BoxFit.cover,
                        ),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text('Change picture bosbos'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: ClipOval(
            child: _image != null
                ? Image.file(
                    _image!,
                    width: 45.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'images/bosbos.jpeg',
                    width: 45.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
