import 'dart:convert';

import 'package:test/test.dart';
import 'package:knowledgematch/models/search_criteria.dart';
import 'package:knowledgematch/models/reachability.dart';

void main() {
  group('SearchCriteria', () {
    group('Constructor', () {
      test('Creates an instance with given values', () {
        final criteria = SearchCriteria(
          keyword: 'test',
          issue: 'someIssue',
          reachability: Reachability.inPerson,
        );

        expect(criteria.keyword, equals('test'));
        expect(criteria.issue, equals('someIssue'));
        expect(criteria.reachability, equals(Reachability.inPerson));
      });

      test('Creates an instance where reachability is null', () {
        final criteria = SearchCriteria(
          keyword: 'test',
          issue: 'someIssue',
        );

        expect(criteria.keyword, equals('test'));
        expect(criteria.issue, equals('someIssue'));
        expect(criteria.reachability, null);
      });
    });

    group('toJSON', () {
      test('Returns correct JSON map', () {
        final criteria = SearchCriteria(
          keyword: 'searchKey',
          issue: 'issueDescription',
          reachability: Reachability.inPerson,
        );

        final jsonMap = criteria.toJSON();
        expect(jsonMap['keyword'], equals('searchKey'));
        expect(jsonMap['issue'], equals('issueDescription'));
        expect(
            jsonMap['reachability'], equals(Reachability.inPerson.toString()));
      });

      test('Returns correct JSON if reachability is null', () {
        final criteria = SearchCriteria(
          keyword: 'abc',
          issue: 'def',
        );

        final jsonMap = criteria.toJSON();
        expect(jsonMap['reachability'], null);
      });
    });

    group('toString', () {
      test('Returns a valid JSON encoded string', () {
        final searchCriteria = SearchCriteria(
          keyword: 'keywordValue',
          issue: 'issueValue',
          reachability: Reachability.onlineOrInPerson,
        );

        final string = searchCriteria.toString();
        expect(() => jsonDecode(string), returnsNormally);
      });
    });

    group('fromJSON', () {
      test('Creates a valid SearchCriteria from JSON with all fields', () {
        final jsonMap = {
          'keyword': 'testKeyword',
          'issue': 'testIssue',
          'reachability': Reachability.onlineOrInPerson.toString(),
        };

        final criteria = SearchCriteria.fromJSON(jsonMap);

        expect(criteria.keyword, equals('testKeyword'));
        expect(criteria.issue, equals('testIssue'));
        expect(criteria.reachability, equals(Reachability.onlineOrInPerson));
      });

      test(
          'Creates a valid SearchCriteria with default value for reachability, when reachability is null',
          () {
        final jsonMap = {
          'keyword': 'testKeyword',
          'issue': 'testIssue',
          'reachability': '',
        };

        final criteria = SearchCriteria.fromJSON(jsonMap);

        expect(criteria.keyword, equals('testKeyword'));
        expect(criteria.issue, equals('testIssue'));
        expect(criteria.reachability, Reachability.onlineOrInPerson);
      });

      test(
          'Creates a valid SearchCriteria with default value for reachability when reachability is unrecognized',
          () {
        final jsonMap = {
          'keyword': 'testKeyword',
          'issue': 'testIssue',
          'reachability': 'notRecognizableString',
        };

        final criteria = SearchCriteria.fromJSON(jsonMap);

        expect(criteria.keyword, equals('testKeyword'));
        expect(criteria.issue, equals('testIssue'));
        expect(criteria.reachability, Reachability.onlineOrInPerson);
      });

      test('Throws if required fields are missing', () {
        // Adjust the behavior if your class handles missing fields differently.
        // For instance, if `keyword` or `issue` are required, this might throw a TypeError or FormatException.
        final jsonMapMissingField = {
          'keyword': 'noIssueHere',
          // missing 'issue'
        };

        expect(() => SearchCriteria.fromJSON(jsonMapMissingField),
            throwsA(anything));
      });
    });

    group('fromJSONString', () {
      test('Creates a valid SearchCriteria from valid JSON string', () {
        final jsonString = '''
        {
          "keyword": "fromStringKeyword",
          "issue": "fromStringIssue",
          "reachability": "${Reachability.onlineOrInPerson.toString()}"
        }
        ''';

        final criteria = SearchCriteria.fromJSONString(jsonString);

        expect(criteria.keyword, equals('fromStringKeyword'));
        expect(criteria.issue, equals('fromStringIssue'));
        expect(criteria.reachability, Reachability.onlineOrInPerson);
      });

      test('Throws a FormatException on invalid JSON string', () {
        const invalidJsonString = '{ invalid json }';
        expect(() => SearchCriteria.fromJSONString(invalidJsonString),
            throwsFormatException);
      });
    });
  });
}
