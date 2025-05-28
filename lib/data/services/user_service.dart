import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/domain/models/user.dart';

import '../../core/log.dart';

Future<void> initializeUser(int userId) async {
  try {
    List<dynamic> response = await ApiDbConnection().initUser(userId) as List;

    if (response.isNotEmpty) {
      User.instance.populateFromJson(response.first);
      logger.d('User initialized: ${User.instance}');
    } else {
      logger.d('No user data found.');
    }
  } catch (e) {
    logger.e('Error fetching user data.');
  }
}
