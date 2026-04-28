
class  ApiList {
  static const String apiKey = "CjZOpa8ZMhwtSB5N";

  //TODO: ----------------------------- Clint URL -----------------------------

  //TODO: Local URL
  static String get baseURL => "http://192.168.1.9:8000/api/v1";

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
  static String get urlRegister => "$baseURL/auth/sign-up";
  static String get urlLogout => "$baseURL/auth/logout";
  static String get urlBlogDetail => "$baseURL/blog-details";
  static String get urlAboutUs => "$baseURL/about-us";

  //TODO USER API LIST
  static String get urlUserDashboard => "$baseURL/auth/dashboard-overview";
  static String get urlMenu => "$baseURL/auth/get-menus";
}
