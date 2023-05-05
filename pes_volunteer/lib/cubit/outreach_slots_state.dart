part of 'outreach_slots_cubit.dart';

@immutable
abstract class OutreachState {}

class OutreachInitial extends OutreachState {}

class OutreachLoading extends OutreachState {}

class OutreachLoaded extends OutreachState {}
class OutreachAdded extends OutreachState {}

class OutreachNotAdded extends OutreachState {}
class AddOutreachApplying extends OutreachState {}

class AddOutreachApplied extends OutreachState {}
class OutreachAccepted extends OutreachState {}
class OutreachRejected extends OutreachState {}


class OutreachNotAccepted extends OutreachState {}

class OutreachFailure extends OutreachState {
  final String error;
  OutreachFailure(this.error);
}
