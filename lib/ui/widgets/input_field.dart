import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.text,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String text;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: titleStyle),
          Container(
             
             
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        
                        cursorColor:
                            Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                        readOnly: widget != null ? true : false,
                        style: subtitleStyle,
                        controller: controller,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: subtitleStyle,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              //color: context.theme.backgroundColor, 
                              width: 0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              //color: context.theme.backgroundColor,
                              width: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget ?? Container(),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
