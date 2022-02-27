import 'package:flutter/material.dart';

class SelectWidget extends StatelessWidget {
  final String label;
  final dynamic value;
  final List<dynamic> items;
  final void Function(dynamic) onChanged;
  final bool required;

  const SelectWidget({
    Key key,
    this.value,
    this.items,
    this.onChanged,
    this.label,
    this.required = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xff718096), fontSize: 18),
      ),
      validator: (value) {
        if (!required) return null;
        if (value == null) return "This field can't be empty";
        return null;
      },
      onSaved: (value) {
        print("Saved");
      },
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                child: Text(
                  "$e",
                  style: const TextStyle(fontSize: 14),
                ),
                value: e,
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
