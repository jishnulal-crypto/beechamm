import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:projecy/App/core/enums/enums.dart';
import 'package:projecy/App/core/models/personel_saved_model.dart';
import 'package:projecy/App/core/utils/token_security_hashing.dart';
part 'personeldetails_event.dart';
part 'personeldetails_state.dart';

class PersonneldetailsBloc
    extends Bloc<PersonneldetailsEvent, PersonneldetailsState> {
  PersonneldetailsBloc() : super(PersonneldetailsState()) {
    on<FullNameChanged>((e, emit) => emit(state.copyWith(fullName: e.name)));
    on<AddressChanged>((e, emit) => emit(state.copyWith(address: e.address)));
    on<SuburbChanged>((e, emit) => emit(state.copyWith(suburb: e.suburb)));
    on<StateCodeChanged>(
      (e, emit) => emit(state.copyWith(stateCode: e.stateCode)),
    );
    on<PostCodeChanged>(
      (e, emit) => emit(state.copyWith(postCode: e.postCode)),
    );
    on<ContactNumberChanged>(
      (e, emit) => emit(state.copyWith(contactNumber: e.number)),
    );

    on<RoleChanged>((event, emit) {
      final newRoles = Map<PersonnelRole, String>.from(state.selectedRoles);

      if (newRoles.containsKey(event.role)) {
        // Remove if exists
        newRoles.remove(event.role);
      } else {
        // Add new role with its corresponding string id
        switch (event.role) {
          case PersonnelRole.colonyOwner:
            newRoles[event.role] = "1";
            break;
          case PersonnelRole.chemApplicator:
            newRoles[event.role] = "2";
            break;
          case PersonnelRole.landOwner:
            newRoles[event.role] = "3";
            break;
        }
      }
      print(newRoles);
      emit(state.copyWith(selectedRoles: newRoles));
    });

    on<NotesChanged>(
      (e, emit) => emit(state.copyWith(additionalNotes: e.notes)),
    );

    on<StatusToggled>(
      (e, emit) => emit(state.copyWith(isActive: !state.isActive)),
    );

    on<FormSaved>(_onFormSaved);
  }

  Future<void> _onFormSaved(
    FormSaved event,
    Emitter<PersonneldetailsState> emit,
  ) async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, saveSuccess: false),
    );

    final Uri url = Uri.parse(
      "https://beechem.ishtech.live/api/personnel-details/add",
    );

    final Map<String, dynamic> requestBody = {
      "first_name": state.fullName,
      "address": state.address,
      "suburb": state.suburb,
      "state": state.stateCode,
      "postcode": state.postCode,
      "contact_number": state.contactNumber,
      "role_ids": 1.toString(),
      // "roles": state.selectedRoles.map((e) => e.name).toList(),
      // "additional_notes": state.additionalNotes,
      "status": state.isActive ? 1 : 0,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":'Bearer ${TokenEncrypt.justToken}' , // your encrypted token
        },
        body: jsonEncode(requestBody),
      );
      print(requestBody.toString());
      print("this is the error");
      print(response.body);
      if (response.statusCode == 200) {
        print("here it comes personel");
        final decoded = jsonDecode(response.body);
        final result = PersonelSavedResponse.fromJson(decoded);

        if (result.status == true) {
          emit(state.copyWith(isSaving: false, saveSuccess: true));
        } else {
          print("${result.message} this is the error");
          emit(
            state.copyWith(
              isSaving: false,
              saveSuccess: false,
              errorMessage:
                  result.message.isNotEmpty
                      ? result.message
                      : "Failed to save details",
            ),
          );
        }
      } else {
        // 🔥 Print full server error (body + code)
        print("Exception occurred ${response.statusCode}: ${response.body}");

        emit(
          state.copyWith(
            isSaving: false,
            saveSuccess: false,
            errorMessage: "Server error: ${response.statusCode}",
          ),
        );
      }
    } catch (e) {
      print("Exception occurred: $e");
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: "Network error. Please try again.",
        ),
      );
    }
  }
}
