// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vanrakshak/resources/authentication/loginAuthentication.dart';
import 'package:vanrakshak/screens/authScreens/signupScreen.dart';
import 'package:vanrakshak/screens/introSlider/introSlider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailAddress = TextEditingController();
    TextEditingController password = TextEditingController();
    LoginAuthorization loginAuth = Provider.of<LoginAuthorization>(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyLiquidSwipe(),
            ));
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 248, 222),
        body: (loginAuth.loading)
            ? const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              )
            : Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/authScreen/background.png"),
                          fit: BoxFit.fill)),
                ),
                SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 70.0),
                          const Image(
                            image: AssetImage('assets/main/logo.png'),
                            height: 150.0,
                            width: 300.0,
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: emailAddress,
                            style: const TextStyle(color: Colors.teal),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.teal),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            style: const TextStyle(color: Colors.teal),
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.teal),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                loginAuth.loginValidation(
                                    emailAddress: emailAddress,
                                    password: password,
                                    context: context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.teal,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
      ),
    );
  }
}
