class ApiConstants {
  static const String baseUrl = 'http://192.168.198.155:8000/api';
  static const String nearbyBranches = '/branches/nearby';
  static const String restaurants = '/restaurants';

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

  //: Cart Api
  static const String addToCart = "/cart/add";
  static const String getCartPackages = "/cart/packages";
  static const String updateCartItem = "/cart/item/"; // يتبعه ID
  static const String removeCartItem = "/cart/items/"; // يتبعه ID
}
