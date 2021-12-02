import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/screens/product_page.dart';
import 'package:ecommerceapp/widgets/custom_action_bar.dart';
import 'package:ecommerceapp/widgets/product_cart.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String imageUrl;

    return Stack(
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Product").snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("error : ${snapshot.error}"),
            ),
          );
        }
        //Product is ready to display
        if(snapshot.connectionState == ConnectionState.active){
          //display product data to list view
          return Stack(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Container(
              //       child: Column(
              //         children: [
              //           Container(
              //             alignment: Alignment.topLeft,
              //             margin: EdgeInsets.only(
              //               top: 130.0,
              //               left: 50.0
              //             ),
              //             child: Text("Hello our Customer.... ",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.blue),),
              //           ),
              //           Container(
              //               alignment: Alignment.topLeft,
              //               margin: EdgeInsets.only(
              //                 left: 80.0),
              //               child: Text("Welcome from our shop and \nsearch everything you want ",style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600, color: Colors.black),)),
              //         ],
              //       ),
              //     ),
              //     Container(
              //         alignment: Alignment.topRight,
              //         margin: EdgeInsets.only(
              //             top: 130.0,
              //             right: 50.0
              //         ),
              //         child: Image(image: AssetImage("assets/icon.png"),width: 80.0,height: 80.0,))
              //   ],
              // ),
              ListView.builder(
                padding: EdgeInsets.only(
                  top: 108.0,
                  bottom: 12.0,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  imageUrl = snapshot.data!.docs[index]["image"][0];
                  return Column(
                      children: [
                        ProductCart(productId: snapshot.data!.docs[index].id,
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ProductPage(productId: snapshot.data!.docs[index].id),
                              ));
                            },
                            imageUrl: imageUrl,
                            title: snapshot.data!.docs[index]["name"],
                            price: "${snapshot.data!.docs[index]["price"]}"),
                      ]
                  );
                },
              ),
            ]
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
          },
        ),
        CustomActionBar(
          title: "Home",
          hasTitle: true,
          hasBackArrow: false,
          hasBackground: true,
          doFunction: "Cart",
        ),

      ],
    );
  }
}
