part of 'all_slots_cubit.dart';

@immutable
abstract class AllSlotsState {}

class AllSlotsInitial extends AllSlotsState {}

class AllLoading extends AllSlotsState {}

class AllLoaded extends AllSlotsState {}

class AllLoadFailure extends AllSlotsState {
  final String error;

  AllLoadFailure(this.error);
}
