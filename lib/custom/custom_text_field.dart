import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends TextField {
  CustomTextField({
    Key? key,
    void Function(String)? onChanged,
    String? hintText,
    TextEditingController? controller,
    bool? enabled,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    bool autocorrect = true,
    List<TextInputFormatter>? inputFormatters,
  }) : super(
          key: key,
          maxLines: 1,
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          readOnly: readOnly,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              enabledBorder: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              hintText: hintText),
          onChanged: onChanged,
          keyboardType: keyboardType,
          autocorrect: autocorrect,
          inputFormatters: inputFormatters,
        );
}
