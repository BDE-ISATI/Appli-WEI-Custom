import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This is a wrapper for a TextFormField. It add
/// some nice graphics effects
class FormTextInput extends StatelessWidget {
  const FormTextInput({
    Key key, 
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.labelText,
    this.hintText,
    @required this.controller,
    @required this.validator,
  }) : super(key: key);

  final String labelText;
  final String hintText;

  final bool obscureText;
  final TextEditingController controller;
  final String Function(String) validator;

  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: obscureText,
        controller: controller,
        keyboardType: inputType,
        inputFormatters: <TextInputFormatter>[
          if (inputType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly
        ],
        maxLines: inputType == TextInputType.multiline ? 4 : 1,
        decoration: InputDecoration(
              border:  const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black87,
                  width: 3
                )
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black87,
                  width: 3
                )
              ),
              focusedBorder: const UnderlineInputBorder(
                // borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 3
                )
              ),
              labelText: labelText, 
              hintText: hintText, 
            ),
        validator: validator,
    );
  }
}