String enumToString(value) => value.toString().split(".").last;

T convertStringToEnum<T>(List<T> values, String value) {
  for (T val in values) {
    if (enumToString(val) == value) {
      return val;
    }
  }
  throw Exception("unable to covert value to enum");
}
