enum Diagnosis {
  hivPositive,
  tb,
  malaria,
  asthma,
  covid19,
  diabetesType2,
  none;

  static Diagnosis fromString(String value) {
    switch (value.toLowerCase()) {
      case 'malaria':
        return Diagnosis.malaria;
      case 'asthma':
        return Diagnosis.asthma;
      case 'covid19':
        return Diagnosis.covid19;
      case 'diabetesType2':
        return Diagnosis.diabetesType2;
      case 'none':
        return Diagnosis.none;
      default:
        throw "the string: $value, doesn't correspond to any diagnosis constant value";
    }
  }
}
