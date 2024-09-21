import 'package:flutter/material.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/ui/Screens/HomeScreen.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key});

  @override
  Widget build(BuildContext context) {
    double fontSizeScaleFactor = MyConst.deviceWidth(context) / MyConst.referenceWidth;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(70)),
                  child: Image.asset(
                    'assets/images/intro_build_3.jpg',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Text(
                    'Find Your Dream Property',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28 * fontSizeScaleFactor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Property Awaits!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24 * fontSizeScaleFactor,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Just a Click Away!',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20 * fontSizeScaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Discover a faster, easier way to buy your dream property. With JAY BUILDCON, finding your ideal home is just a click away. Explore our vast selection of properties and find the perfect one for you!',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 55),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Version 1.1.0',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
