import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
class StaticMethod{

  //----------------------------------------------------------------------------INITIAL FETCH TOKEN AND USERTYPE
  static void initialFetch(appState)async{
    appState.fetchUserType();
    await Future.delayed(const Duration(milliseconds: 100));
    appState.fetchToken(appState.userType);
    await Future.delayed(const Duration(milliseconds: 100));
  }
  //---------------------------------------------------------------------------- FETCH PROPERTY LIST
  static Future<Map<String,dynamic>> fetchAllProperties(url)async{
    var response;
    try{
      final res = await http.get(url);

      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }

    }catch(e){
      print('failed to complete fetchPropertyList api');
      print(e.toString());
      return {
        "success":false ,
        "message":'An error occured while requesting property list'
      };
    }
  }

  //----------------------------------------------------------------------------SIGNUP CUSTOMER
  static Future<Map<String,dynamic>> customerSignup(customerData, url)async{
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(customerData), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete signup api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while registering due to request'
      };
    }
  }

  //----------------------------------------------------------------------------GENERATE OTP
  static Future<Map<String,dynamic>> generateOtp(otpModel, url)async{
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(otpModel), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete send otp api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while sending the otp'
      };
    }
  }

  //----------------------------------------------------------------------------SUBMIT OTP AND LOGIN
  static Future<Map<String,dynamic>> submitOtpAndLogin(otpModel, url)async{
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(otpModel), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete verify otp and login');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while verifying otp and login'
      };
    }
  }

  //----------------------------------------------------------------------------FETCH CUSTOMER DATA BY TOKEN
  static customerProfileInitial(token,url, appState)async{
    var response;
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try{
      final res = await http.get(url, headers: requestHeaders);
      await Future.delayed(const Duration(milliseconds: 100));
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        print('customer data is :'+response['result'].toString());
        appState.customerDetails = response['result'];
        return response;
      } else {
        response = jsonDecode(res.body);
        appState.customerDetail = {};
      }

    }catch(e){
      print('failed to complete customer profile api');
      print(e.toString());
      return {
        "success":false ,
        "message":'An error occured while fetching customer detail'
      };
    }
  }

  //----------------------------------------------------------------------------FETCH CUSTOMER DATA BY TOKEN
  static Future<Map<String,dynamic>> customerProfile(token,url)async{
    var response;
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try{
      final res = await http.get(url, headers: requestHeaders);

      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }

    }catch(e){
      print('failed to complete customer profile api');
      print(e.toString());
      return {
        "success":false ,
        "message":'An error occured while fetching customer detail'
      };
    }
  }

  //----------------------------------------------------------------------------BOOK VISIT
  static Future<Map<String,dynamic>> requestVisit(bookVisitModel, url)async{
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(bookVisitModel), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete request visit api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for requestVisit api'
      };
    }
  }

  //----------------------------------------------------------------------------add to favorite
  static Future<Map<String,dynamic>> addToFavorite(data,url)async{
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete add to favorite api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for addToFavorite api'
      };
    }
  }

  //----------------------------------------------------------------------------remove from favorite
  static Future<Map<String,dynamic>> removeFromFavorite(data,url)async{
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete remove from favorite api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for removeFromFavorite api'
      };
    }
  }

  //----------------------------------------------------------------------------fetch favorite property
  static Future<Map<String,dynamic>> fetchFavoriteProperty(data,url)async{
    var response;
    print("data is: "+data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete fetchPropertyList api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching favorite property api'
      };
    }
  }

  //----------------------------------------------------------------------------fetch favorite property List
  static Future<Map<String,dynamic>> fetchFavoritePropertyListDetails(data,url)async{
    var response;
    print("data is: "+data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete fetchPropertyList api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching favorite property api'
      };
    }
  }

  //----------------------------------------------------------------------------fetch favorite property List
  static Future<Map<String,dynamic>> fetchVisitRequestedList(data,url)async{
    var response;
    print("data is: "+data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete visit requested list api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching visit requested list api'
      };
    }
  }

  //----------------------------------------------------------------------------fetch favorite property List
  static Future<Map<String,dynamic>> fetchVisitRequestedPropertyDetails(data,url)async{
    var response;
    print("data is: "+data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete visit requested list api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching visit requested list api'
      };
    }
  }

  //----------------------------------------------------------------------------OPEN MAP
  static void openMap(url) async {
    // Replace with the desired latitude and longitude
     print('inside the open map url is ${url}');
    // Use the URL format for opening a map with coordinates
    String mapUrl = url;

    // Launch the map with the provided URL
    if (!await launchUrl(Uri.parse(mapUrl) as Uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch the map.';
    }
  }


  //=======================LOGOUT METHOD======================================
 static void logout(appState) async {
    appState.deleteToken(appState.userType);
    await Future.delayed(
        const Duration(milliseconds: 100)); // Add a small delay (100 milliseconds)

    appState.deleteUserType();
    await Future.delayed(const Duration(milliseconds: 100));

    appState.customerDetails = {};
    appState.customerDetails.clear();
    await Future.delayed(const Duration(milliseconds: 100));

    await appState.fetchUserType();
    Future.delayed(const Duration(milliseconds: 100));

    appState.fetchToken(appState.userType);
    Future.delayed(const Duration(milliseconds: 100));

    appState.activeWidget = "LoginWidget";
    appState.currentState=1;
  }


  //============================================================filter property method
 static void filterProperties(appState,{
    String selectedCity = "",
    String selectedPropertyType = "",
    int minPrice = 0,
    int maxPrice = 100000000,
    String propertyName = "",
  }) {

    appState.filteredPropertyList = appState.propertyList.where((property) {
      final String name = property['p_name'].toLowerCase();
      final String type = property['p_type'].toLowerCase();
      final String city = property['p_city'].toLowerCase();

      return (selectedPropertyType.isEmpty || type.contains(selectedPropertyType.toLowerCase())) &&
          (property['p_price'] >= minPrice && property['p_price'] <= maxPrice) &&
          (selectedCity.isEmpty || city.contains(selectedCity.toLowerCase())) &&
          (propertyName.isEmpty || name.contains(propertyName.toLowerCase()));
    }).toList();
  }


  //----------------------------------------------------------------------------submit property rating
  static Future<Map<String,dynamic>> submitPropertyRating(data,url)async{
    var response;
    print("data is: "+data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete submit rating api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while submit rating api'
      };
    }
  }


  //============================================================================FETCH ADMIN CONTACT WIDGET
  static Future<Map<String,dynamic>> fetchAdminContact(url)async{
    var response;
    try{
      final res = await http.get(url);

      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }

    }catch(e){
      print('failed to complete fetchAdminContact api');
      print(e.toString());
      return {
        "success":false ,
        "message":'An error occured while requesting admin contact'
      };
    }
  }






}