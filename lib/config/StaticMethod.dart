import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StaticMethod {
  //============================================INITIAL FETCH TOKEN AND USERTYPE
  static void initialFetch(appState) async {
    appState.fetchUserType();
    await Future.delayed(const Duration(milliseconds: 100));
    appState.fetchToken(appState.userType);
    await Future.delayed(const Duration(milliseconds: 100));
  }
  //================================================FETCH CUSTOMER DATA BY TOKEN
  static userProfileInitial(token, url, appState) async {
    var response;
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final res = await http.get(url, headers: requestHeaders);
      await Future.delayed(const Duration(milliseconds: 100));
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        //print('customer data is :' + response['result'].toString());
        if (appState.userType == "admin") {
          appState.adminDetails = response['result'];
        } else if(appState.userType == "customer") {
          appState.customerDetails = response['result'];
        }else if(appState.userType == "employee"){
          appState.employeeDetails = response['result'];
        }
        return response;
      } else {
        response = jsonDecode(res.body);
        appState.customerDetail = {};
      }
    } catch (e) {
      //print('failed to complete user profile api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching user detail',
        "error":e.toString()
      };
    }
  }



  //==============================CUSTOMER RELATED METHODS======================


  //======================================================== FETCH PROPERTY LIST
  static Future<Map<String, dynamic>> fetchAllProperties(url) async {
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);

      } else {
        return jsonDecode(res.body);

      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for property list',
        "error":e.toString()
      };
    }
  }


  //=================================================FETCH SINGLE PROPERTY BY ID
  static Future<Map<String, dynamic>> fetchSingleProperties(data,url) async {

    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(data), headers: requestHeaders);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for property list',
        "error":e.toString()
      };
    }
  }


  //============================================================FETCH PROPERTIES
  static Future<Map<String,dynamic>> fetchAllPropertyWithPaginationAndFilter(
      appState, paginationOptions,url,
      {
        String selectedCity = "",
        String selectedPropertyType = "All",
        int propertyUn = 0,
        int selectedBhk = 0,
        int selectedFloor = 0,
        String selectedGarden = "None",
        String selectedParking = "None",
        String selectedFurnished = "None",
        String selectedAvailability = "None",
        int minPrice = 0,
        int maxPrice = 100000000,
        String propertyName = "",
        int propertyId = 0,
        int projectId = 0
      }
      ) async{

    Map<String,dynamic> filterOptions = {
      "propertytype": selectedPropertyType == "All" ? "" : selectedPropertyType,
      "propertyUn":propertyUn,
      "propertybhk": selectedPropertyType == "All" ? 0 :selectedBhk,
      "propertyfloor": selectedPropertyType == "All" ? 0 :selectedFloor,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      "propertygarden": selectedGarden == "None" ? "" : selectedGarden,
      "propertyparking": selectedParking=="None" ? "" : selectedParking,
      "propertyfurnished": selectedFurnished=="None" ? "" : selectedFurnished,
      "propertyavailability":selectedAvailability=="None" || selectedAvailability=="All" ? "" : selectedAvailability,
      "propertyname": propertyName,
      "propertycity": selectedCity,
      "projectId":projectId
    };
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'filterOptions': filterOptions,
          'paginationOptions': paginationOptions,
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting property list',
        "error":e.toString()
      };
    }

  }


  //=============================================================SIGNUP CUSTOMER
  static Future<Map<String, dynamic>> userSignup(signupData, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(signupData), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for user signup',
        "error":e.toString()
      };
    }
  }


  //================================================UPDATE CUSTOMER DETAILS
  static Future<Map<String, dynamic>> updateCustomerDetails(token, url,data) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final res = await http.post(url, headers: requestHeaders, body: jsonEncode(data));

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for update details',
        "error":e.toString()
      };
    }
  }


  //======================================================GENERATE OTP FOR LOGIN
  static Future<Map<String, dynamic>> generateOtp(userData, url) async {

    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(userData), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for generate otp',
        "error":e.toString()
      };
    }
  }


  //========================================================SUBMIT OTP AND LOGIN
  static Future<Map<String, dynamic>> submitOtpAndLogin(otpModel, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(otpModel), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for verify otp and login',
        "error":e.toString()
      };
    }
  }


  //================================================FETCH CUSTOMER DATA BY TOKEN
  static Future<Map<String, dynamic>> userProfile(token, url) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final res = await http.get(url, headers: requestHeaders);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while fetching customer detail',
        "error":e.toString()
      };
    }
  }


  //=====================================================GENERATE OTP FOR SIGNUP
  static Future<Map<String, dynamic>> sendOtpForSignup(userData, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(userData), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for generate signup otp',
        "error":e.toString()
      };
    }
  }


  //========================================================VERIFY OTP FOR SIGNUP
  static Future<Map<String, dynamic>> verifyOtpForSignup(otpModel, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(otpModel), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete verify otp and login');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while verifying otp and login',
        "error":e.toString()
      };
    }
  }


  //======================================================SEND REQUEST FOR VISIT
  static Future<Map<String, dynamic>> requestVisit(token, bookVisitModel, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(bookVisitModel), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete request visit api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for requestVisit api',
        "error":e.toString()
      };
    }
  }


  //=============================================================ADD TO FAVORITE
  static Future<Map<String, dynamic>> addToFavorite(token, data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer ${token}',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete add to favorite api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for addToFavorite api',
        "error":e.toString()
      };
    }
  }


  //========================================================REMOVE FROM FAVORITE
  static Future<Map<String, dynamic>> removeFromFavorite(token, data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete remove from favorite api');
      //print(e.toString());
      return {
        "success": false,
        "message":
            'An error occured while requesting for removeFromFavorite api',
        "error":e.toString()
      };
    }
  }


  //=====================================================FETCH FAVORITE PROPERTY
  static Future<Map<String, dynamic>> fetchFavoriteProperty(token, data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete fetchPropertyList api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching favorite property api',
        "error":e.toString()
      };
    }
  }


  //================================================FETCH FAVORITE PROPERTY LIST
  static Future<Map<String, dynamic>> fetchFavoritePropertyListDetails(token,
      data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete fetchPropertyList api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching favorite property api',
        "error":e.toString()
      };
    }
  }


  //==================================================FETCH VISIT REQUESTED LIST
  static Future<Map<String, dynamic>> fetchVisitRequestedList(token, data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete visit requested list api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching visit requested list api',
        "error":e.toString()
      };
    }
  }


  //=======================FETCH VISIT REQUESTED LIST WITH PAGINATION AND FILTER
  static Future<Map<String, dynamic>> fetchVisitRequestedListWithPagination( appState,url,paginationOptions,token, {
    int selectedRequestStatus = 4,
  }) async {

    Map<String,dynamic> filterOptions={
      "requestStatus":selectedRequestStatus,
    };
    Map<String,dynamic> data={
      "c_id":appState.customerDetails['customer_id'],
    };

    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'filterOptions': filterOptions,
          'paginationOptions': paginationOptions,
          'data':data
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete fetchPropertyList api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting property list',
        "error":e.toString()
      };
    }

  }


  //=======================================FETCH VISIT REQUESTED PROPERTY DETAIL
  static Future<Map<String, dynamic>> fetchVisitRequestedPropertyDetails(token,
      data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete visit requested list api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching visit requested list api',
        "error":e.toString()
      };
    }
  }


  //===============================================================LOGOUT METHOD
  static void logout(appState) async {
    appState.deleteToken(appState.userType);
    appState.token = "";
    await Future.delayed(const Duration(
        milliseconds: 100)); // Add a small delay (100 milliseconds)

    appState.deleteUserType();
    appState.userType = "";
    await Future.delayed(const Duration(milliseconds: 100));

    appState.customerDetails = {};
    appState.customerDetails.clear();
    appState.adminDetails = {};
    appState.adminDetails.clear();
    await Future.delayed(const Duration(milliseconds: 100));

    appState.activeWidget = "PropertyListPage";
    appState.currentState = 0;

    await appState.fetchUserType();
    Future.delayed(const Duration(milliseconds: 100));

    appState.fetchToken(appState.userType);
    Future.delayed(const Duration(milliseconds: 100));
  }


  //======================================================SUBMIT PROPERTY RATING
  static Future<Map<String, dynamic>> submitPropertyRating(token, data, url) async {

    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
      await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {

      return {
        "success": false,
        "message": 'An error occured while submit rating api',
        "error":e.toString()
      };
    }
  }


  //====================================================================OPEN MAP
  static void openMap(url) async {
    String mapUrl = url;
    if (!await launchUrl(Uri.parse(mapUrl),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch the map.';
    }
  }


  //=========================================================FETCH ADMIN CONTACT
  static Future<Map<String, dynamic>> fetchAdminContact(url) async {
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
     // print('failed to complete fetchAdminContact api');
     // print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting admin contact',
        "error":e.toString()
      };
    }
  }


  //============================================================FETCH OFFER LIST
  static Future<Map<String, dynamic>> fetchOfferList(url) async {
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting offer list',
        "error":e.toString()
      };
    }
  }


  //=================================================================FETCH OFFER
  static Future<Map<String, dynamic>> fetchOffer(url,data) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,headers: requestHeaders,body: jsonEncode(data));

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      // print('failed to complete fetchOfferList api');
      // print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting offer ',
        "error":e.toString()
      };
    }
  }

  //============================================================FETCH PROPERTIES
  static Future<Map<String,dynamic>> fetchBlog(appState, paginationOptions,url,) async{
    
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'paginationOptions': paginationOptions,
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for blog list',
        "error":e.toString()
      };
    }

  }



  //==========================ADMIN RELATED METHOD==============================

  //================================================================REMOVE OFFER
  static Future<Map<String, dynamic>> deletOffer(url,data,token) async {

    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,headers: requestHeaders,body: jsonEncode(data));

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting for delete offers',
        "error":e.toString()
      };
    }
  }

  //======================================================FETCH CUSTOMER REQUEST
  static Future<Map<String, dynamic>> fetchCustomerRequest(token, url) async {

    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.get(url,headers: requestHeaders);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {

      return {
        "success": false,
        "message": 'An error occured while requesting customer Request list',
        "error":e.toString()
      };
    }
  }

  //======================================FETCH CUSTOMER REQUEST WITH PAGINATION
  static Future<Map<String,dynamic>> fetchCustomerRequestWithPagination(
    appState,url,paginationOptions,token, {
    int selectedRequestStatus = 4,
  }
  )async {
    Map<String,dynamic> filterOptions={
      "requestStatus":selectedRequestStatus
    };

    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'filterOptions': filterOptions,
          'paginationOptions': paginationOptions,
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting customer request with pagination',
        "error":e.toString()
      };
    }

  }


  //=========================================================CHANGE VISIT STATUS
  static Future<Map<String, dynamic>> changeVisitStatus(token,data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.put(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete changeVisitStatus api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for changeVisitStatus api',
        "error":e.toString()
      };
    }
  }


  //================================================CHANGE PROPERTY AVAILABILITY
  static Future<Map<String, dynamic>> changePropertyAvailability(token,data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
      await http.put(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete changeVisitStatus api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for change availability',
        "error":e.toString()
      };
    }
  }


  //================================================FETCH PROJECT
  static Future<Map<String, dynamic>> fetchProject(url) async {
    try {
      final res =
      await http.get(url);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete changeVisitStatus api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for project fetching',
        "error":e.toString()
      };
    }
  }


  //================================================FETCH PROJECT WITH PAGINATION
  static Future<Map<String, dynamic>> fetchProjectWithPagination(url,paginationOption,{
    String searchItem = "",
  }) async {
    Map<String, dynamic> filterOptions = {
      "searchItem": searchItem
    };
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'filterOptions': filterOptions,
          'paginationOptions': paginationOption,
        }),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete changeVisitStatus api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for project fetching',
        "error":e.toString()
      };
    }
  }


  //=========================================================INSERT NEW PROPERTY
  static Future<Map<String, dynamic>> insertProperty(token, data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      //print('failed to complete insertProperty api');
      //print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for insertProperty api',
        "error":e.toString()
      };
    }
  }


  //======================================================DELETE PROPERTY IMAGES
  static Future<Map<String, dynamic>> deletePropertyImage(token, data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message":
            'An error occured while requesting for deletePropertyImage api',
        "error":e.toString()
      };
    }
  }


  //======================================FETCH CUSTOMER LIST WITH PAGINATION
  static Future<Map<String,dynamic>> fetchCustomerListWithPagination(
      appState,url,paginationOptions,token, {
        String searchItem = "",
      }
      )async {
    Map<String, dynamic> filterOptions = {
      "searchItem": searchItem
    };

    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'filterOptions': filterOptions,
          'paginationOptions': paginationOptions,
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting property list with pagination',
        "error": e.toString()
      };
    }
  }



  //======================================FETCH EMPLOYEE LIST WITH PAGINATION
  static Future<Map<String,dynamic>> fetchEmployeeListWithPagination(
      appState,url,paginationOptions,token, {
        String searchItem = "",
      }
      )async {
    Map<String, dynamic> filterOptions = {
      "searchItem": searchItem
    };

    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'filterOptions': filterOptions,
          'paginationOptions': paginationOptions,
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message": 'An error occured while requesting property list with pagination',
        "error": e.toString()
      };
    }
  }
  
  
  
  
  //=========================================BLOG POST
//======================================================DELETE PROPERTY IMAGES
  static Future<Map<String, dynamic>> postBlog(token, data, url) async {
    try {
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
      await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {
        "success": false,
        "message":
        'An error occured while requesting for posting a blog',
        "error":e.toString()
      };
    }
  }
  




}
