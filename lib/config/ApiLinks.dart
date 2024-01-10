class ApiLinks{
  static const baseUrl = "https://9c197129974ecbbcdbf7390aa499593b.serveo.net/";

  //==================================CUSTOMER API==================================
  static const customerSignup = "${baseUrl}api/customer/customerSignup";
  static const customerLogin = "${baseUrl}api/customer/customerLogin";
  static const customerProfile = "${baseUrl}api/customer/customerProfile";
  static const sendOtpForLogin = "${baseUrl}api/customer/sendOtpForLogin";
  static const verifyOtpForLogin = "${baseUrl}api/customer/verifyOtpForLogin";
  static const addToFavorite = "${baseUrl}api/customer/addToFavorite";
  static const removeFromFavorite = "${baseUrl}api/customer/removeFromFavorite";
  static const fetchFavoriteProperty = "${baseUrl}api/customer/fetchFavoriteProperty";
  static const fetchFavoritePropertyListDetails = "${baseUrl}api/customer/fetchFavoritePropertyListDetails";
  static const fetchVisitRequestedList = "${baseUrl}api/customer/fetchVisitRequestedList";
  static const fetchVisitRequestedPropertyDetails = "${baseUrl}api/customer/fetchVisitRequestedPropertyDetails";
  static const submitPropertyRating = "${baseUrl}api/customer/submitPropertyRating";
  static const uploadProfilePic = "${baseUrl}api/customer/uploadProfilePic";
  static const accessCustomerProfilePic = "${baseUrl}api/customer/accessCustomerProfilePic";

  //==================================ADMIN API================================
  static const fetchAdminContact = "${baseUrl}api/admin/fetchAdminContact";

  //=================================VISIT API=================================
  static const requestVisit = "${baseUrl}api/visit/requestVisit";


  //=================================PROPERTY API================================
  static const fetchAllProperties = "${baseUrl}api/property/fetchAllProperties";
  static const accessPropertyImages = "${baseUrl}api/property/accessPropertyImages";


}