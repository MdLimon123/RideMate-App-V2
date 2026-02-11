class ApiConstant {
  static const String BASE_URL = 'http://10.10.12.126:3008/api/v1';

  static const String imageBaseUrl = 'http://10.10.12.126:3008';

  static const String googleApiKey = "AIzaSyBRiTsXAZERl87rSPcgdqw3R-EOAcJ-ehw";

  static String googleBaseUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  static String findPlaceApiUrl =
      "https://maps.googleapis.com/maps/api/place/findplacefromtext/json";

  static const requestTripUrl = "/trips/new-trip-request";
  static const cancelTripUrl = "/trips/cancel-trip";
  static const payForTrip = "/trips/pay-trip";
  static const updateDriverLocation = "/drivers/update-location";
}
