import 'dart:convert';

import 'package:knowledgematch/models/reachability.dart';
import 'package:knowledgematch/models/search_criteria.dart';
import 'package:knowledgematch/models/user.dart';
import 'package:knowledgematch/models/userprofile.dart';

import 'api_db_connection.dart';

class MatchingAlgorithm {
  Future<List<String>> getKeywords() async {
    var result = await ApiDbConnection().fetchKeywords();
    return result.map((item) => item['Keyword'].toString()).toList();
  }

  /// Fetches a list of distinct reachability values from the server.
  ///
  /// This method makes a request to the server to retrieve distinct reachability values,
  /// then maps the results to a list of `Reachability` objects. It returns a list of
  /// `Reachability` objects if the request is successful, or `null` if there is an error.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of [Reachability] objects or `null` if the request fails.
  Future<List<Reachability>?> getReachabilities() async {
    var result =
        await ApiDbConnection().fetchDistinctDataFromUser("Reachability");
    return result
        .map<Reachability>(
            (row) => ReachabilityValue.fromValue((row['Reachability'])))
        .toList();
  }

  /// Retrieves a list of user profiles that match the specified search criteria.
  ///
  /// This method uses the provided [SearchCriteria] to filter users based on various parameters
  /// such as keyword and reachability. It returns a list of [Userprofile] objects, excluding the
  /// current user, after applying the matching algorithm.
  ///
  /// Parameters:
  /// - [searchCriteria]: The criteria used to filter users, including keyword and reachability.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of matching [Userprofile] objects.
  Future<List<Userprofile>> matchingAlgorithm(
      SearchCriteria searchCriteria) async {
    List<Userprofile> profiles = [];
    var data = await ApiDbConnection().fetchUserByInput(
      uId: null,
      name: null,
      surname: null,
      keyword: searchCriteria.keyword,
      reachability: searchCriteria.reachability?.value.toString(),
      email: null,
    );
    if (data != []) {
      for (var user in data) {
        profiles.add(_createUserFromJson(user));
      }
    }
    profiles.removeWhere((user) => user.id == User.instance.id);
    return profiles;
  }

  /// Fetches the user profile corresponding to the specified user ID.
  ///
  /// This method retrieves user data by the given [id] and converts it into a [Userprofile] object.
  ///
  /// Parameters:
  /// - [id]: The ID of the user whose profile is to be fetched.
  ///
  /// Returns:
  /// - A [Future] that completes with the [Userprofile] object corresponding to the given user ID.
  Future<Userprofile> getUserProfileById(int id) async {
    var data = await ApiDbConnection().fetchUserByInput(uId: id.toString());
    return _createUserFromJson(data.elementAt(0));
  }

  /// Creates a [Userprofile] object from a JSON [Map].
  ///
  /// This method parses the provided [user] map and converts it into a [Userprofile] object.
  /// It also processes any associated tokens and picture data.
  ///
  /// Parameters:
  /// - [user]: A map containing user data to be converted.
  ///
  /// Returns:
  /// - A [Userprofile] object populated with the parsed data from the map.
  Userprofile _createUserFromJson(Map<String, dynamic> user) {
    List<String> tokenList = [];
    if (user['Tokens'] != null && user['Tokens'].toString().trim().isNotEmpty) {
      tokenList = user['Tokens']
          .toString()
          .split(',')
          .map<String>((token) => token.trim())
          .toList();
    }
    Userprofile userprofile = Userprofile(
      id: int.parse(user['U_ID'].toString()),
      seniority: int.parse(user['Seniority'].toString()),
      name: user['FullName'].toString(),
      location: 'Placeholder',
      expertString: user['Keywords'].toString(),
      availability: 'Placeholder',
      langString: 'Placeholder',
      reachability: ReachabilityValue.fromValue(
          int.parse(user['Reachability'].toString())),
      description: user['Description'].toString(),
      tokens: tokenList,
    );

    if (user['Picture'] != null) {
      userprofile.setPicture(
          base64Encode((user['Picture']['data'] as List<dynamic>).cast<int>()));
    }
    return userprofile;
  }
}
