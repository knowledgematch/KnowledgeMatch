import 'package:knowledgematch/domain/models/keyword2topic.dart';

import '../../domain/models/keyword.dart';
import '../../domain/models/organisation.dart';
import '../../domain/models/topic.dart';

class AdminState {
  List<Keyword> keywords;
  List<Topic> topics;
  List<Keyword2Topic> keyword2topic;
  List<Organisation> organisations;
  Keyword? editingKeyword;
  Topic? editingTopic;
  Keyword? selectedKeyword;
  Topic? selectedTopic;
  Organisation? editingOrganisation;
  Organisation? selectedOrganisation;
  bool? isDeleting;

  AdminState({
    required this.keywords,
    required this.topics,
    required this.keyword2topic,
    required this.organisations,
    this.editingKeyword,
    this.editingTopic,
    this.selectedKeyword,
    this.selectedTopic,
    this.editingOrganisation,
    this.selectedOrganisation,
    this.isDeleting,
  });

  AdminState copyWith({
    List<Keyword>? keywords,
    List<Topic>? topics,
    List<Keyword2Topic>? keyword2topic,
    List<Organisation>? organisations,
    Keyword? editingKeyword,
    Topic? editingTopic,
    Keyword? selectedKeyword,
    Topic? selectedTopic,
    Organisation? editingOrganisation,
    Organisation? selectedOrganisation,
    bool? isDeleting,
  }) {
    return AdminState(
      keywords: keywords ?? this.keywords,
      topics: topics ?? this.topics,
      keyword2topic: keyword2topic ?? this.keyword2topic,
      organisations: organisations ?? this.organisations,
      editingKeyword: editingKeyword,
      editingTopic: editingTopic,
      selectedKeyword: selectedKeyword ?? this.selectedKeyword,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      editingOrganisation: editingOrganisation,
      selectedOrganisation: selectedOrganisation,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}
