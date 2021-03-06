import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_samples/res/custom_colors.dart';
import 'package:flutterfire_samples/screens/authentication/email_password/ep_register_screen.dart';
import 'package:flutterfire_samples/screens/authentication/email_password/ep_user_info_screen.dart';
import 'package:flutterfire_samples/screens/database/crud/db_dashboard_screen.dart';
import 'package:flutterfire_samples/utils/ep_authentication.dart';
import 'package:flutterfire_samples/utils/ep_validator.dart';

import '../../custom_form_field.dart';

class EPSignInForm extends StatefulWidget {
 

  const EPSignInForm({
    Key? key,
  }) : super(key: key);
  @override
  _EPSignInFormState createState() => _EPSignInFormState();
}

class _EPSignInFormState extends State<EPSignInForm> {
   final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Palette.firebaseNavy,
      appBar:AppBar(
        backgroundColor:  Palette.firebaseNavy,
        elevation: 0,
      ),
      body: SingleChildScrollView(

        child: Column(
          
          children: [
            SizedBox(height:30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _signInFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 24.0,
                      ),
                      child: Column(
                        children: [
                          CustomFormField(
                            controller: _emailController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                            validator: (value) => EPValidator.validateEmail(
                              email: value,
                            ),
                            label: 'Email',
                            hint: 'Enter your email',
                          ),
                          SizedBox(height: 16.0),
                          CustomFormField(
                            controller: _passwordController,
                            focusNode: passwordFocusNode,
                            keyboardType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            validator: (value) => EPValidator.validatePassword(
                              password: value,
                            ),
                            isObscure: true,
                            label: 'Password',
                            hint: 'Enter your password',
                          ),
                        ],
                      ),
                    ),
                    _isSigningIn
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Palette.firebaseOrange,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 0.0, right: 0.0),
                            child: Container(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Palette.firebaseOrange,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  emailFocusNode.unfocus();
                                  passwordFocusNode.unfocus();
                
                                  setState(() {
                                    _isSigningIn = true;
                                  });
                
                                  if (_signInFormKey.currentState!.validate()) {
                                    User? user =
                                        await EPAuthentication.signInUsingEmailPassword(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                
                                    if (user != null) {
                                     Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => DbDashboardScreen(),
                                ),
                              );
                                    }
                                  }
                
                                  setState(() {
                                    _isSigningIn = false;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.firebaseGrey,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 16.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => EPRegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: Palette.firebaseGrey,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
