import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class FatSecretApi {

  final String fatSecretApiBaseUrl = "platform.fatsecret.com";

  bool isJson = true;

  final String consumerKey, consumerKeySecret, accessToken, accessTokenSecret;

  late Hmac _sigHasher;

  FatSecretApi(this.consumerKey, this.consumerKeySecret, this.accessToken,
      this.accessTokenSecret) {
    var bytes = utf8.encode("$consumerKeySecret&$accessTokenSecret");
    _sigHasher = Hmac(sha1, bytes);
  }

  FatSecretApi forceXml() {
    isJson = false;
    return this;
  }

  /// Sends a tweet with the supplied text and returns the response from the Twitter API.
  Future<http.Response> request(Map<String, dynamic> data) {
    if (isJson) {
      data["format"] = "json";
    }
    return _callGetApi("rest/server.api", data);
  }


  Future<http.Response> _callGetApi(String url, Map<String, dynamic> data) {
    Uri requestUrl = Uri.https(fatSecretApiBaseUrl, url);

    print(data["method"]);
    print("This is request URL - $requestUrl");
    _setAuthParams("GET", requestUrl.toString(), data);

    requestUrl = Uri.https(requestUrl.authority, requestUrl.path, data);

    String oAuthHeader = _generateOAuthHeader(data);

    // Build the OAuth HTTP Header from the data.
    // Build the form data (exclude OAuth stuff that's already in the header).
//    var formData = _filterMap(data, (k) => !k.startsWith("oauth_"));
    return _sendGetRequest(requestUrl, oAuthHeader);
  }

  void _setAuthParams(String requestMethod, String url, Map<String, dynamic> data) {

    // Timestamps are in seconds since 1/1/1970.
    // var timestamp = new DateTime.now().toUtc().difference(_epochUtc).inSeconds;
    var millisecondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;
    var timestamp = (millisecondsSinceEpoch  / 100).round();

    // Add all the OAuth headers we'll need to use when constructing the hash.
    data["oauth_consumer_key"] = consumerKey;
    data["oauth_signature_method"] = "HMAC-SHA1";
    data["oauth_timestamp"] = timestamp.toString();
    data["oauth_nonce"] = _randomString(8); // Required, but Twitter doesn't appear to use it
    if (accessToken.isNotEmpty) data["oauth_token"] = accessToken;
    data["oauth_version"] = "1.0";

    // Generate the OAuth signature and add it to our payload.
    data["oauth_signature"] = _generateSignature(requestMethod, Uri.parse(url), data);

  }

  /// Generate an OAuth signature from OAuth header values.
  String _generateSignature(String requestMethod, Uri url, Map<String, dynamic> data) {
    var sigString = _toQueryString(data);
    var fullSigData = "$requestMethod&${_encode(url.toString())}&${_encode(sigString)}";

    return base64.encode(_hash(fullSigData));
  }

  /// Generate the raw OAuth HTML header from the values (including signature).
  String _generateOAuthHeader(Map<String, dynamic> data) {
    var oauthHeaderValues = _filterMap(data, (k) => k.startsWith("oauth_"));

    return "OAuth ${_toOAuthHeader(oauthHeaderValues)}";
  }

  /// Send HTTP Request and return the response.
  Future<http.Response> _sendGetRequest(Uri fullUrl, String oAuthHeader) async {
    return await http.get(fullUrl, headers: { });
  }

  Map<String, String> _filterMap(
      Map<String, dynamic> map, bool Function(String key) test) {
    return Map.fromIterable(map.keys.where(test), value: (k) => map[k] ?? "");
  }

  String _toQueryString(Map<String, dynamic> data) {
    var items = data.keys.map((k) => "$k=${_encode(data[k]!)}").toList();
    items.sort();

    return items.join("&");
  }

  String _toOAuthHeader(Map<String, String> data) {
    var items = data.keys.map((k) => "$k=\"${_encode(data[k]!)}\"").toList();
    items.sort();

    return items.join(", ");
  }

  List<int> _hash(String data) => _sigHasher.convert(data.codeUnits).bytes;

  String _encode(String data) => percent.encode(data.codeUnits);

  String _randomString(int length) {
    var rand = Random();
    var codeUnits = List.generate(
        length,
            (index){
          return rand.nextInt(26)+97;
        }
    );

    return String.fromCharCodes(codeUnits);
  }
}

