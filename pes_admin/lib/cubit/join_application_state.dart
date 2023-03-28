part of 'join_application_cubit.dart';

@immutable
abstract class JoinApplicationState {}

class JoinApplicationInitial extends JoinApplicationState {}

class JoinApplicationLoading extends JoinApplicationState {}

class JoinApplicationLoaded extends JoinApplicationState {}

class JoinApplicationLoadFailed extends JoinApplicationState {
  String error;
  JoinApplicationLoadFailed(this.error);
}
