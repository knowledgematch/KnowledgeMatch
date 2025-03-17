import '../../domain/models/request_date_data.dart';
import '../../domain/models/search_criteria.dart';

class RequestState {
  List<RequestDateData> selectedDates = [];
  List<RequestDateData> incomingDates = [];
  List<RequestDateData> newDates = [];
  SearchCriteria searchCriteria;
  RequestDateData? selectedDate;
}