class RestClientFatSecreet {
  // if  you don't have one, generate from fatSecret API
  String consumerKey = "KEY";

  // if  you don't have one, generate from fatSecret API
  String consumerKeySecret = "KEY";

  // creates a new RestClient instance.
  // try to make singleton too avoid multiple instances
  // make sure to set AppConfig consumer keys and secrets.


  /*
   * Sends an API call to "food.search" method on fatSecret APi
   * the method inputs a query string to search in food
   * Return Type [SearchFoodItem]
   * please refer to model package.
   */
  Future<String> searchFood(String query) async {
    
    // FatSecretApi be sure that consumer keys are set before you send a call
    FatSecretApi foodSearch = FatSecretApi(
      consumerKey,
      consumerKeySecret,
      "",
      "",
    );

    var result = await foodSearch
        .request({"search_expression": query, "method": "foods.search"})
        .then((res) => res.body)
        .then(json.decode)
        .then((json) => json["foods"])
        .then((json) => json["food"])
        .catchError((err) {
          print(err);
        });
    print(result);
    return result.toString();
  }

  /*
   * Sends an API call to "profile.create" method on fatSecret APi
   * the method inputs unique user Id
   * Return Type [Map]
   * please refer to fatSecret return types
   */
  Future<Map> createProfile(String userId) async {

    // Be sure that consumer keys are set before you send a call
    FatSecretApi api = FatSecretApi(consumerKey, consumerKeySecret, "", "");

    var response =
        api.request({"method": "profile.create", "user_id": userId});

    var jsonBody = await response.then((res) => res.body).then(json.decode);

    if (jsonBody["error"] != null) {
      var errorMap = jsonBody["error"];
      //throw FatSecretException(errorMap["code"], errorMap["message"]);
    }

    var profile = jsonBody["profile"];
    return profile;
  }

  /*
   * Sends an API call to "profile.get_auth" method on fatSecret APi
   * the method inputs unique user Id
   * Return Type [Map]
   * please refer to fatSecret return types
   */
  Future<Map> getProfileAuth(String userId) async {
    //var session = await Preferences().getUserSession();
    var api =
        FatSecretApi(consumerKey, consumerKeySecret, "", "");
    var jsonBody = await api
        .request({"method": "profile.get_auth", "user_id": userId})
        .then((res) => res.body)
        .then(json.decode);
//          .then((json) => json["profile"]);
    if (jsonBody["error"] != null) {
      var errorMap = jsonBody["error"];
      //throw new FatSecretException(errorMap["code"], errorMap["message"]);
    }

    var profile = jsonBody["profile"];
    return profile;
  }

//   /*
//    * Sends an API call to "food_entries.get_month" method on fatSecret APi
//    * the method inputs [Date] and [UserFatSecretAuthModel] optional
//    * if you want to access some other user you can set UserFatSecretAuthModel in parameters
//    * Return Type [DayNutrientsEntry]
//    * please refer to model package
//    */
//   Future<List<DayNutrientsEntry>> getMonthFoodEntries(
//       {String date, UserFatSecretAuthModel user}) async {
//     if (user == null) {
//       // set user if you have already stored user in preferences
// //      var user = await Preferences().getUserSession();
//     }

//     List<DayNutrientsEntry> list = [];

//     var api = new FatSecretApi(this.consumerKey, this.consumerKeySecret,
//         user?.authToken, user?.authSecret);
//     Map<String, String> params = {"method": "food_entries.get_month"};

//     if (date != null && date.isNotEmpty) params["date"] = date;

//     try {
//       var r = await api
//           .request(params)
//           .then((res) => res.body)
//           .then(json.decode)
//           .then((json) => json["month"])
//           .then((json) => json["day"]);

//       if (r is List) {
//         r.forEach((foodItem) => list.add(DayNutrientsEntry.fromJson(foodItem)));
//       } else {
//         list.add(DayNutrientsEntry.fromJson(r));
//       }
//     } catch (e) {}
//     return list;
//   }
}