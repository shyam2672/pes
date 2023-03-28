part of 'leave_pehchaan_cubit.dart';

@immutable
abstract class LeavePehchaanState {}

class LeavePehchaanInitial extends LeavePehchaanState {}

class LeavePehchaanApplying extends LeavePehchaanState {}

class LeavePehchaanApplied extends LeavePehchaanState {}

class LeavePehchaanNotApplied extends LeavePehchaanState {
	final String message;
	LeavePehchaanNotApplied(this.message);
}
