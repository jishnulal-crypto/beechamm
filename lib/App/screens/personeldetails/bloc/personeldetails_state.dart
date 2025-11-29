part of 'personeldetails_bloc.dart';

enum PersonnelRole { colonyOwner, chemApplicator, landOwner }

class PersonneldetailsState {
  final String fullName;
  final String address;
  final String suburb;
  final String stateCode;
  final String postCode;
  final String contactNumber;
  final Map<PersonnelRole,String> selectedRoles;
  final String additionalNotes;
  final bool isActive;
  final bool isSaving;

  // 🔥 NEW FIELDS
  final String? errorMessage;
  final bool saveSuccess;

  PersonneldetailsState({
    this.fullName = '',
    this.address = '',
    this.suburb = '',
    this.stateCode = '',
    this.postCode = '',
    this.contactNumber = '',
    this.selectedRoles = const {},
    this.additionalNotes = '',
    this.isActive = true,
    this.isSaving = false,

    // NEW DEFAULTS
    this.errorMessage,
    this.saveSuccess = false,
  });

  PersonneldetailsState copyWith({
    String? fullName,
    String? address,
    String? suburb,
    String? stateCode,
    String? postCode,
    String? contactNumber,
    Map<PersonnelRole,String>? selectedRoles,
    String? additionalNotes,
    bool? isActive,
    bool? isSaving,

    // NEW
    String? errorMessage,
    bool? saveSuccess,
  }) {
    return PersonneldetailsState(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      suburb: suburb ?? this.suburb,
      stateCode: stateCode ?? this.stateCode,
      postCode: postCode ?? this.postCode,
      contactNumber: contactNumber ?? this.contactNumber,
      selectedRoles: selectedRoles?? this.selectedRoles,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      isActive: isActive ?? this.isActive,
      isSaving: isSaving ?? this.isSaving,

      // NEW
      errorMessage: errorMessage,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }
}
