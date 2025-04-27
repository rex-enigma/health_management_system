import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void initialize() {
    _currentIndex = 0;
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
