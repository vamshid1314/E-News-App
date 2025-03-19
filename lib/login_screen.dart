import 'package:e_news_app/input_fields.dart';
import 'package:e_news_app/register_screen.dart';
import 'package:e_news_app/secure_storage.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0077b6),
                  Color(0xFF00b4d8),
                ],
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Sign Up\nWith Your Name",
                    style: TextStyle(
                      fontFamily:'MW',
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.white,
                    ),
                ),

                SizedBox(height: 20),

                InputFields(
                    controller: nameController,
                    inputText: "Enter Your Name..",
                    inputIcon: Icons.account_box,
                ),

                SizedBox(height: 20),

                InputFields(
                  controller: passwordController,
                  inputText: "Enter Your Password..",
                  inputIcon: Icons.password_outlined,
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(

                      onPressed: () async{
                        String name = nameController.text;
                        String password = passwordController.text;

                        String? storedName = await SecureStorage().readName('name');
                        String? storedPassword = await SecureStorage().readPassword('password');

                        if (name.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter both name and password')),
                          );
                          return;
                        }
                        if(name == storedName && password == storedPassword){
                          await SecureStorage().writeLoggedIn("isLogin","true");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Invaild cerdentials\nCreate an Account")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF023e8a),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                          "Sign In",
                         style: TextStyle(
                           fontFamily: 'MW',
                           fontSize: 20,
                           color: Colors.white,
                         ),
                      ),
                  ),
                ),

                SizedBox(height: 30,),

                Row(
                  children: [
                    Expanded(
                        child: Divider(
                          thickness: 2,
                          endIndent: 10,
                          indent: 10,
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          "Or",
                        style: TextStyle(
                          fontFamily: "MW",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        endIndent: 10,
                        indent: 10,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
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
                          "Register",
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
      ),
    );
  }
}