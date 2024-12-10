import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;

  const NotificationScreen({Key? key, required this.payload}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  String _paylod = '';
  @override
  void initState() {
    _paylod = widget.payload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text(
          'Notifactions ✔️ ',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: _getBGClr(int.parse(_paylod.split('|')[3])),
      ),
      body: Column(
        children: [
          const Text(
            '🥰 Hey Soma  ! 🥰 \n Remember',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _getBGClr(int.parse(_paylod.split('|')[3])),
              borderRadius: BorderRadius.circular(30),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 70,
                      ),
                      Text(
                        'Title  ',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text('- ${_paylod.split('|')[0]}',
                      style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 15),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 70,
                      ),
                      Text(
                        'Desc ',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text(
                    '- ${_paylod.split('|')[1]}',
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_month_sharp,
                        size: 70,
                      ),
                      Text(
                        'Date ',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text(
                    '- ${_paylod.split('|')[2]}',
                    style: const TextStyle(fontSize: 35),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;

      case 1:
        return pinkClr;

      case 2:
        return orangeClr;

      default:
        bluishClr;
    }
  }
}
