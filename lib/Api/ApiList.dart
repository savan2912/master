
class  ApiList {
  static const String apiKey = "CjZOpa8ZMhwtSB5N";

  //TODO: ----------------------------- Clint URL -----------------------------

  //TODO: Local URL
  static String get baseURL => "http://192.168.1.39:8000/api/v1";



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
}
