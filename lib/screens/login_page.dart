import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/screens/register_page.dart';
import 'package:ecommerceapp/widgets/CustomButton.dart';
import 'package:ecommerceapp/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Default Form Loading State

  bool _loginFormLoading = false;

  // Form Input Field Values
  String _loginEmail = "";
  String _loginPassword = "";

  // Focus Node for input fields
  late FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  //Custom Alert Dialog
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  // Create a new user account
  Future<String?> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    // Run the create account method
    String? _loginFeedback = await _loginAccount();

    // If the string is not null, we got error while create account.
    if(_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoginHead(),
              Column(
                children: [
                  CustomInput(
              hintText: "Email",
              onChanged: (value){
                _loginEmail = value;
              },
               onSubmitted: (value){
                _passwordFocusNode.requestFocus();
              },
              textInputAction: TextInputAction.next,
              isPasswordField: false),
                  CustomInput(
                      hintText: "Password",
                      onChanged: (value){
                        _loginPassword = value;
                      }, onSubmitted: (value){
                    _submitForm();
                  },
                      textInputAction: TextInputAction.done,
                      isPasswordField: true),
                  CustomButtom(text: "Login" ,
                      onloading: _loginFormLoading,
                      onPressed: (){
                    _submitForm();
                  }),
                ],
              ),
              CustomButtom(text: "Create new account",
                  onloading: false,
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterPage()
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget LoginHead() {
    return Container(
      padding: const EdgeInsets.only(top: 24.0,),
      child: const Text(
        "Welcome User,\nLogin to your account",
        textAlign: TextAlign.center,
        style: Constants.boldHeading,
      ),
    );
  }
}