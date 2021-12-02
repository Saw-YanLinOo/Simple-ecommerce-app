import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ButtomTabs extends StatefulWidget {

   final int selectedTab;
   final Function(int) tabPressed;

  ButtomTabs({required this.selectedTab,required this.tabPressed});

  @override
  State<ButtomTabs> createState() => _ButtomTabsState();
}

class _ButtomTabsState extends State<ButtomTabs> {

  int selected = 0;
  @override
  Widget build(BuildContext context) {
    selected = widget.selectedTab;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0)
      ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 30.0,
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtomTabBtn(
            imagePath: "assets/tab_home.png",
            selected: selected == 0 ? true : false,
              onPressed:(){
                  widget.tabPressed(0);
                  print("homepage");
              },
          ),
          ButtomTabBtn(
            imagePath: "assets/tab_search.png",
            selected: selected == 1 ? true : false,
            onPressed:(){
              widget.tabPressed(1);
              print("Search Page");
            },
          ),
          ButtomTabBtn(
            imagePath: "assets/tab_saved.png",
            selected: selected == 2 ? true : false,
            onPressed:(){
              widget.tabPressed(2);
              print("Search Page");
            },
          ),
          ButtomTabBtn(
            imagePath: "assets/tab_logout.png",
            selected: selected == 3 ? true : false,
            onPressed:(){
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class ButtomTabBtn extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final Function onPressed;
  ButtomTabBtn({required this.imagePath,required this.selected,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected;

    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 24.0,
        ),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                  color: _selected ? Theme.of(context).backgroundColor : Colors.transparent,
                  width: 2.0,
                )
            )
        ),
        child: Image(
          image: AssetImage(
              imagePath
          ),
          width: 22.0,
          height: 22.0,
          color: _selected ? Theme.of(context).backgroundColor : Colors.black,
        ),
      ),
    );
  }
}