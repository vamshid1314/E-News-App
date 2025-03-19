import 'dart:async';
import 'package:e_news_app/secure_storage.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class Splash extends StatefulWidget{
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              center: Alignment.center,
              radius: 1,
              colors: [
                Color(0xFF0077b6),
                Color(0xFF00b4d8),
              ]
          ),
        ),
        child: Center(
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.white,
            child: Text(
                "E-News",
                style: TextStyle(
                  fontFamily:'MW',
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color(0xFF219EBC),
                  // color: Colors.black,
                ),
            ),
          ),
        ),
      ),
    );
  }

  void checkUser() async{
    String? name = await SecureStorage().readName('name');
    String? password = await SecureStorage().readPassword('password');
    String? isLoggedIn = await SecureStorage().readLoggedIn('isLogin');

    await Future.delayed(const Duration(seconds: 3));

    if(mounted){
      if(name != null && password != null && isLoggedIn == "true"){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }
}