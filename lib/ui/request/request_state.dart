import '../../domain/models/request_date_data.dart';
import '../../domain/models/search_criteria.dart';

class RequestState {
  final List<RequestDateData> selectedDates;
  final List<RequestDateData> incomingDates;
  final List<RequestDateData> newDates;
  final SearchCriteria searchCriteria;
  final RequestDateData? selectedDate;

  RequestState({
    required this.searchCriteria,
    this.selectedDates = const [],
    this.incomingDates = const [],
    this.newDates = const [],
    this.selectedDate,
  });

  RequestState copyWith({
    List<RequestDateData>? selectedDates,
    List<RequestDateData>? incomingDates,
    List<RequestDateData>? newDates,
    SearchCriteria? searchCriteria,
    RequestDateData? selectedDate,
  }) {
    return RequestState(
      searchCriteria: searchCriteria ?? this.searchCriteria,
      selectedDates: selectedDates ?? this.selectedDates,
      incomingDates: incomingDates ?? this.incomingDates,
      newDates: newDates ?? this.newDates,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
