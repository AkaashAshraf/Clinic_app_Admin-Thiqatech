import 'dart:developer';

import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String hint;
  final String value;
  final Function(String? value) onChange;
  CustomDropdown(
      {Key? key, required this.items, required this.hint,  required this.value, required this.onChange})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(.3),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down_outlined,
                color: Colors.black.withOpacity(.3)),
            iconSize: 24,
            hint: Text(
              hint,
              // style: AppTextStyles.textFieldHintStyle,
            ),
            // style: AppTextStyles.textFieldHintStyle
            //     .copyWith(color: AppColors.blackshade),
            value: value,
            onChanged: onChange,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // dropdownDecoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   border: Border.all(
            //     color: Colors.black.withOpacity(.3),
            //     width: 2,
            //   ),
            //   color: Colors.white,
            // ),
            // dropdownElevation: 0,
            // offset: const Offset(0, -5),
          ),
        ),
      
    );
  }
}

