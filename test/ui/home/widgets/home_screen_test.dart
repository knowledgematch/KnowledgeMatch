import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/home/view_model/home_view_model.dart';
import 'package:knowledgematch/ui/home/widgets/home_screen.dart';
import 'package:knowledgematch/ui/main/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class TestMainViewModel extends MainScreenViewModel {
  int? lastUpdatedIndex;

  @override
  void updateIndex(int index) {
    lastUpdatedIndex = index;
    super.updateIndex(index);
  }
}

class DummyHomeViewModel extends HomeViewModel {
  @override
  void refresh() {}

  @override
  Future<void> loadData() async {}
}

void main() {
  setUp(() {
    final user = User.instance;
    user.name = 'Test User';
    user.description = null;
    user.picture = null;
    user.seniority = null;
  });

  testWidgets('shows incomplete profile banner and calls updateIndex on Edit tap', (WidgetTester tester) async {
    final homeViewModel = DummyHomeViewModel();
    final mainViewModel = TestMainViewModel();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>.value(value: homeViewModel),
          ChangeNotifierProvider<MainScreenViewModel>.value(value: mainViewModel),
        ],
        child: MaterialApp(
          home: HomeScreen(mainViewModel: mainViewModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Your profile is incomplete—add info to stand out."), findsOneWidget);

    await tester.tap(find.text("Edit"));
    await tester.pumpAndSettle();

    expect(mainViewModel.lastUpdatedIndex, 3);
  });

  testWidgets('shows welcome message with user name', (WidgetTester tester) async {
    final homeViewModel = DummyHomeViewModel();
    final mainViewModel = TestMainViewModel();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>.value(value: homeViewModel),
          ChangeNotifierProvider<MainScreenViewModel>.value(value: mainViewModel),
        ],
        child: MaterialApp(
          home: HomeScreen(mainViewModel: mainViewModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining("Test User"), findsOneWidget);
  });

  testWidgets('does not show banner when profile is complete', (WidgetTester tester) async {
    final user = User.instance;
    user.description = 'Experienced developer';
    user.picture =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=';
    user.seniority = 0;

    final homeViewModel = DummyHomeViewModel();
    final mainViewModel = TestMainViewModel();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>.value(value: homeViewModel),
          ChangeNotifierProvider<MainScreenViewModel>.value(value: mainViewModel),
        ],
        child: MaterialApp(
          home: HomeScreen(mainViewModel: mainViewModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Your profile is incomplete—add info to stand out."), findsNothing);
  });
}
