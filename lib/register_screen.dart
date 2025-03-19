import 'package:e_news_app/secure_storage.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'input_fields.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient:LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00b4d8),
                Color(0xFF0077b6),
              ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Welcome to\nE-News..",
                   style: TextStyle(
                     fontFamily: 'MW',
                     fontWeight: FontWeight.bold,
                     fontSize: 50,
                     color: Colors.white,
                   ),
              ),

              SizedBox(height: 20),

              InputFields(
                inputText: 'Enter Your Name..',
                inputIcon: Icons.account_box,
                controller: nameController,
              ),

              SizedBox(height:20),

              InputFields(
                inputText: 'Enter Your Password..',
                inputIcon: Icons.password_outlined,
                controller: passwordController,
              ),

              SizedBox(height:20),

              InputFields(
                inputText: 'Confirm Password..',
                controller: confirmPasswordController,
              ),

              SizedBox(height:30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    String name = nameController.text;
                    String password = passwordController.text;
                    String confirmPassword = confirmPasswordController.text;

                    if(name.isEmpty || password.isEmpty || confirmPassword.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter all the fields..")),
                      );
                      return;
                    }

                    if(password == confirmPassword){
                      SecureStorage().writeName('name',name);
                      SecureStorage().writePassword('password',password);
                      SecureStorage().writeLoggedIn("isLogin","true");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password doesn't match")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF023e8a),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                  child: Text(
                    "Sign-Up",
                    style: TextStyle(
                      fontFamily: 'MW',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}