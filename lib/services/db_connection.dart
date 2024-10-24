import 'package:mysql_client/mysql_client.dart';

class DBConnection {
  Future<IResultSet?> getSQLResponse(String query) async {
    MySQLConnection? conn;
    try {
      conn = await MySQLConnection.createConnection(
        host: "86.119.45.62",
        port: 3306,
        userName: "km",
        password: "Znn147s^B&KO6fW2pRNT",
        databaseName: "knowledge_match",
        secure: false, //TODO to true after SSL is enabled on Server
      );

      await conn.connect();
      var result = await conn.execute(query);
      return result;
    } catch (e) {
      print('An error occurred: $e');
      return null;
    } finally {
      if (conn != null) {
        await conn.close();
      }
    }
  }
}
