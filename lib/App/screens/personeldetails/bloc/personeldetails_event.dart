part of 'personeldetails_bloc.dart';

abstract class PersonneldetailsEvent {}

class FullNameChanged extends PersonneldetailsEvent {
  final String name;
  FullNameChanged(this.name);
}

class AddressChanged extends PersonneldetailsEvent {
  final String address;
  AddressChanged(this.address);
}

class SuburbChanged extends PersonneldetailsEvent {
  final String suburb;
  SuburbChanged(this.suburb);
}

class StateCodeChanged extends PersonneldetailsEvent {
  final String stateCode;
  StateCodeChanged(this.stateCode);
}

class PostCodeChanged extends PersonneldetailsEvent {
  final String postCode;
  PostCodeChanged(this.postCode);
}

class ContactNumberChanged extends PersonneldetailsEvent {
  final String number;
  ContactNumberChanged(this.number);
}

class RoleChanged extends PersonneldetailsEvent {
  final PersonnelRole role;
  RoleChanged(this.role);
}

class NotesChanged extends PersonneldetailsEvent {
  final String notes;
  NotesChanged(this.notes);
}

class StatusToggled extends PersonneldetailsEvent {}

class FormSaved extends PersonneldetailsEvent {}
