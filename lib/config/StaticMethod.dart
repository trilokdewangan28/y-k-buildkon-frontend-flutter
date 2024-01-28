import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StaticMethod {
  //----------------------------------------------------------------------------INITIAL FETCH TOKEN AND USERTYPE
  static void initialFetch(appState) async {
    appState.fetchUserType();
    await Future.delayed(const Duration(milliseconds: 100));
    appState.fetchToken(appState.userType);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  //---------------------------------------------------------------------------- FETCH PROPERTY LIST
  static Future<Map<String, dynamic>> fetchAllProperties(url) async {
    var response;
    try {
      final res = await http.get(url);

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
        "message": 'An error occured while requesting property list'
      };
    }
  }

  //---------------------------------------------------------------------------- FETCH single PROPERTY LIST
  static Future<Map<String, dynamic>> fetchSingleProperties(data,url) async {
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
      print('failed to complete fetchPropertyList api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting property list'
      };
    }
  }

  //----------------------------------------------------------------------------SIGNUP CUSTOMER
  static Future<Map<String, dynamic>> userSignup(signupData, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(signupData), headers: requestHeaders);
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
  static Future<Map<String, dynamic>> generateOtp(userData, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(userData), headers: requestHeaders);
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

  //----------------------------------------------------------------------------GENERATE OTP for signup
  static Future<Map<String, dynamic>> sendOtpForSignup(userData, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(userData), headers: requestHeaders);
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
  static Future<Map<String, dynamic>> submitOtpAndLogin(otpModel, url) async {
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


  //----------------------------------------------------------------------------SUBMIT OTP AND LOGIN
  static Future<Map<String, dynamic>> verifyOtpForSignup(otpModel, url) async {
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
        print('customer data is :' + response['result'].toString());
        if (appState.userType == "admin") {
          appState.adminDetails = response['result'];
        } else {
          appState.customerDetails = response['result'];
        }
        return response;
      } else {
        response = jsonDecode(res.body);
        appState.customerDetail = {};
      }
    } catch (e) {
      print('failed to complete user profile api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching user detail'
      };
    }
  }

  //----------------------------------------------------------------------------FETCH CUSTOMER DATA BY TOKEN
  static Future<Map<String, dynamic>> userProfile(token, url) async {
    var response;
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final res = await http.get(url, headers: requestHeaders);

      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete customer profile api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while fetching customer detail'
      };
    }
  }

  //----------------------------------------------------------------------------BOOK VISIT
  static Future<Map<String, dynamic>> requestVisit(bookVisitModel, url) async {
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
  static Future<Map<String, dynamic>> addToFavorite(data, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
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
  static Future<Map<String, dynamic>> removeFromFavorite(data, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
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
        "message":
            'An error occured while requesting for removeFromFavorite api'
      };
    }
  }

  //----------------------------------------------------------------------------fetch favorite property
  static Future<Map<String, dynamic>> fetchFavoriteProperty(data, url) async {
    var response;
    print("data is: " + data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
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
  static Future<Map<String, dynamic>> fetchFavoritePropertyListDetails(
      data, url) async {
    var response;
    print("data is: " + data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
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
  static Future<Map<String, dynamic>> fetchVisitRequestedList(data, url) async {
    var response;
    //print("data is: "+data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
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
  static Future<Map<String, dynamic>> fetchVisitRequestedPropertyDetails(
      data, url) async {
    var response;
    print("data is: " + data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
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
    print('inside the open map url is $url');
    // Use the URL format for opening a map with coordinates
    String mapUrl = url;

    // Launch the map with the provided URL
    if (!await launchUrl(Uri.parse(mapUrl),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch the map.';
    }
  }

  //=======================LOGOUT METHOD======================================
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

    appState.activeWidget = "PropertyListWidget";
    appState.currentState = 0;

    await appState.fetchUserType();
    Future.delayed(const Duration(milliseconds: 100));

    appState.fetchToken(appState.userType);
    Future.delayed(const Duration(milliseconds: 100));
  }

  //============================================================filter property method
  static void filterProperties(
    appState, {
    String selectedCity = "",
    String selectedPropertyType = "All",
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
  }) {

    print('------------------------filter method called------------------');
    print('property type is : ${selectedPropertyType}');
    print('property bhk is : ${selectedBhk}');
    print('property floor is : ${selectedFloor}');
    print('property garden is : ${selectedGarden}');
    print('property parking is : ${selectedParking}');
    print('property furnish is : ${selectedFurnished}');
    print('property availbable is : ${selectedAvailability}');
    print('property name is : ${propertyName}');
    print('property city is : ${selectedCity}');
    print('------------------------------------------------------------');

    appState.filteredPropertyList = appState.propertyList.length != 0
        ? appState.propertyList.where((property) {
            final String name = property['property_name'].toLowerCase();
            final String type = property['property_type'].toLowerCase();
            final String garden = property['property_isGarden'].toLowerCase();
            final String parking = property['property_isParking'].toLowerCase();
            final String furnished = property['property_isFurnished'].toLowerCase();
            final String available = property['property_isAvailable'].toLowerCase();
            final String city = property['property_city'].toLowerCase();

            bool isTypeMatch = selectedPropertyType=="All" || type==selectedPropertyType.toLowerCase();
            bool isBhkMatch = selectedBhk == 0 ? true : property['property_bhk'] == selectedBhk ;
            bool isFloorMatch = selectedFloor == 0 ? true : property['property_floor'] == selectedFloor;
            bool isGardenMatch = selectedGarden=="None" || garden==selectedGarden.toLowerCase();
            bool isParkingMatch = selectedParking=="None" || parking==selectedParking.toLowerCase();
            bool isFurnishMatch = selectedFurnished=="None" || furnished==selectedFurnished.toLowerCase();
            bool isAvailabilityMatch =  selectedAvailability=="None" || available==selectedAvailability.toLowerCase();
            bool isPriceMatch = property['property_price'] >= minPrice && property['property_price'] <= maxPrice;
            bool isIdMatch =  propertyId != 0 ? property['property_id'] == propertyId : property['property_id'] > 0;
            bool isCityMatch = selectedCity=="" || city.contains(selectedCity.toLowerCase());
            bool isNameMatch = propertyName=="" || name.contains(propertyName.toLowerCase());

            return (isTypeMatch)
                && (isBhkMatch)
                && (isFloorMatch)
                 && (isGardenMatch)
                 && (isParkingMatch)
                 && (isFurnishMatch)
                 && (isAvailabilityMatch)
                 && (isPriceMatch)
                 && (isIdMatch)
                 && (isCityMatch)
                && (isNameMatch);
          }).toList()
        : [];
  }

  //----------------------------------------------------------------------------submit property rating
  static Future<Map<String, dynamic>> submitPropertyRating(data, url) async {
    var response;
    print("data is: " + data.toString());
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
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
  static Future<Map<String, dynamic>> fetchAdminContact(url) async {
    var response;
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete fetchAdminContact api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting admin contact'
      };
    }
  }

  //============================================================================FETCH OFFER LIST
  static Future<Map<String, dynamic>> fetchOfferList(url) async {
    var response;
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete fetchOfferList api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting offer list'
      };
    }
  }

  //============================================================================FETCH CUSTOMER REQUEST
  static Future<Map<String, dynamic>> fetchCustomerRequest(url) async {
    var response;
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete fetchCustomerRequest api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting customer Request list'
      };
    }
  }

  //============================================================filter customer request method
  static void filterCustomerRequest(
    appState, {
    int selectedRequestStatus = 4,
  }) {
    appState.filteredCustomerRequestList =
        appState.customerRequestList.where((property) {
      int status = property['v_status'];

      return (selectedRequestStatus != 4
          ? status == selectedRequestStatus
          : status < selectedRequestStatus);
    }).toList();
  }

  //----------------------------------------------------------------------------Change Visit Status
  static Future<Map<String, dynamic>> changeVisitStatus(data, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.put(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete changeVisitStatus api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for changeVisitStatus api'
      };
    }
  }

  //----------------------------------------------------------------------------Insert property
  static Future<Map<String, dynamic>> insertProperty(data, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete insertProperty api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while requesting for insertProperty api'
      };
    }
  }

  //----------------------------------------------------------------------------delete property image
  static Future<Map<String, dynamic>> deletePropertyImage(data, url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res =
          await http.post(url, body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete deletePropertyImage api');
      print(e.toString());
      return {
        "success": false,
        "message":
            'An error occured while requesting for deletePropertyImage api'
      };
    }
  }
}
