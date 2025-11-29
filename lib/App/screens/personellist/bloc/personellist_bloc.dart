import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projecy/App/core/models/personel_saved_model.dart';
import 'package:projecy/App/core/utils/token_security_hashing.dart';
import 'package:projecy/App/screens/personellist/bloc/personellist_event.dart';
import 'package:projecy/App/screens/personellist/bloc/personellist_state.dart';
import 'package:projecy/App/screens/personellist/repository/personellist_repository.dart';

class PersonnelListBloc extends Bloc<PersonnelListEvent, PersonnelListState> {
  PersonnelListBloc() : super(PersonnelListState()) {
    on<FetchPersonnelList>(_onFetchPersonnelList);
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }
  
  Future<void> _onFetchPersonnelList(
    FetchPersonnelList event,
    Emitter<PersonnelListState> emit,
  ) async {
    emit(state.copyWith(status: ListStatus.loading));

    try {
      final token =
          "Bearer ${TokenEncrypt.justToken}"; // replace with your encrypted/bearer token

      final data = await PersonellistRepository().getPersonnelList(token);
      emit(state.copyWith(status: ListStatus.success, personnelList: data));
    } catch (e) {
      emit(
        state.copyWith(status: ListStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<PersonnelListState> emit,
  ) async {
    print("Searching for: ${event.query}");
  }
}

Future<void> _onSearchQueryChanged(
  SearchQueryChanged event,
  Emitter<PersonnelListState> emit,
) async {
  print("Searching for: ${event.query}");
}
