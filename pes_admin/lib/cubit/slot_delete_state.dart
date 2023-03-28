part of 'slot_delete_cubit.dart';

@immutable
abstract class SlotDeleteState {}

class SlotDeleteInitial extends SlotDeleteState {}

class SlotDeleteLoading extends SlotDeleteState {}

class SlotSelectionActive extends SlotDeleteState {}

class ApplicationSubmitted extends SlotDeleteState {}

class ApplicationNotSubmitted extends SlotDeleteState {
  final String message;

  ApplicationNotSubmitted(this.message);
}
