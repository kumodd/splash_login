// Login Page with SIM Selection
import 'package:flutter/material.dart';
import 'package:splash_login/home_page.dart';
import 'package:splash_login/sim_dialog.dart';
import 'package:google_phone_number_hint/google_phone_number_hint.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _mobileNumber;

  final TextEditingController _phoneController = TextEditingController();


  @override
  void initState() {
    super.initState();
    //_fetchSimCards();

    // Show popup immediately after the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_showSimSelectionPopup();//
      _getGoogleMobileNumber();
    });
  }
    void _getGoogleMobileNumber() {
    GooglePhoneNumberHint().getMobileNumber().then((number) {
      setState(() {
        _mobileNumber = number;
        _phoneController.text = number ?? '';
      });
    });
  }


  void _showSimSelectionPopup() {
    // Get all SIM information

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimSelectionDialog(
          onNumberSelected: (number) {
            setState(() {
              _phoneController.text = number;
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your mobile number to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Phone Number TextField
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  if (_phoneController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Logging in with ${_phoneController.text}',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a mobile number'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Select Number Again Button
              TextButton.icon(
                onPressed: _showSimSelectionPopup,
                icon: const Icon(Icons.refresh),
                label: const Text('Select Number Again'),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
