class ApiLinks{
  //static const baseUrl = "http://54.82.47.83.nip.io:5000/";
  static const baseUrl = "https://75e0-2401-4900-51e2-90d0-3971-712a-6fd6-2c82.ngrok-free.app/";

  //==================================CUSTOMER API==================================
  static const customerSignup = "${baseUrl}api/customer/customerSignup";
  static const sendOtpForSignup = "${baseUrl}api/customer/sendOtpForSignup";
  static const verifyOtpForSignup = "${baseUrl}api/customer/verifyOtpForSignup";
  static const customerLogin = "${baseUrl}api/customer/customerLogin";
  static const sendOtpForLogin = "${baseUrl}api/customer/sendOtpForLogin";
  static const customerProfile = "${baseUrl}api/customer/customerProfile";
  static const verifyOtpForLogin = "${baseUrl}api/customer/verifyOtpForLogin";
  static const uploadCustomerProfilePic = "${baseUrl}api/customer/uploadCustomerProfilePic";
  static const accessCustomerProfilePic = "${baseUrl}api/customer/accessCustomerProfilePic";

  static const fetchAllProperties = "${baseUrl}api/customer/fetchAllProperties";
  static const fetchAllPropertiesWithPaginationAndFilter = "${baseUrl}api/customer/fetchAllPropertiesWithPaginationAndFilter";
  static const fetchSinglePropertyById = "${baseUrl}api/customer/fetchSinglePropertyById";
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
  static const insertPropertyDetails = "${baseUrl}api/admin/insertPropertyDetails";
  static const uploadOffer = "${baseUrl}api/admin/uploadOffer";
  static const accessOfferImage = "${baseUrl}api/offer/accessOfferImage";
  static const uploadPropertyImage = "${baseUrl}api/admin/uploadPropertyImage";
  static const deletePropertyImage = "${baseUrl}api/admin/deletePropertyImage";
  static const fetchCustomerRequest = "${baseUrl}api/admin/fetchCustomerRequest";
  static const sendOtpForAdminLogin = "${baseUrl}api/admin/sendOtpForAdminLogin";
  static const verifyOtpForAdminLogin = "${baseUrl}api/admin/verifyOtpForAdminLogin";
  static const adminProfile = "${baseUrl}api/admin/adminProfile";
  static const changeVisitStatus = "${baseUrl}api/admin/changeVisitStatus";
  static const uploadAdminProfilePic = "${baseUrl}api/admin/uploadAdminProfilePic";
  static const accessAdminProfilePic = "";




}