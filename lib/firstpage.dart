import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'RemoteAccessPage.dart';
import 'main.dart';
class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(

        child: Column(
          children: [
            Text("YOU ARE MOST WELCOME TO REMOTE DESKTO APP",
              style: TextStyle(color: Colors.white),),
            Container(
              color: Colors.pink,
              height: 550,
              width: 1200,
              child: Image.asset("image/photo.jpg",
                //fit: BoxFit.cover,
                //fit: BoxFit.fitHeight,
                //fit: BoxFit.fitWidth,
                fit: BoxFit.fill,
              ),



            ),
            SizedBox(height: 20,),
            Text("CLICK NEXT TO CONTINUE AND EXIT TO LEAVE",
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300.0),
              child: Row(
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context) => RemoteAccessPage()),
                    );
                  }, child: Text("Next")
                  ),
                  SizedBox(width: 400,),
                  ElevatedButton(onPressed: (){
                    //SystemNavigator.pop();
                    exit(0);
                  }, child: Text("Exit"))
                ],
              ),
            ),
            // ElevatedButton(onPressed: (){}, child: Text("Exit"))

          ],
        ),
      ),
      /*body: Center(
        child: Container(

          height: 400,
          width: 400,
          child: Row(

            child:  Image(
                  image: AssetImage(
                      "image/photo.jpg")),

          ),
        ),
      ),*/
    );
  }
}
