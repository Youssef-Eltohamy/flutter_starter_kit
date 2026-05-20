class ApiKeys {
  /// KEYs

  static const authorization = "Authorization";
  static const accept = "Accept";
  static const platform = "Platform";
  static const mode = "Buyer-App-Mode";
  static const platformAndroid = "android";
  static const platformIos = "ios";
  static const appVersion = "App-Version";
  static const applicationJson = "application/json";
  static const locale = "Accept-Language";
  static const contentType = "Content-Type";
  static const keyBearer = "Bearer";
  static const lat = "Current-Selected-Latitude";
  static const lng = "Current-Selected-Longitude";
  static const pageNumber = "PageNumber";
  static const pageSize = "PageSize";
  static const categoryId = "CategoryId";
  static const notValid = "NotValid";

  static const clientMode = 1;
  static const businessMode = 2;

  /// map kay
  static const googleMapsApiKey = "AIzaSyC9KEnXSaS08f3r0pT1qVuEMhoKzLHi5_o";

  /// URLs
  static const baseUrlProduction =
      "https://oyn-gateway-c3wcsxgmhq-ew.a.run.app/";
  static const baseUrlQc =
      "https://oyn-gateway-qc.salmonsky-1edff179.westeurope.azurecontainerapps.io/";
  static const baseUrlDev =
      "https://oyn-gateway-dev.nicewater-75de7f47.westeurope.azurecontainerapps.io/";

  static const apiKeyUrl = "api";
  static const baseApiUrl = '/$apiKeyUrl';

  static const sentOtpUrl = '/Identity/api/Account/CheckLogin';
  static const loginUrl = '/Identity/api/Account/Login';

  /// account setting
  static const deleteAccountUrl = '/Identity/api/Account/Delete';
  static const userInfoUrl = '/UserManagement/api/Profile/Get';
  static const updateUserFullNameInfoUrl =
      '/UserManagement/api/Profile/ChangeData';
  static const checkPhoneUrl = '/UserManagement/api/Profile/CheckPhone';
  static const changePhoneUrl = '/UserManagement/api/Profile/ChangePhone';
  static const getNotificationSettingUrl =
      '/Notification/api/UserPreference/GetPushNotificationSetting';
  static const updateNotificationSettingUrl =
      '/Notification/api/UserPreference/SavePushNotificationSetting';

  static String updateNotificationUrl(bool getNotification) =>
      '$updateNotificationSettingUrl/$getNotification';

  static const updateLanguageSettingUrl =
      '/Notification/api/UserPreference/SavePreferredLanguage';

  static String updateLanguageUrl(int languageNumber) =>
      '$updateLanguageSettingUrl/$languageNumber';

  static const homeLookupsUrl = '$baseApiUrl/Product/GetLookups';
  static const homeOffersUrl = '$baseApiUrl/Offer/Get';
  static const productDetailsUrl = '$baseApiUrl/Product/Get';
  static const productsOfCategoryUrl = '$baseApiUrl/Product/Get';
  static const similarProductListUrl = '$baseApiUrl/Product/GetSimilar';

  /// addresses
  static const allAddressesUrl = 'Ecommerce/api/Address/Get';
  static const addAddressesUrl = 'Ecommerce/api/Address/Add';
  static const updateAddressesUrl = 'Ecommerce/api/Address/Update';
  static const deleteAddressesUrl = 'Ecommerce/api/Address/Delete/';
  static const setMainAddressesUrl = 'Ecommerce/api/Address/SetAsMainAddress/';
  static const getMainAddressesUrl = 'Ecommerce/api/Address/GetMainAddress/';

  // home
  static const getMostOrdersUrl =
      '/StockManagement/api/ProductCatalog/GetMostOrdered';

  static const getProductUrl = '/StockManagement/api/ProductCatalog/Get';

  static const getNewItemsUrl =
      '/StockManagement/api/ProductCatalog/GetNewItems';

  static const getCategoriesUrl =
      '/StockManagement/api/ProductCatalog/LoadCategories';

  static const homePromotionUrl = '/StockManagement/api/Promotion/GetBanners';

  static const getStatus = '/UserManagement/api/BusinessAccount/GetStatus';
  static const getCaptionsUrl = '/Utilities/api/Caption/LoadCaptions/2';

  static const eWallet = '/Payment/api/Wallet/MyBalance';

  static const logout = 'Identity/api/Account/Logout';

  static const addToCartUrl = '/StockManagement/api/Cart/Save';
  static const clearCartUrl = '/StockManagement/api/Cart/Clear';
  static const getCartListUrl = '/StockManagement/api/Cart/GetItems';
  static const getPackageCartListUrl = '/StockManagement/api/Cart/Get';
  static const getPackageListUrl = '/StockManagement/api/Cart/Get';

  static String productDetailsById(int productId) =>
      '$productDetailsUrl/$productId';

  static String similarProductListById(int productId, {int count = 4}) =>
      '$similarProductListUrl/$productId/$count';

  static const uploadFileUrl = "/FileService/api/Attachment/Upload";
  static const completeInfo =
      "/UserManagement/api/BusinessAccount/CompleteInfo";

  static const getAvailableDaysUrl = "/Ecommerce/api/Order/GetAvailableDays";
  static const getAvailableSlotsUrl = "/Ecommerce/api/Order/GetAvailableSlots";
  static const getOrderUrl = '/Ecommerce/api/Order/Get';
  static const placeOrderUrl = '/Ecommerce/api/Order/Place';
  static const cancelOrderUrl = '/Ecommerce/api/Order/Cancel';
  static const cancelPackageUrl = '/Ecommerce/api/Order/CancelPackage';
  static const returnOrderUrl = '/Ecommerce/api/Order/ReturnRequest';
  static const getFaqCategoriesUrl = '/Utilities/api/FAQCategory/GetAll';
  static const getFaqUrl = '/Utilities/api/FAQQuestion/GetAll';

  static const registerGuestTokenUrl =
      "/Notification/api/DevicePushToken/RegisterGuest";
  static const registerTokenUrl = "/Notification/api/DevicePushToken/Register";
}
