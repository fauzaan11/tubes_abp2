import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bgImg.jpg'), fit: BoxFit.cover),
      ),
      child: Container(
          color: Colors.black.withOpacity(.5),
          child: Column(
            children: [
              const Text(
                "BaliKuyy",
                style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
              const Text(
                "Explore Bali",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50, top: 30),
                child: MaterialButton(
                  padding: const EdgeInsets.all(15),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  color: Colors.white.withOpacity(0.5),
                  textColor: Colors.white,
                  child: Text(
                    "Next",
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                  ),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )),
    ));
  }
}
