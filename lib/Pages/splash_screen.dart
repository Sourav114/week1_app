import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week1_app/Dashboard/dashboard_page.dart';
import 'package:week1_app/Login/login_page.dart';

import '../Login/blocs/login_bloc.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {

  static const String keyLogin = "login";

  @override
  void initState() {
    super.initState();
    whereToGo();
    // _navigateToHome();
  }

  // _navigateToHome() async{
  //   await Future.delayed(const Duration(seconds: 3),(){});
  //
  //   Navigator.pushReplacement(context as BuildContext,
  //                             MaterialPageRoute(
  //                                 builder: (context) => BlocProvider(
  //                                     create: (context) => SignInBloc(),
  //                                     child: const LoginPage())));
  // }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      ),
    );
  }

    void whereToGo() async {
      var sharedPref = await SharedPreferences.getInstance();
      var isLoggedIn = sharedPref.getBool(keyLogin);
      //var isLoggedIn = 10;

      Future.delayed(const Duration(seconds: 3), () {
        if (isLoggedIn != null) {
          if (isLoggedIn) {
            Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) => BlocProvider(
                                                    create: (context) => SignInBloc(),
                                                    child: const DashBoard())));
          }
          else {
            Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) => BlocProvider(
                                                    create: (context) => SignInBloc(),
                                                    child: const LoginPage())));
          }
        }
        else {
          Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => BlocProvider(
                                                  create: (context) => SignInBloc(),
                                                  child: const LoginPage())));
        }
      });
    }
  }
