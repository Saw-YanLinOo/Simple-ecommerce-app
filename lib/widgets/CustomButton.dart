import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool onloading;

  CustomButtom({required this.text,required this.onPressed,required this.onloading});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: GestureDetector(
        onTap:() {
          onPressed();
        },
        child: Container(
          height: 65.0,
          child: Stack(
            children: [
              Visibility(
                visible: onloading ? false : true,
                child: Center(
                  child: Text(text,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: true ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: onloading,
                child: const Center(
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: true ? Colors.transparent : Colors.black,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),

        ),

      ),
    );
  }
}
