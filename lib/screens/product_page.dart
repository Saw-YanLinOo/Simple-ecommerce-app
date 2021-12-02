import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/service/firebase_service.dart';
import 'package:ecommerceapp/widgets/custom_action_bar.dart';
import 'package:ecommerceapp/widgets/image_swipe.dart';
import 'package:ecommerceapp/widgets/product_size.dart';
import 'package:flutter/material.dart';
class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();


}
class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  String _selectedProductSize = "0";
  bool checkExit = false;

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  SnackBar ShowSnackBar(String text){
    return SnackBar(content: Text("Product added to $text"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
              FutureBuilder(
                future: _firebaseServices.productsRef.doc(widget.productId).get(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.hasError){
                    return Scaffold(
                      body: Center(
                        child: Text("error : ${snapshot.error}"),
                      ),
                    );
                  }

                  if(snapshot.connectionState == ConnectionState.done){

                     Map<String,dynamic> documentData = snapshot.data!.data();

                    // List of images
                    List imageList = documentData['image'];
                    List productSizes = documentData['size'];

                    _selectedProductSize = productSizes[0];

                    return ListView(
                      padding: EdgeInsets.all(0.0),
                      children: [
                       ImageSwipe(imageList: imageList),
                        //Title
                        Padding(
                        padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                        ),
                          child: Text(
                            "${documentData['name']}",
                            style: Constants.boldHeading,
                          ),
                        ),
                        //Price
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 24.0,
                          ),
                          child: Text(
                            "\$${documentData['price']}",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        //Description
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 24.0,
                          ),
                          child: Text(
                            "${documentData['desc']}",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        //Size
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24.0,
                            horizontal: 24.0,
                          ),
                          child: Text(
                            "Select Size",
                            style: Constants.regularDarkText,
                          ),
                        ),
                        //Choose Produce Size
                        ProductSize(
                            productSizes: documentData["size"],
                            onSelected: (val){
                              _selectedProductSize = val;
                            }
                        ),

                        //Bottom bar
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //add to Saved
                              GestureDetector(
                                onTap: () async {
                                  await _addToSaved();
                                  ScaffoldMessenger.of(context).showSnackBar(ShowSnackBar("Saved"));
                                },
                                child: Container(
                                  width: 65.0,
                                  height: 65.0,
                                  decoration: BoxDecoration(
                                    color: checkExit ? Colors.blueAccent : Color(0xFFDCDCDC),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Image(
                                      image: AssetImage(
                                        "assets/tab_saved.png",
                                      ),
                                      color: checkExit ? Color(0xFFDCDCDC) : Colors.black,
                                      height: 22.0,
                                    ),

                                  ),
                                ),
                              ),

                              //add to Cart
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await _addToCart();
                                    ScaffoldMessenger.of(context).showSnackBar(ShowSnackBar("the Cart"));
                                  },
                                  child: Container(
                                    height: 65.0,
                                    margin: EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
          CustomActionBar(title: "Product detial", hasBackArrow: true, hasTitle: false, hasBackground: false,doFunction: "Cart",),
        ],
      )
    );
  }
}

