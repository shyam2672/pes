import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  Color appBarColor = Color.fromARGB(255, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "About Us",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // color: Color.fromARGB(255, 18, 18, 18),

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // backgroundColor: appBarColor,

            Text(
              'Welcome to Our App!',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "Roboto",
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Pellentesque hendrerit mauris euismod risus semper, id '
              'consequat elit fringilla. Proin eu risus libero. Donec '
              'interdum elementum leo et dapibus. Nulla vel nibh '
              'mauris. Duis consectetur enim eget tempor efficitur. '
              'Curabitur ultrices convallis tellus, non consectetur '
              'nisi aliquet eget. Integer feugiat volutpat nibh, vitae '
              'tempus neque ullamcorper sit amet. Etiam ac velit ut '
              'massa pharetra malesuada eget et metus.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: "Roboto",
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "Roboto",
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: info@example.com',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: "Roboto",
              ),
            ),
            Text(
              'Phone: +1 123-456-7890',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: "Roboto",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
