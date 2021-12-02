import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/screens/product_page.dart';
import 'package:ecommerceapp/service/firebase_service.dart';
import 'package:ecommerceapp/widgets/custom_input.dart';
import 'package:ecommerceapp/widgets/product_cart.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
final FirebaseServices _firebaseServices = FirebaseServices();

String _searchStirng = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if(_searchStirng.isNotEmpty)
            StreamBuilder(
              stream: _firebaseServices.productsRef.orderBy("search string")
                  .startAt([_searchStirng])
                  .endAt(["$_searchStirng\uf8ff"])
                  .snapshots(),
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
                  return ListView.builder(
                    padding: EdgeInsets.only(
                      top: 128.0,
                      bottom: 12.0,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      String imageUrl = snapshot.data!.docs[index]["image"][0];
                      return ProductCart(productId: snapshot.data!.docs[index].id,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ProductPage(productId: snapshot.data!.docs[index].id),
                            ));
                          },
                          imageUrl: imageUrl,
                          title: snapshot.data!.docs[index]["name"],
                          price: "${snapshot.data!.docs[index]["price"]}");
                    },
                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          if(_searchStirng.isEmpty)
            Center(child: Text("Search results  ", style: Constants.regularDarkText,)),
          Padding(
            padding: const EdgeInsets.only(
              top: 47.0,

            ),
            child: CustomInput(hintText: "Search ..",
                onChanged: (val){
                  setState(() {
                    _searchStirng = val.toLowerCase();
                  });
                },
                onSubmitted: (val){
                setState(() {
                  _searchStirng = val.toLowerCase();
                });
                },
                textInputAction: TextInputAction.done,
                isPasswordField: false),
          ),
          // Text("Search results  ", style: Constants.regularDarkText,),

        ],
      ),
    );
  }
}
