import '../model/userprofile.dart';
import '../model/search_criteria.dart';
import 'db_connection.dart';

class MatchingAlgorithm{
  List<Userprofile> matchingAlgorithm(SearchCriteria searchCriteria) {
    String query = 'SELECT * FROM Users';
    List<String> queryBuilder = [];
    // List<Userprofile> profiles = [];

    List<Userprofile> profiles = [
      Userprofile(
        name: 'Alice',
        location: 'Brugg',
        expertString: 'Oop1 Dnet1 Sysad',
        availability: '18:30 - 19:30, every Friday',
        langString: 'German English',
        reachability: 3,
        description: 'Loves hiking and photography.',
      ),
      Userprofile(
        name: 'Bob',
        location: 'Brugg',
        expertString: 'algd1 eana Oop1',
        availability: '08:15 - 11:00, Every Sunday',
        langString: 'German English French',
        reachability: 2,
        description: 'Enjoys cooking and traveling.',
      ),
      Userprofile(
        name: 'Charlie',
        location: 'Brugg',
        expertString: 'vana Oop2 infsec',
        availability: '17:30 - 19:00, Every Sunday',
        langString: 'German English',
        reachability: 1,
        description: 'Passionate about technology and music.',
      ),
      Userprofile(
        name: 'Diana',
        location: 'Brugg',
        expertString: 'swagl uuidc pmc Oop1',
        availability: '11:00 - 12:00, Every Day',
        langString: 'English French',
        description: 'Avid reader and coffee enthusiast.',
      ),
    ];


    if (searchCriteria.topic.isNotEmpty) {
      queryBuilder.add("topic = '${searchCriteria.topic}'");
    }

    if (searchCriteria.reachability != null) {
      queryBuilder.add("reachability = ${searchCriteria.reachability}");
    }

    if(queryBuilder.isNotEmpty) {
      query += ' WHERE ${queryBuilder.join(' AND ')}';
    }

    var result = DBConnection().getSQLResponse(query);
    print('Result: ${result.asStream().toList()}');

    return profiles;
  }
}