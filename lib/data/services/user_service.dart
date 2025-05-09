import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/domain/models/user.dart';

Future<void> initializeUser(int userId) async {
  try {
    List<dynamic> response = ApiDbConnection().initUser(userId) as List;

    if (response.isNotEmpty) {
      User.instance.populateFromJson(response.first);
      print('User initialized: ${User.instance}');
    } else {
      print('No user data found.');
    }
  } catch (e) {
    print('Error fetching user data.');
  }
}
