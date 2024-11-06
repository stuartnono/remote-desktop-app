import 'package:flutter/material.dart';
class Createaccount extends StatelessWidget {
  const Createaccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          TextField(),
          Text("Remote Deskton Application", style: TextStyle(fontSize: 30),),
          Text("Gives your Credentials", style: TextStyle(fontSize: 15),),
          /*TextButton(onPressed: (){}, child: Text("Your full name")),
          TextButton(onPressed: (){}, child: Text("Username")),
          TextButton(onPressed: (){}, child: Text("Password")),
          TextButton(onPressed: (){}, child: Text("Email")),
          TextButton(onPressed: (){}, child: Text("Contact")),*/
          Container(

          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34.0, vertical: 5.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  prefix: Icon(Icons.email)
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34.0, vertical: 5.0),
            child: TextField(
              //keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Full Name",
                  prefix: Icon(Icons.person)
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34.0, vertical: 5.0),
            child: TextField(
              //keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Username",
                  prefix: Icon(Icons.person)
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34.0, vertical: 5.0),
            child: TextField(
              obscureText: true,
              //keyboardType: TextInputType.,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  prefix: Icon(Icons.lock)
              ),
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Create Account"))

        ],
      ),
    );
  }
}
