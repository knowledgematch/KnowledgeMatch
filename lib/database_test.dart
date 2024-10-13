import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';

Future<void> main() async {
  try {
    // Create a connection
    final conn = await MySQLConnection.createConnection(
      host: "86.119.45.62", // Your host IP address or server name
      port: 3306, // The port the server is running on
      userName: "km", // Your username
      password: "Znn147s^B&KO6fW2pRNT", // Your password
      databaseName: "knowledge_match", // Your database name
			secure: false, //TODO to true after SSL is enabled on Server
    );

    // Connect to the database
    await conn.connect();

    // Execute a query
    var result = await conn.execute('SELECT * FROM Users');

    // Iterate over the results
    for (var row in result.rows) {
      var data = row.assoc();
      print(
          'Id: ${data['U_ID']}, Name: ${data['Name']}, Surname: ${data['Surname']}');
    }

    // Close the connection
    await conn.close();
  } catch (e) {
    print('An error occurred: $e');
  }
}

