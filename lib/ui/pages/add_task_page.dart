import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

import '../../db/db_helper.dart';
import '../theme.dart';
import 'package:intl/intl.dart';

DBHelper mydbHelper = DBHelper();
File? _image;

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DBHelper mydbHelper = DBHelper();

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titlecontoller = TextEditingController();
  final TextEditingController _notecontollre = TextEditingController();

  DateTime _selectDate = DateTime.now();
  String _statTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 20)))
      .toString();
  int _reminddate = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _repeatTime = 'none';
  List<String> repeaTlist = ['none', 'daily', 'weekly', 'monthly'];
  int _selectedColor = 0;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InputField(
                text: 'Tilte',
                hint: 'Enter title here.',
                controller: _titlecontoller),
            InputField(
              text: 'Note',
              hint: 'Enter note here.',
              controller: _notecontollre,
            ),
            InputField(
              text: 'Date',
              hint: DateFormat.yMd().format(DateTime.now()),
              widget: IconButton(
                onPressed: () {
                  _getDateFromUser();
                },
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    text: 'Start time',
                    hint: _statTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: const Icon(
                        Icons.access_time,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: InputField(
                    text: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: const Icon(
                        Icons.access_time,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            InputField(
              text: 'Remind ',
              hint: '$_reminddate  minutes early',
              widget: DropdownButton(
                  underline: Container(),
                  borderRadius: BorderRadius.circular(10),
                  items: remindList
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text('$value'),
                        ),
                      )
                      .toList(),
                  elevation: 4,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  iconSize: 32,
                  style: subtitleStyle,
                  onChanged: (selcetval) {
                    setState(() {
                      _reminddate = selcetval!;
                    });
                  }),
            ),
            InputField(
              text: 'Repeat',
              hint: _repeatTime,
              widget: DropdownButton(
                  underline: Container(),
                  borderRadius: BorderRadius.circular(10),
                  items: repeaTlist
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  elevation: 4,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  iconSize: 32,
                  style: subtitleStyle,
                  onChanged: (selcetval) {
                    setState(() {
                      _repeatTime = selcetval!;
                    });
                  }),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _colorOfTask(),
                const Spacer(),
                MyButton(
                    label: 'Create task',
                    ontap: () async {
                      _validateDate();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () async {
          Get.back();
          await _taskController.getTasks();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      centerTitle: true,
      title: Text('Add task', style: headingStyle),
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
        )
      ],
    );
  }

  _validateDate() async {
    if (_titlecontoller.text.isEmpty || _notecontollre.text.isEmpty) {
      return Get.snackbar(
        'Required',
        'field are Required bos bos ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else if (_titlecontoller.text.isNotEmpty &&
        _notecontollre.text.isNotEmpty) {
      await addTaskToDb();
      Get.back();
    } else {
      return print('######### SOME THING BAD HAPPEN #########');
    }
  }

  addTaskToDb() async {
    try {
      int value = await _taskController.addTask(Task(
        title: _titlecontoller.text,
        note: _notecontollre.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectDate),
        startTime: _statTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _reminddate,
        repeat: _repeatTime,
      ));
      await _taskController.getTasks();
      print(value);
    } catch (e) {
      print('Error : we are here the addTaskToDB have problem');
    }
  }

  _colorOfTask() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = 0;
                });
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: primaryClr,
                child:
                    _selectedColor == 0 ? const Icon(Icons.check) : Container(),
              ),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = 1;
                });
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: pinkClr,
                child:
                    _selectedColor == 1 ? const Icon(Icons.check) : Container(),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = 2;
                });
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: orangeClr,
                child:
                    _selectedColor == 2 ? const Icon(Icons.check) : Container(),
              ),
            ),
            const SizedBox(width: 5),
          ],
        )
      ],
    );
  }

  void _getDateFromUser() async {
    DateTime? userPikedDate = await showDatePicker(
        context: context,
        initialDate: _selectDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));

    if (userPikedDate != null) {
      setState(() {
        _selectDate = userPikedDate;
      });
    } else {
      print('');
    }
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? userPikedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15)),
            ),
    );

    var _formattedTime = userPikedTime!.format(context);
    if (isStartTime) {
      setState(() => _statTime = _formattedTime);
    } else if (!isStartTime) {
      setState(() => _endTime = _formattedTime);
    } else
      print('time canceld or something is wrong');
  }

  Center pickImage(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'images/bosbos.jpeg',
                              fit: BoxFit.cover,
                            ),
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
        child: CircleAvatar(
          radius: 50.0,
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
