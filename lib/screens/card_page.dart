import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/screens/product_page.dart';
import 'package:ecommerceapp/service/firebase_service.dart';
import 'package:ecommerceapp/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseServices _firebaseServices= FirebaseServices();

  void _DeleteTheSaved(String productId){
    var delete = _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(productId)
        .delete();
    delete.onError((error, stackTrace) => {
      print("${error}")
    });
  }

  @override
  Widget build(BuildContext context) {
    _showDialog(String productId){
      Dialog errorDialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          height: 200.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.all(0.0),
                child: Text('Delete', style: TextStyle(color: Colors.red,fontSize: 20.0),),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('Are you sure', style: TextStyle(color: Colors.red),),
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              TextButton(onPressed: () {
                  _DeleteTheSaved(productId);
                Navigator.of(context).pop();
                setState(() {

                });
              },
                  child: Text('Got It!', style: TextStyle(color: Colors.purple, fontSize: 18.0),))
            ],
          ),
        ),
      );
      showDialog(context: context, builder: (BuildContext context) => errorDialog);
    }
    return Scaffold(
      body: Stack(
        children: [
          CustomActionBar(title: "Cart", hasBackArrow: false, hasTitle: true, hasBackground: true,doFunction: "Cart"),
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").get(),
            builder: (context,AsyncSnapshot snapshot) {
              //Has a error
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("error : ${snapshot.error}"),
                  ),
                );
              }
              //Product is ready to display
              if(snapshot.connectionState == ConnectionState.done){
                //display product data to list view
                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    //print("Photo Url ======>${snapshot.data!.docs[index]["image"][0]}");
                    return GestureDetector(
                      onLongPress: (){
                          _showDialog(snapshot.data!.docs[index].id);
                      },
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductPage(productId: snapshot.data!.docs[index].id),
                        ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsRef.doc(snapshot.data!.docs[index].id).get(),
                        builder: (context,AsyncSnapshot futurebuilder){

                          if(futurebuilder.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${futurebuilder.error}"),
                              ),
                            );
                          }
                          if(futurebuilder.connectionState == ConnectionState.done) {
                            Map _productMap = futurebuilder.data.data();
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${_productMap['image'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_productMap['name']}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            "\$${_productMap['price']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          "Size - ${snapshot.data!.docs[index].data()['size']}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    );
                    // Container(child: Center(child: Text("${snapshot.data!.docs[index]["name"]}"),),);
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
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {

                      },
                      child: Container(
                        height: 65.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Add to Payment",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
