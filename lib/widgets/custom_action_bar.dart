import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/screens/card_page.dart';
import 'package:ecommerceapp/service/firebase_service.dart';
import 'package:flutter/material.dart';
class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasBackground;
  final String doFunction;
  CustomActionBar({required this.title,required this.hasBackArrow,required this.hasTitle,required this.hasBackground,required this.doFunction});

  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: hasBackground ? LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0),
            ],
            begin: Alignment(0, 0),
            end: Alignment(0, 1),
          ): null
      ),

      padding: EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(hasBackArrow)
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image(
                  color: Colors.white,
                  width: 16.0,
                  height: 16.0,
                  image: AssetImage("assets/back_arrow.png"),
                ),
              ),
            ),
          if(hasTitle)
          Text(
            title,
            style: Constants.boldHeading,
          ),
          GestureDetector(
            onTap: (){
               if(doFunction == "Cart"){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CartPage(),
                ));
               }
            },
            child: Container(
              child: StreamBuilder(
                stream: firebaseServices.usersRef.doc(firebaseServices.getUserId()).collection(doFunction).snapshots(),
                builder: (content,AsyncSnapshot<QuerySnapshot> snapshot){
                  int totalItem = 0;
                  if(snapshot.connectionState == ConnectionState.active){
                    List _documentData = snapshot.data!.docs;
                    totalItem = _documentData.length;
                  }
                  return Stack(
                    children: [
                      Positioned(
                        top : 0.0,
                        right: 0.0,
                        child: Text("$totalItem", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,
                                  color: totalItem == 0 ? Colors.white : Colors.red,),
                            ),
                      ),
                      Container(
                        width: 42.0,
                        height: 42.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Icon(
                            doFunction == "Cart"? Icons.add_shopping_cart: Icons.save,
                            color: Colors.black,),
                        ),
                      ),
                    ],
                  );
                },
              )
            ),
          )
        ],
      ),
    );
  }
}
