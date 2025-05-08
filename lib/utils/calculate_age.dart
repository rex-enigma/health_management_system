int calculateAge(DateTime dateOfBirth) {
  final now = DateTime.now();
  int age = now.year - dateOfBirth.year;
  if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
    age--;
  }
  return age;
}
