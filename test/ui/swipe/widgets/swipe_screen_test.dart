import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/search_criteria.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/ui/swipe/view_model/swipe_view_model.dart';
import 'package:knowledgematch/ui/swipe/widgets/swipe_screen.dart';
import 'package:provider/provider.dart';

class FakeSwipeViewModel extends SwipeViewModel {
  FakeSwipeViewModel.withFuture(Future<List<Userprofile>> future)
      : _mockFuture = future,
        super(
        searchCriteria: SearchCriteria(
          keyword: 'test',
          issue: 'test',
          reachability: Reachability.online,
        ),
        skipMatching: true,
      );

  late final Future<List<Userprofile>> _mockFuture;

  @override
  Future<List<Userprofile>> get profilesFuture => _mockFuture;
}


void main() {
  testWidgets('displays loading indicator when waiting', (tester) async {
    final viewModel = FakeSwipeViewModel.withFuture(
      Future.delayed(const Duration(seconds: 1), () => []),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<SwipeViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: SwipeScreen()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('displays no matches message when list is empty', (tester) async {
    final viewModel = FakeSwipeViewModel.withFuture(
      Future.value([]), // Empty list as result
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<SwipeViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: SwipeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No more profiles to show!'), findsOneWidget);
  });

  testWidgets('displays swipeable cards when data is available', (tester) async {
    final mockProfiles = [
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
        email: '',
      ),
    ];

    final viewModel = FakeSwipeViewModel.withFuture(
      Future.value(mockProfiles),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<SwipeViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: SwipeScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.textContaining('Matches'), findsOneWidget);
    expect(find.byType(SwipeScreen), findsOneWidget);
  });
}
