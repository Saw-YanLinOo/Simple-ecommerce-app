import 'package:ecommerceapp/screens/home_page.dart';
import 'package:ecommerceapp/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context,snapshot){

        //if firebase has error
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("error : ${snapshot.error}"),
            ),
          );
        }

        //Firebase app is running
        if(snapshot.connectionState == ConnectionState.done)
        {
          //StreamBuilder that check for login status
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,streamshapshot){

              //if firebase has error
              if(streamshapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("error : ${streamshapshot.error}"),
                  ),
                );
              }

              //Connection status alive and Check the user login
              if(streamshapshot.connectionState == ConnectionState.active){

                //Get the user
                Object? _user = streamshapshot.data;

                if(_user == null){
                  // The user is not logged in, head to login page
                  return LoginPage();
                }else{
                  // The user is logged in, head to homepage
                  return HomePage();
                }
              }
              //Checking the user auth state - loading
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },

          );
        }
        //Firebase app is loading
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },

    );
  }
}