enum Diagnosis {
  hivPositive;

  static Diagnosis fromString(String value) {
    switch (value) {
      case 'hivPositive':
        return Diagnosis.hivPositive;
      default:
        throw "the string: $value, doesn't correspond to any diagnosis constant value";
    }
  }
}
