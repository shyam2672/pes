part of 'leave_applications_cubit.dart';

@immutable
abstract class LeaveApplicationsState {}

class LeaveApplicationsInitial extends LeaveApplicationsState {}

class LeaveApplicationsLoading extends LeaveApplicationsState {}

class LeaveApplicationsLoaded extends LeaveApplicationsState {}

class LeaveApplicationsLoadFailed extends LeaveApplicationsState {
  String error;
  LeaveApplicationsLoadFailed(this.error);
}



