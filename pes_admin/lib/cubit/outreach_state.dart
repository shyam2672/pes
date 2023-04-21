part of 'outreach_cubit.dart';

@immutable
abstract class OutreachState {}

class OutreachInitial extends OutreachState {}

class OutreachLoading extends OutreachState {}

class OutreachLoaded extends OutreachState {}
class OutreachRejected extends OutreachState {}

class OutreachNotRejected extends OutreachState {}

class OutreachAccepted extends OutreachState {}

class OutreachNotAccepted extends OutreachState {}

class OutreachFailure extends OutreachState {
  final String error;
  OutreachFailure(this.error);
}
