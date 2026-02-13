class ApiConstant {
  static const String BASE_URL = 'https://v2.radeefz.com/api/v1';

  static const String imageBaseUrl = 'https://v2.radeefz.com/';

  static const String googleApiKey = "AIzaSyBRiTsXAZERl87rSPcgdqw3R-EOAcJ-ehw";

  static String googleBaseUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  static String findPlaceApiUrl =
      "https://maps.googleapis.com/maps/api/place/findplacefromtext/json";

  static const requestTripUrl = "/trips/new-trip-request";
  static const cancelTripUrl = "/trips/cancel-trip";
  static const payForTrip = "/trips/pay-trip";
  static const updateDriverLocation = "/drivers/update-location";
  static const acceptTripRequestForDriver = "/trips/accept-trip-request";
  static const cancelTripRequestForDriver = "/trips/cancel-trip-request";
  static const startedTripForDriver = "/trips/start-trip";
  static const endTripForDriver = "/trips/end-trip";
}
