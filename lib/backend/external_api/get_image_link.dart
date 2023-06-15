import 'package:http/http.dart' as http;
import 'dart:convert';

class RetriveLink {
  static Future retriveLink(String query, List unsplashData) async {
    Uri url = Uri.parse(
      "https://api.unsplash.com/search/photos?query=${query.toLowerCase()}&client_id=[UNSPLASH_API_KEYS]",
    );
    var response = await http.get(
      url,
    );
    final decodedData = jsonDecode(response.body);
    if (decodedData["total"] == 0 && response.statusCode == 200) {
      unsplashData = ["", ""];
      return unsplashData;
    } else {
      if (response.statusCode == 200) {
        var allLinks = decodedData["results"][0]["urls"]["full"];
        var userDetails = decodedData["results"][0]["user"]["username"];
        unsplashData = [allLinks, userDetails];
        return unsplashData;
      }
    }
    return ["", ""];
  }
}
