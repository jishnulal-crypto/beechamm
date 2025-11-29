import 'package:projecy/App/core/models/personel_list_model.dart';

enum PersonnelStatus { active, inactive }
enum ListStatus { initial, loading, success, failure }

class PersonnelListState {
  final ListStatus status;
  final List<PersonnelData> personnelList;   // 🔥 Now using your API model
  final String errorMessage;

  PersonnelListState({
    this.status = ListStatus.initial,
    this.personnelList = const [],
    this.errorMessage = '',
  });

  PersonnelListState copyWith({
    ListStatus? status,
    List<PersonnelData>? personnelList,
    String? errorMessage,
  }) {
    return PersonnelListState(
      status: status ?? this.status,
      personnelList: personnelList ?? this.personnelList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
