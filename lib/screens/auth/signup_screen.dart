import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responder/screens/home_screen.dart';
import 'package:responder/widgets/button_widget.dart';
import 'package:responder/widgets/text_widget.dart';
import 'package:responder/widgets/textfield_widget.dart';

import '../../services/add_user.dart';
import '../../widgets/toast_widget.dart';

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
                register(context);
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

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // addUser(nameController.text, contactnumberController.text,
      //     addressController.text, emailController.text);

      addUser(nameController.text, contactnumberController.text,
          addressController.text, emailController.text);

      showToast('Account created succesfully!');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showToast('The email address is not valid.');
      } else {
        showToast(e.toString());
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
