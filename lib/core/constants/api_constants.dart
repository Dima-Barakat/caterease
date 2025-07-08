class ApiConstants {
  //:Base Url
  // static const String baseUrl = 'http://192.168.43.2:8000/api';

  //:Base Url
  static const String baseUrl = "http://10.0.2.2:8000/api";

  //: Login Api
  static const String login = "$baseUrl/login";

  //: Register Api
  static const String register = "$baseUrl/register";

  //: Verify OTP Api
  static const String verifyOtp = "$baseUrl/verify-otp";

  //! Customer section
  //: get Profile details
  static const String customerProfile = "$baseUrl/customer/show";

  //: Update Profile details
  static const String updateCustomerProfile = "$baseUrl/";

  //: get nearby branches
  static const String nearbyBranches = '/branches/nearby';

  //: get all restaurants
  static const String restaurants = '/restaurants';
}
