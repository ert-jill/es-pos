import 'package:flutter/material.dart';

class FieldDefinition {
  final String fieldName;
  final String labelText;
  final Widget fieldWidget;

  FieldDefinition({
    required this.fieldName,
    required this.labelText,
    required this.fieldWidget,
  });
}
