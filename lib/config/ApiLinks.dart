class ApiLinks{
  //static const baseUrl = "http://54.82.47.83.nip.io:5000/";
  static const baseUrl = "https://ef87-2401-4900-51fc-43ac-5018-9e88-11cb-988c.ngrok-free.app/";

  //==================================CUSTOMER API==================================
  static const customerSignup = "${baseUrl}api/customer/customerSignup";
  static const sendOtpForSignup = "${baseUrl}api/customer/sendOtpForSignup";
  static const updateCustomerDetails = "${baseUrl}api/customer/updateCustomerDetails";
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
  static const fetchOffer = "${baseUrl}api/customer/fetchOffer";
  static const fetchAdminContact = "${baseUrl}api/customer/fetchAdminContact";

  static const addToFavorite = "${baseUrl}api/customer/addToFavorite";
  static const removeFromFavorite = "${baseUrl}api/customer/removeFromFavorite";
  static const fetchFavoriteProperty = "${baseUrl}api/customer/fetchFavoriteProperty";
  static const fetchFavoritePropertyListDetails = "${baseUrl}api/customer/fetchFavoritePropertyListDetails";

  static const requestVisit = "${baseUrl}api/customer/requestVisit";
  static const fetchVisitRequestedList = "${baseUrl}api/customer/fetchVisitRequestedList";
  static const fetchVisitRequestedPropertyDetails = "${baseUrl}api/customer/fetchVisitRequestedPropertyDetails";
  static const cancelVisitRequest = "${baseUrl}api/customer/cancelRequest";
  
  static const fetchBlog = "${baseUrl}api/customer/fetchBlog";

  //==================================ADMIN API================================
  static const insertPropertyDetails = "${baseUrl}api/admin/insertPropertyDetails";
  static const insertProjectDetails = "${baseUrl}api/admin/insertProjectDetails";
  static const fetchProject = "${baseUrl}api/admin/fetchProject";
  static const fetchProjectWithPagination = "${baseUrl}api/admin/fetchProjectWithPagination";
  static const changePropertyAvailability = "${baseUrl}api/admin/changePropertyAvailability";
  static const uploadOffer = "${baseUrl}api/admin/uploadOffer";
  static const deleteOffer = "${baseUrl}api/admin/deleteOffer";
  static const accessOfferImage = "${baseUrl}api/offer/accessOfferImage";
  static const uploadPropertyImage = "${baseUrl}api/admin/uploadPropertyImage";
  static const deletePropertyImage = "${baseUrl}api/admin/deletePropertyImage";
  static const fetchCustomerRequest = "${baseUrl}api/admin/fetchCustomerRequest";
  static const sendOtpForAdminLogin = "${baseUrl}api/admin/sendOtpForAdminLogin";
  static const verifyOtpForAdminLogin = "${baseUrl}api/admin/verifyOtpForAdminLogin";
  static const adminProfile = "${baseUrl}api/admin/adminProfile";
  static const changeVisitStatus = "${baseUrl}api/admin/changeVisitStatus";
  static const uploadAdminProfilePic = "${baseUrl}api/admin/uploadAdminProfilePic";
  static const fetchCustomerList = "${baseUrl}api/admin/fetchAllCustomerList";
  static const fetchEmployeeList = "${baseUrl}api/admin/fetchAllEmployeeList";
  static const postBlog ="${baseUrl}api/admin/postBlog";
  static const accessAdminProfilePic = "";
  
  
  //===========================EMPLOYEE API====================================
  static const sendOtpForEmployeeSignup = "${baseUrl}api/employee/sendOtpForEmployeeSignup";
  static const verifyOtpForEmployeeSignup = "${baseUrl}api/employee/verifyOtpForEmployeeSignup";
  static const sendOtpForEmployeeLogin = "${baseUrl}api/employee/sendOtpForEmployeeLogin";
  static const verifyOtpForEmployeeLogin = "${baseUrl}api/employee/verifyOtpForEmployeeLogin";
  static const employeeProfile = "${baseUrl}api/employee/employeeProfile";




}