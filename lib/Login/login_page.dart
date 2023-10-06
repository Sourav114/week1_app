import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week1_app/Login/blocs/login_event.dart';
import 'package:week1_app/Dashboard/dashboard_page.dart';
import '../Pages/splash_screen.dart';
import 'blocs/login_bloc.dart';
import 'blocs/login_state.dart';

class LoginPage extends StatefulWidget {
   const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome,LoginHere',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center),
        backgroundColor: Colors.deepPurple,

      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<SignInBloc, SignInState>(
                builder: (context, state) {
                  if(state is SignInErrorState) {
                    return Text(state.errorMessage, style: const TextStyle(color: Colors.red),);
                  }
                  else {
                    return Container();
            }
        }),
            const SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              onChanged: (val){
                BlocProvider.of<SignInBloc>(context).add(
                  SignInTextChangedEvent(emailController.text, passwordController.text)
                );
              },
              decoration: const InputDecoration(
                labelText: 'Username (email)',),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: passwordController,
              onChanged: (val){
                BlocProvider.of<SignInBloc>(context).add(
                    SignInTextChangedEvent(emailController.text, passwordController.text)
                );
              },
              decoration: const InputDecoration(
                labelText: 'Password',),
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20.0,),
            BlocBuilder<SignInBloc,SignInState>(
              builder: (context, state) {
                if (state is SignInLoadingState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SignInBloc(),
                        child: const DashBoard(),
                      ),
                    ),
                  );
                }
                return CupertinoButton(
                    onPressed: ()async{

                      var sharedPref = await SharedPreferences.getInstance();
                      sharedPref.setBool(SplashState.keyLogin, true);

                      if(state is SignInValidState){
                        BlocProvider.of<SignInBloc>(context).add(
                            SignInSubmittedEvent(emailController.text, passwordController.text)
                        );
                      }
                    },
                    color: (state is SignInValidState) ? Colors.blue : Colors.grey,
                    child: const Text("Log In"),
                );
              },
              ),
            const SizedBox(height: 16.0),
            BlocBuilder<SignInBloc,SignInState>(
              builder: (context, state) {
                return CupertinoButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => SignInBloc(),
                          child: const DashBoard(),
                        ),
                      ),
                    );
                  },
                  color:  Colors.grey,
                  child: const Text("Skip"),
                );
              },
            )
          ]
        ),
      ),
    );
  }
}

