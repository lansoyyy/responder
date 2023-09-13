import 'package:flutter/material.dart';
import 'package:responder/screens/auth/login_screen.dart';
import 'package:responder/widgets/button_widget.dart';
import 'package:responder/widgets/text_widget.dart';
import 'package:responder/widgets/textfield_widget.dart';

class SignupScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final contactnumberController = TextEditingController();
  final addressController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextWidget(
              text: 'Register here',
              fontSize: 24,
              fontFamily: 'Bold',
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(
              label: 'Name',
              controller: nameController,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(
              label: 'Contact Number',
              controller: contactnumberController,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(
              label: 'Address',
              controller: addressController,
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
              label: 'Signup',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
