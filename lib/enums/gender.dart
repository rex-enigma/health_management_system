enum Gender {
  male,
  female,
  other;

  static Gender fromString(String value) {
    switch (value) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'other':
        return Gender.other;
      default:
        throw "the string: $value, doesn't correspond to any gender constant value";
    }
  }
}
