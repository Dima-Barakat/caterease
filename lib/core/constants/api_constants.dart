class ApiConstants {
  //:Base Url
  // static const String baseUrl = 'http://192.168.43.2:8000/api';
  //:Base Url
  static const String baseUrl = "http://10.0.2.2:8000/api";
  //:Image Url
  static const String imageUrl = "http://10.0.2.2:8000";

  //! Authentication
  //: Login Api
  static const String login = "$baseUrl/login";
  //: Register Api
  static const String register = "$baseUrl/register";
  //: Verify OTP Api
  static const String verifyOtp = "$baseUrl/verify-otp";
  //: Forget Password
  static const String forgetPassword = "$baseUrl/forgot-password/send-otp";
  //: Reset Password
  static const String resetPassword = "$baseUrl/forgot-password/reset";

  //! Customer section
  
  //- Profile:
  //: get
  static const String customerProfile = "$baseUrl/customer/show";
  //: Update
  static const String updateCustomerProfile = "$baseUrl/customer/update";
  //: Update Password
  static const String updateCustomerPassword = "$baseUrl/customer/update-password";

  //- Addresses:
  //: get all
  static const String getAllAddress = "$baseUrl/customer/list-addresses";
  //: create
  static const String createAddress = "$baseUrl/customer/creat";
  //: delete
  static const String deleteAddress = "$baseUrl/customer/delete_addresse/";
  //: get nearby branches
  static const String nearbyBranches = '/branches/nearby';
  //: get all restaurants
  static const String restaurants = '/restaurants';
}
