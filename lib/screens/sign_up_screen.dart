import 'package:flutter/material.dart';
import 'package:social_pedometer/firebase_methods/auth_methods.dart';
import 'package:social_pedometer/mobile_layout.dart';
import 'package:social_pedometer/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // Added username controller

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose(); // Dispose username controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark theme background
      body: SingleChildScrollView( // Wrap with SingleChildScrollView for scrolling when keyboard is visible
        padding: const EdgeInsets.all(20), // Padding around the form
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Added some space on top
            const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Space before form starts
            TextFieldInput(
              textEditingController: _usernameController,
              isPass: false,
              hintText: "Username",
              textInputType: TextInputType.text,
              
            ),
            const SizedBox(height: 12),
            TextFieldInput(
              textEditingController: _emailController,
              isPass: false,
              hintText: "Email",
              textInputType: TextInputType.emailAddress,
             
            ),
            const SizedBox(height: 12),
            TextFieldInput(
              textEditingController: _passwordController,
              isPass: true, // Make password obscure
              hintText: "Password",
              textInputType: TextInputType.text,
             
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
ElevatedButton(
  onPressed: () async {
    setState(() {
      _isLoading = true; // Assuming you have a state variable _isLoading
    });
    try {
      String result = await AuthMethods().createUser(
        displayName: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
      );
      if (result == 'success') {
        // Navigate to another screen or show a success message
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MobileLayout()));
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e) {
      // Exception handling if createUser throws any errors not caught by result
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign up: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  },
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50), // Button size
  ),
  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign Up"),
)
,
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => Navigator.pop(context), // Assuming this will lead back to the login screen
              child: const Text(
                "Already have an account? Log in",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20), // Space at the bottom
          ],
        ),
      ),
    );
  }
}
