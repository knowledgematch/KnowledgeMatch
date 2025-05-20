import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/keyword.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';
import 'package:knowledgematch/ui/find_matches/widgets/find_matches_screen.dart';
import 'package:provider/provider.dart';



void main() {
  testWidgets('FindMatchesScreen renders and submits correctly', (WidgetTester tester) async {
    final viewModel = FindMatchesViewModel();

    viewModel.updateKeyword(Keyword(id: 1, levels: 0, name: 'Test Keyword', description: "Test Keyword"));
    viewModel.updateReachability(Reachability.online);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: viewModel,
          child: const FindMatchesScreen(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(3));

    await tester.enterText(find.byType(TextFormField), 'This is a test issue');
    await tester.tap(find.text('Search helpers'));
    await tester.pumpAndSettle();

    expect(viewModel.state.description, 'This is a test issue');
  });
}
