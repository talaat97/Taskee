import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload})
      : super(key: key);

  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
        title: const Text('Notifaction Screen '),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Hallow Talaat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'HlLow Talaat',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                  fontSize: 20),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.text_fields_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Title',
                        style: TextStyle(fontSize: 35),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(_paylod.split('|')[0]),
                  const Row(
                    children: [
                      Icon(Icons.description_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Desc',
                        style: TextStyle(fontSize: 35),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(_paylod.split('|')[1]),
                  const Row(
                    children: [
                      Icon(Icons.calendar_month_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Date',
                        style: TextStyle(fontSize: 35),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(_paylod.split('|')[2]),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
