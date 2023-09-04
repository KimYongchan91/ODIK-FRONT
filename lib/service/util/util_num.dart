double getDoubleFromDynamic(dynamic value) {
  if (value == null) {
    return 0.0;
  }

  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    return 0.0;
  }
}
