import 'package:http/http.dart' as http;
import 'dart:convert';

// AIzaSyB-Z0iPVSaTtvVnFYUEaZJeS6perQNQreo
const String apiKeyGoogleMaps = "[PLACES_API]";

class RetriveDataFromGoogleMaps {
  static Future retriveDataFromGoogleMaps(
    String query,
    String returnData,
  ) async {
    Uri url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address&input=$query&inputtype=textquery&key=$apiKeyGoogleMaps",
    );
    var response = await http.get(
      url,
    );
    final decodedData = jsonDecode(response.body);

    if (decodedData["status"] == "OK") {
      returnData = decodedData["candidates"][0]["formatted_address"];
      return returnData;
    } else {
      returnData = "Not Found";
      return returnData;
    }
  }

  static Future retrivePointOfInterest(
    String query,
    List returnData,
  ) async {
    Uri url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query%20point%20of%20interest&key=$apiKeyGoogleMaps");
    var response = await http.get(
      url,
    );
    final decodedData = jsonDecode(response.body);
    if (decodedData["status"] == "OK") {
      returnData = decodedData["results"];
      return returnData;
    } else {
      returnData = [
        {"name": "None Found", "formatted_address": "None Found"}
      ];
      return returnData;
    }
  }
}
