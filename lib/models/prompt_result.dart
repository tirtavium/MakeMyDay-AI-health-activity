
import 'package:MakeMyDay/models/SearchFoodItem.dart';

enum PromptImageType { food, medicine, disease, notdetected }

class PromptResult {
  final PromptImageType imageType;
  final String diagnoseDescription;
  final String takeActionDescription;
  String imageTypeDescription = "";
  final List<SearchFoodItem>? detailFoods;
  PromptResult(this.detailFoods, {required this.imageType, required this.diagnoseDescription, required this.takeActionDescription}){
    if (imageType == PromptImageType.food) {
          imageTypeDescription = "food";
    }
     if (imageType == PromptImageType.disease) {
          imageTypeDescription = "disease";
    }
     if (imageType == PromptImageType.medicine) {
          imageTypeDescription = "medicine";
    }
      if (imageType == PromptImageType.notdetected) {
          imageTypeDescription = "notdetected";
    }
  }

   Map<String, dynamic> toJson() => {
        "imageType": imageTypeDescription,
        "diagnoseDescription": diagnoseDescription,
        "takeActionDescription": takeActionDescription,
      };
   
   static PromptImageType getPromptTypeImage(String promptResponse) {
    if (promptResponse.toLowerCase().contains("food")) {
      return PromptImageType.food;
    }

    if (promptResponse.toLowerCase().contains("medicine")) {
      return PromptImageType.medicine;
    }

    if (promptResponse.toLowerCase().contains("medical")) {
      return PromptImageType.disease;
    }

    return PromptImageType.notdetected;
  }
  
  static PromptResult fromSnap(Map<String, dynamic> snap) {
    
   return PromptResult(null, imageType: PromptResult.getPromptTypeImage(snap['imageType']), diagnoseDescription: snap['diagnoseDescription'], takeActionDescription: snap['takeActionDescription']);

  }
}