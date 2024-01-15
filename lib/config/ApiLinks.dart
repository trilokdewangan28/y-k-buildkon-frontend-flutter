class ApiLinks{
  static const baseUrl = "https://372f-2401-4900-7b10-85ab-9179-98a8-2b38-108a.ngrok-free.app/";

  //==================================CUSTOMER API==================================
  static const customerSignup = "${baseUrl}api/customer/customerSignup";
  static const customerLogin = "${baseUrl}api/customer/customerLogin";
  static const sendOtpForLogin = "${baseUrl}api/customer/sendOtpForLogin";
  static const customerProfile = "${baseUrl}api/customer/customerProfile";
  static const verifyOtpForLogin = "${baseUrl}api/customer/verifyOtpForLogin";
  static const uploadCustomerProfilePic = "${baseUrl}api/customer/uploadProfilePic";
  static const accessCustomerProfilePic = "${baseUrl}api/customer/accessCustomerProfilePic";

  static const fetchAllProperties = "${baseUrl}api/customer/fetchAllProperties";
  static const accessPropertyImages = "${baseUrl}api/property/accessPropertyImages";
  static const submitPropertyRating = "${baseUrl}api/customer/submitPropertyRating";
  static const fetchOfferList = "${baseUrl}api/customer/fetchOfferList";
  static const fetchAdminContact = "${baseUrl}api/customer/fetchAdminContact";

  static const addToFavorite = "${baseUrl}api/customer/addToFavorite";
  static const removeFromFavorite = "${baseUrl}api/customer/removeFromFavorite";
  static const fetchFavoriteProperty = "${baseUrl}api/customer/fetchFavoriteProperty";
  static const fetchFavoritePropertyListDetails = "${baseUrl}api/customer/fetchFavoritePropertyListDetails";

  static const requestVisit = "${baseUrl}api/customer/requestVisit";
  static const fetchVisitRequestedList = "${baseUrl}api/customer/fetchVisitRequestedList";
  static const fetchVisitRequestedPropertyDetails = "${baseUrl}api/customer/fetchVisitRequestedPropertyDetails";


  //==================================ADMIN API================================
  static const uploadOfferImages = "${baseUrl}api/admin/uploadOfferImages";
  static const fetchCustomerRequest = "${baseUrl}api/admin/fetchCustomerRequest";
  static const sendOtpForAdminLogin = "${baseUrl}api/admin/sendOtpForAdminLogin";
  static const verifyOtpForAdminLogin = "${baseUrl}api/admin/verifyOtpForAdminLogin";
  static const adminProfile = "${baseUrl}api/admin/adminProfile";
  static const changeVisitStatus = "${baseUrl}api/admin/changeVisitStatus";
  static const uploadAdminProfilePic = "";
  static const accessAdminProfilePic = "";




}