import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_cubit_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.repository}) : super(LoginInitial());
  User user = User.empty(token: "");
  Map data = {};
  final MainRepository repository;

  Future<String> getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString("token") ?? "";
  }

  Future<bool> storeToken(token) async {
    print(token);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('token', token);
  }

  login() {
    emit(LoginRequested());
    repository.hasNetwork().then(
      (Bool) {
        getToken().then(
          (token) {
            print(token);
            if (token == "") {
              emit(SignIn());
            } else {
              if (!Bool) {
                user.token = token;
                emit(LoggedIn());
                return;
              }
              repository.validateToken(token).then(
                (response) {
                  switch (response.statusCode) {
                    case 201:
                      user = User.fromJson(
                        jsonDecode(response.body),
                        token: token,
                      );
                      emit(LoggedIn());
                      break;
                    case 404:
                      emit(NoNetwork());
                      break;
                    default:
                      emit(Error(error: "Invalid Token"));
                      Timer(Duration(seconds: 1), () => emit(SignIn()));
                      break;
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  verifyOtp(String otp) {
    emit(LoginRequested());
    repository.hasNetwork().then((Bool) {
      if (!Bool) {
        emit(NoNetwork());
        return;
      } else {
        repository.validateOtp(user.pesId, otp).then((response) {
          switch (response.statusCode) {
            case 201:
              // user = User.fromJson(jsonDecode(response.body));
              // emit(OTPSent());
              storeToken(jsonDecode(response.body)['token']);
              login();
              return;
              break;
            case 404:
              emit(NoNetwork());
              break;
            case 400:
              emit(Error(error: "Invalid PES ID"));
              Timer(Duration(seconds: 1), () => emit(SignIn()));
              break;
            case 401:
              emit(Error(error: "Wrong otp"));
              Timer(Duration(seconds: 1), () => emit(SignIn()));
              break;
            default:
              emit(Error(error: "Something went Wrong"));
              Timer(Duration(seconds: 1), () => emit(SignIn()));
              break;
          }
        });
      }
    });
  }

  signIn(String pesId) {
    emit(LoginRequested());
    repository.hasNetwork().then((Bool) {
      print("b");
      if (!Bool) {
        emit(NoNetwork());
        return;
      } else {
        repository.generateOtp(pesId).then((response) {
          switch (response.statusCode) {
            case 201:
              user.pesId = pesId;
              emit(OTPSent());
              break;
            case 404:
              emit(NoNetwork());
              break;
            case 400:
              emit(Error(error: "Invalid PES ID"));
              Timer(Duration(seconds: 1), () => emit(SignIn()));

              break;
            case 401:
              emit(Error(error: "Wrong Password"));
              Timer(Duration(seconds: 1), () => emit(SignIn()));
              break;
            default:
              emit(Error(error: "Something went Wrong"));
              Timer(Duration(seconds: 1), () => emit(SignIn()));
              break;
          }
        });
      }
    });
  }
}
