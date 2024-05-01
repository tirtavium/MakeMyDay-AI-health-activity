import 'dart:convert';
import 'dart:math';
import 'package:MakeMyDay/models/SearchFoodItem.dart';
import 'package:MakeMyDay/resources/PrivateKeyConstant.dart';
import 'package:MakeMyDay/resources/fat_secret_service2.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:sortedmap/sortedmap.dart';

class RestClientFatSecreet {
  // if  you don't have one, generate from fatSecret API
  

  // creates a new RestClient instance.
  // try to make singleton too avoid multiple instances
  // make sure to set AppConfig consumer keys and secrets.

  final consumerKey = consumerKeyFS;
  final consumerKeySecret = consumerKeySecretFS;
  /*
   * Sends an API call to "food.search" method on fatSecret APi
   * the method inputs a query string to search in food
   * Return Type [SearchFoodItem]
   * please refer to model package.
   */
  Future<List<SearchFoodItem>> searchFood(String query) async {
     List<SearchFoodItem> list = [];
    // FatSecretApi be sure that consumer keys are set before you send a call
    FatSecretApi2 foodSearch = FatSecretApi2(
      consumerKey,
      consumerKeySecret, "",""
    );
   var result = await foodSearch
        .request({"search_expression": query, "method": "foods.search"});

    
     if (result.statusCode == 200) {
      var responseMap = await json.decode(result.body);
     //print(responseMap["foods"]["food"]);
    
    responseMap["foods"]["food"].forEach((foodItem) =>  
    
      list.add(convertSearchFoodItem(foodItem)) 
   
    );
 
     }
    // Create a POJO clasrs and parse it
    // list.add(SearchFoodItem.fromJson(result.body[0] as Map<String, String>));

    return list;
  }
  SearchFoodItem convertSearchFoodItem(dynamic data){
    final Map map = Map.from(data);
    final foodItem = SearchFoodItem.fromJson(map);
    print(foodItem.foodDescription);
    return foodItem;
  } 


  /*
   * Sends an API call to "profile.create" method on fatSecret APi
   * the method inputs unique user Id
   * Return Type [Map]
   * please refer to fatSecret return types
   */
  Future<Map> createProfile(String userId) async {

    // Be sure that consumer keys are set before you send a call
    FatSecretApi2 api = FatSecretApi2(consumerKey, consumerKeySecret,"","");

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
        FatSecretApi2(consumerKey, consumerKeySecret, "","");
    var jsonBody = await api
        .request({"method": "profile.get_auth", "user_id": userId})
        .then((res) => res.body)
        .then(json.decode);
//          .then((json) => json["profile"]);
    if (jsonBody["error"] != null) {
      var errorMap = jsonBody["error"];
      print(errorMap);
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