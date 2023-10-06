import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:week1_app/Login/login_page.dart';
import '../Login/blocs/login_bloc.dart';
import '../Pages/splash_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  List<dynamic> userData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> _logout() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(SplashState.keyLogin, false); // Example key to indicate login status
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => SignInBloc(),
                child: const LoginPage())));
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://randomuser.me/api/?results=50');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['results'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('User Data from API',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            backgroundColor: Colors.deepPurple,
          ),
          body: userData.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final user = userData[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(user['picture']['thumbnail']),
                      ),
                      title: Text(
                          '${user['name']['first']} ${user['name']['last']}'),
                      subtitle: Text(user['email']),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _logout();
              // var sharedPref = await SharedPreferences.getInstance();
              // sharedPref.setBool(SplashState.keyLogin, false);

              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(
              //         builder: (context) => BlocProvider(
              //             create: (context) => SignInBloc(),
              //             child: const LoginPage())));
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.logout),
          ),

        ),
      ),
    );
  }
}
