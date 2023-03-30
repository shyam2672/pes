part of 'join_decision_cubit.dart';

@immutable
abstract class JoinDecisionState {}

class JoinDecisionInitial extends JoinDecisionState {}

class JoinDecisionMarking extends JoinDecisionState {}

class JoinDecisionMarked extends JoinDecisionState {
  final String decision;

  JoinDecisionMarked({required this.decision});
}

class JoinDecisionNotMarked extends JoinDecisionState {
  String error;
  JoinDecisionNotMarked(this.error);
}
