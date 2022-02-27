import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    Key key,
    this.validator,
    @required this.label,
    this.inputAction = TextInputAction.next,
    this.inputType = TextInputType.text,
    this.obscure = false,
    this.readOnly = false,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.controller,
    this.padding,
    this.maxLines=1,
  }) : super(key: key);

  final Function validator;
  final String label;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final bool obscure;
  final bool readOnly;
  final Function onSaved;
  final Function onChanged;
  final Function onTap;
  final dynamic initialValue;
  final dynamic padding;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onTap: onTap,
      obscureText: obscure,
      readOnly: readOnly,
      maxLines: maxLines,
      textInputAction: TextInputAction.next,
      keyboardType: inputType ?? TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Color(0xff718096), fontSize: 18),
      ),
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
