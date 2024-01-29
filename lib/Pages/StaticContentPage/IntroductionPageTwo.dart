import 'package:flutter/material.dart';
import 'package:real_state/Pages/StaticContentPage/GetStartedPage.dart';
import 'package:real_state/config/Constant.dart';
class IntroductionPageTwo extends StatelessWidget {
  const IntroductionPageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(70)),
              child:  Image.asset(
                'assets/images/home.jpg',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height*0.5,
              ),
            ),
            const SizedBox(height: 40,),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'find perfect choice for your',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  Text(
                    'future house',
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    'something demo text for y&k buildcon private limited company that provide good real estate',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                  const SizedBox(height: 35,),
                  Center(child:  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).hintColor,

                          fixedSize: Size(
                              MediaQuery.of(context).size.width*0.7,
                              MediaQuery.of(context).size.height*0.076
                          )
                      ),
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const GetStartedPage()));
                      },
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      )
                  ),),
                  const SizedBox(height: 20,),
                  Center(child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(MediaQuery.of(context).size.width*0.7, MediaQuery.of(context).size.height*0.076)
                      ),
                      onPressed: (){},
                      child: Text(
                        'SKIP',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      )
                  ),)

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
