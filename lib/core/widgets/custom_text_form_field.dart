import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.title,
    this.maxLines,
    this.validator,
    required this.hintText,
  });

  final TextEditingController controller;
  final String title;
  final int? maxLines;
  final Function(String?)? validator;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 16
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.labelMedium,
          maxLines: maxLines,
          validator: validator != null ? (String? value) => validator!(value) : null,
          decoration: InputDecoration(
            hintText: hintText,

          ),
        ),
      ],
    );
  }
}
