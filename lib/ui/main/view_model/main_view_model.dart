import 'package:flutter/foundation.dart';
import 'package:knowledgematch/ui/main/main_state.dart';

class MainScreenViewModel extends ChangeNotifier{
  MainState _state;

  MainState get state => _state;

  MainScreenViewModel()
    : _state = MainState(
      currentIndex: 1
    );

  void updateIndex(int index) {
    _state = state.copyWith(currentIndex: index);
    notifyListeners();
  }
}