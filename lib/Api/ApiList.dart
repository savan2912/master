
class  ApiList {
  static const String apiKey = "CjZOpa8ZMhwtSB5N";

  //TODO: ----------------------------- Clint URL -----------------------------

  //TODO: Local URL
  static String get baseURL => "http://192.168.1.43:8000/api/v1";
  // static String get baseURL => "https://gotilo.net/api/v1";

  //TODO: -------------------------------- App URL --------------------------------

  static String get urlHomeBanner => "$baseURL/get-slider";
  static String get urlHomeCollection => "$baseURL/explore-category";
  static String get urlHomeLatestListing => "$baseURL/latest-listings";
  static String get urlHomeLatestRelease => "$baseURL/nearby-listings";
  static String get urlHomeService => "$baseURL/featured-services";
  static String get urlHomeDeal => "$baseURL/nearby-deals";
  static String get urlHome => "$baseURL/home";
  static String get urlCity => "$baseURL/city/list";
  static String get urlAllCollection => "$baseURL/all-categories";
  static String get urlDeleteUser => "$baseURL/auth/delete-user";
  static String get urlAllLatestRelease => "$baseURL/nearby-listings";
  static String get urlAllNewlyAdded => "$baseURL/latest-listings";
  static String get urlAllService => "$baseURL/featured-services";
  static String get urlAllDeals => "$baseURL/all-deals";
  static String get urlCollectionDetail => "$baseURL/categories/childes";
  static String get urlCollectionProductList => "$baseURL/users/product-list";
  static String get urlAllListings => "$baseURL/listing/list-api";
  static String get urlSubCategoryList => "$baseURL/categories/subcategorylist";
  static String get urlSubCategoryListDetails => "$baseURL/listing/listing-details";
  static String get urlSubCategoryProductList => "$baseURL/listing/listing-products";
  static String get urlSearch => "$baseURL/listing/search";
  static String get urlBlogs => "$baseURL/blogs";
  static String get urlPrisePlan => "$baseURL/pricing-plans";
  static String get urlLogin => "$baseURL/auth/login";
  static String get urlLoginOtp => "$baseURL/auth/verify-login-otp";
  static String get urlRegister => "$baseURL/auth/sign-up";
  static String get urlLogout => "$baseURL/auth/logout";
  static String get urlBlogDetail => "$baseURL/blog-details";
  static String get urlAddCart => "$baseURL/add-to-cart";
  static String get urlAddEnquiry => "$baseURL/users/enquiry-create";
  static String get urlProductDetail => "$baseURL/product-details";
  static String get urlCartItem => "$baseURL/get-cart-list";
  static String get urlUpdateCart => "$baseURL/update-cart-item";
  static String get urlCartAddress => "$baseURL/get-addresses";
  static String get urlCartDelete => "$baseURL/delete-cart-item";
  static String get urlPlaceOrder => "$baseURL/place-order";
  static String get urlAboutUs => "$baseURL/about-us";
  static String get urlSendOtp => "$baseURL/send-otp";
  static String get urlVerifyOtp => "$baseURL/verify-otp";
  static String get urlResetPassword => "$baseURL/reset-password";
  static String get urlAddFav => "$baseURL/users/userfavourites";
  static String get urlReview => "$baseURL/reviewshow";
  static String get urlAddReview => "$baseURL/reviewadd";
  static String get urlShare => "$baseURL/share-listing";
  static String get urlCrackDeal => "$baseURL/users/add-crack-deal";
  static String get urlSimilarListing => "$baseURL/listing/similar-nearby-listing";
  static String get urlBecomeVendor => "$baseURL/become-a-vendor";

  //TODO USER API LIST
  static String get urlUserDashboard => "$baseURL/auth/dashboard-overview";
  static String get urlMenu => "$baseURL/auth/get-menus";
  static String get urlNotification => "$baseURL/auth/notifications";
  static String get urlProfile => "$baseURL/auth/user-profile-detail";
  static String get urlMyOrder => "$baseURL/auth/user-orders";
  static String get urlMyOrderDetail => "$baseURL/auth/order-details";
  static String get urlUserDeal => "$baseURL/users/pending-deal";
  static String get urlCrackedDeal => "$baseURL/users/cracked-deal";
  static String get urlBilling => "$baseURL/auth/billing";
  static String get urlBillHistory => "$baseURL/auth/bill-history";
  static String get urlBookingHistory => "$baseURL/auth/booking-history";
  static String get urlBookingHistoryDetail => "$baseURL/auth/booking-details";
  static String get urlUserPoint => "$baseURL/auth/user-points";
  static String get urlUserPointDetail => "$baseURL/auth/user-point-details";
  static String get urlFavData => "$baseURL/auth/user-favourite";
  static String get urlFavDelete => "$baseURL/auth/remove-favourite";
  static String get urlHotelBooking => "$baseURL/auth/hotel-booking-history";
  static String get urlHotelBookingDetail => "$baseURL/auth/hotel-booking-details";
  static String get urlHotelBookingCancellation => "$baseURL/auth/hotel-booking-cancelation";
  static String get urlHotelBookingRoomHistory => "$baseURL/auth/booking-room-history";
  static String get urlHotelBookingServiceHistory => "$baseURL/auth/booking-additional-service-history";
  static String get urlHotelBookingRoomPricePlan => "$baseURL/auth/booking-room-plan-price";
  static String get urlHotelBookingCancellationHistory => "$baseURL/auth/booking-cancelation-history";
  static String get urlProfileAddress => "$baseURL/auth/address-list";
  static String get urlEditAddress => "$baseURL/auth/add-or-update-address";
  static String get urlDeleteAddress => "$baseURL/auth/delete-address";
  static String get urlChangePassword => "$baseURL/auth/update-password";
  static String get urlUpdatePassword => "$baseURL/auth/user-profile-update";

}
