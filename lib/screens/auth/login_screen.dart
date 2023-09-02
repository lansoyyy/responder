import 'package:flutter/material.dart';
import 'package:responder/screens/home_screen.dart';
import 'package:responder/widgets/button_widget.dart';
import 'package:responder/widgets/text_widget.dart';
import 'package:responder/widgets/textfield_widget.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Image.asset(
              'assets/images/image 1.png',
              width: 350,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldWidget(
            label: 'Email',
            controller: emailController,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldWidget(
            isObscure: true,
            label: 'Password',
            controller: passwordController,
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonWidget(
            label: 'Login',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: 'Not registered?',
                fontSize: 12,
              ),
              TextButton(
                onPressed: () {},
                child: TextWidget(
                  fontFamily: 'Bold',
                  text: 'Signup now',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
