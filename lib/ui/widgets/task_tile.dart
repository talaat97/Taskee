import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';
import '../size_config.dart';
import 'package:to_do_app/ui/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title!,
                        style: titleStyle.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[100])),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey[200],
                          size: 30,
                        ),
                        Text(
                          '${task.startTime}-${task.endTime}',
                          style: titleStyle.copyWith(
                              fontSize: 13, color: Colors.grey[100]),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 0,
                    ),
                    Text(
                        task.note == '.'
                            ? ' remeber to do this task Soma'
                            : task.note!,
                        style: titleStyle.copyWith(
                            fontSize: 25, color: Colors.grey[100]))
                  ],
                ),
              ),
            ),
            Container(
              height: 150,
              width: 2,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'TODO' : 'Completed',
                style: titleStyle.copyWith(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
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
