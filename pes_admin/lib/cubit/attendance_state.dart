part of 'attendance_cubit.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {}

class AttendanceLoadFailure extends AttendanceState {
  final String error;

  AttendanceLoadFailure({required this.error});
}
