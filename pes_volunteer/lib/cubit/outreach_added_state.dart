part of 'outreach_added_cubit.dart';

@immutable
abstract class AddOutreachState {}

class AddOutreachInitial extends AddOutreachState {}

class AddOutreachApplying extends AddOutreachState {}

class AddOutreachApplied extends AddOutreachState {}

class AddOutreachNotApplied extends AddOutreachState {
  final String message;
  AddOutreachNotApplied(this.message);
}
