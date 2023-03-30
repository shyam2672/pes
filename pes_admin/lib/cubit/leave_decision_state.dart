part of 'leave_decision_cubit.dart';

@immutable
abstract class LeaveDecisionState {}

class LeaveDecisionInitial extends LeaveDecisionState {}

class LeaveDecisionMarking extends LeaveDecisionState {}

class LeaveDecisionMarked extends LeaveDecisionState {
  String decision;
  LeaveDecisionMarked(this.decision);
}

class LeaveDecisionNotMarked extends LeaveDecisionState {
  String error;
  LeaveDecisionNotMarked(this.error);
}

