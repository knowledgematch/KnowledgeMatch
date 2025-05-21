import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/search_criteria.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/swipe/view_model/swipe_view_model.dart';
import 'package:swipable_stack/swipable_stack.dart';

class TestSwipeViewModel extends SwipeViewModel {
  TestSwipeViewModel({required super.searchCriteria});

  @override
  Future<void> sendSwipeRightNotification() async {
    profiles.removeAt(controller.currentIndex);
  }
}

void main() {
  setUp(() {
    User.instance.name = 'TestUser';
    User.instance.id = 123;
  });

  test('updateTitle sets correct title based on profiles count', () {
    final viewModel = SwipeViewModel(
      searchCriteria: SearchCriteria(
        keyword: 'Math',
        issue: 'Calculus',
        reachability: Reachability.online,
      ),
    );

    viewModel.profiles = [
      Userprofile(
          id: 1,
          name: 'Alice',
          tokens: ['token'],
          location: '',
          expertString: '',
          availability: '',
          langString: '',
          description: '',
          seniority: 0,
          email: ''),
      Userprofile(
          id: 1,
          name: 'Bob',
          tokens: ['token'],
          location: '',
          expertString: '',
          availability: '',
          langString: '',
          description: '',
          seniority: 0,
          email: ''),
    ];

    viewModel.updateTitle();

    expect(viewModel.state.title, 'Matches (2)');
  });

  test('checkSwipeDirection sets shouldShowGlow true when distance > 0.3', () {
    final viewModel = SwipeViewModel(
      searchCriteria: SearchCriteria(
        keyword: 'Math',
        issue: 'Algebra',
        reachability: Reachability.online,
      ),
    );

    viewModel.checkSwipeDirection(0.5, skipScheduler: true);
    expect(viewModel.state.shouldShowGlow, true);
  });

  test('checkSwipeDirection sets shouldShowGlow false when distance <= 0.3', () {
    final viewModel = SwipeViewModel(
      searchCriteria: SearchCriteria(
        keyword: 'Math',
        issue: 'Algebra',
        reachability: Reachability.online,
      ),
    );

    viewModel.checkSwipeDirection(0.2, skipScheduler:  true);
    expect(viewModel.state.shouldShowGlow, false);
  });

}
