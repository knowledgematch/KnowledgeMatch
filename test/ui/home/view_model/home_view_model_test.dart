import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/home/view_model/home_view_model.dart';

class ListenerTracker {
  int callCount = 0;
  void listener() {
    callCount++;
  }
}

class TestHomeViewModel extends HomeViewModel {
  bool loadDataCalled = false;
  bool refreshCalled = false;

  @override
  Future<void> loadData() async {
    loadDataCalled = true;
    notifyListeners();
  }

  @override
  void refresh() {
    refreshCalled = true;
    notifyListeners();
  }

  void simulateNotify() {
    notifyListeners();
  }
}

void main() {
  group('HomeViewModel', () {
    late TestHomeViewModel viewModel;
    late ListenerTracker tracker;

    setUp(() {
      User.instance.id = 1;
      viewModel = TestHomeViewModel();
      tracker = ListenerTracker();
      viewModel.addListener(tracker.listener);
    });

    tearDown(() {
      viewModel.removeListener(tracker.listener);
    });

    test('calls loadData on creation', () {
      expect(viewModel.loadDataCalled, true);
    });

    test('refresh calls notifyListeners and sets refreshCalled', () {
      viewModel.refresh();
      expect(viewModel.refreshCalled, true);
      expect(tracker.callCount, greaterThan(0));
    });

    test('simulateNotify triggers listener', () {
      tracker.callCount = 0;
      viewModel.simulateNotify();
      expect(tracker.callCount, 1);
    });
  });
}
