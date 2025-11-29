abstract class PersonnelListEvent {}
class FetchPersonnelList extends PersonnelListEvent {}
class SearchQueryChanged extends PersonnelListEvent {
  final String query;
  SearchQueryChanged(this.query);
}
