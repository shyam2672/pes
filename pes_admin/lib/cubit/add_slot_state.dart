part of 'add_slot_cubit.dart';

@immutable
abstract class AddSlotState {}

class AddSlotInitial extends AddSlotState {}

class AddSlotLoading extends AddSlotState {}

class ApplicationSubmitted extends AddSlotState {}

class ApplicationData extends AddSlotState {}

class AddSlotError extends AddSlotState {
  final String error;

  AddSlotError(this.error);
}
