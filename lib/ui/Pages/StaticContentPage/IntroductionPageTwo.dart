import 'package:flutter/material.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/ui/Pages/StaticContentPage/GetStartedPage.dart';

class IntroductionPageTwo extends StatelessWidget {
  const IntroductionPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSizeScaleFactor = MyConst.deviceWidth(context) / MyConst.referenceWidth;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(70)),
                  child: Image.asset(
                    'assets/images/intro_build_2.jpg',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Text(
                    'Discover Your Future Home',
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
                    'Your Perfect Home Awaits',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24 * fontSizeScaleFactor,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tailored to Your Lifestyle',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20 * fontSizeScaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Explore a wide range of properties designed to suit your lifestyle and preferences. With JAY BUILDCON, finding your dream home has never been easier. Experience luxury, comfort, and convenience all in one place.',
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
                          MaterialPageRoute(builder: (context) => const GetStartedPage()),
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
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Implement skip action if needed
                      },
                      child: Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
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
