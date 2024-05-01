class SearchFoodItem {
  final String brandName;
  final String foodDescription;
  final String foodId;
  final String foodName;
  final String foodType;
  final String foodUrl;

  SearchFoodItem({required this.brandName, required this.foodDescription, required this.foodId, required this.foodName, required this.foodType, required this.foodUrl});
 
  static SearchFoodItem fromJson(Map<dynamic, dynamic> json) {
    return SearchFoodItem(
      brandName: json["brand_name"] ?? "",
      foodDescription: json["food_description"] ?? "",
      foodId: json["food_id"] ?? "",
      foodName: json["food_name"] ?? "",
      foodType: json["food_type"] ?? "",
      foodUrl: json["food_url"] ?? "");
  }



}