import 'dart:typed_data';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:MakeMyDay/models/prompt_question.dart';
import 'package:MakeMyDay/models/prompt_result.dart';
import 'dart:convert';

import 'package:MakeMyDay/models/user.dart';

class GeminiService {
  static const apiKey = "AIzaSyA0SVEtPJWAtrPlsr-YwS_r83xY9hoPQMQ";

  Future<PromptResult> getPromptFromImage(Uint8List file, User user) async {
    //if we do prompt all at once, the result realy bad.

    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final typeOfImage = await getTypeOfImage(file);
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);

    final imageParts = [
      DataPart('image/jpeg', file),
    ];
    final healthConditionData = user.healthConditions.join(',');
    final currentMedicationData = user.medicationCurrent.join(',');
    final foodAlergiesData = user.foodAlergies.join(',');
    final myHealthCondition = TextPart("my health condition $healthConditionData");
    final myCurrentMedication = TextPart("my current medication $currentMedicationData");
    final myFoodAlergies = TextPart("my food alergies $foodAlergiesData");

    PromptQuestion question = PromptQuestionFactory().getQuestion(typeOfImage.imageType);
    final promptDiagnose = TextPart("question1: ${question.diagnoseQuestion}");
    final contentTakeAction =
        TextPart("question2: ${question.takeActionQuestion}");
    final responseFormat =
        TextPart("The output should be a JSON with key question1, question2");

    var promptToGemini = [myHealthCondition,myCurrentMedication,myFoodAlergies, promptDiagnose,contentTakeAction,responseFormat, ...imageParts];
    if (typeOfImage.imageType == PromptImageType.food) {
      // final restFS = RestClientFatSecreet();
      // final desct = restFS.searchFood(typeOfImage.what);
      // print(desct);
    }
    final responseTakeAction = await model.generateContent([
      Content.multi(
          promptToGemini)
    ]);
    final responsePrompt = responseTakeAction.text?.replaceAll("`", "").replaceAll("json", "") ?? "";
    print("responseTakeAction");
    print(responsePrompt);
    final jsonResponse = json.decode(responsePrompt);

    final responseDiagnoseText = jsonResponse["question1"];
    final responseTakeActionText = jsonResponse["question2"];
    final result = PromptResult(
        imageType: typeOfImage.imageType,
        diagnoseDescription: responseDiagnoseText,
        takeActionDescription: responseTakeActionText);

    return result;
  }

  Future<PromptBasicResponse> getTypeOfImage(Uint8List file) async {
    // Access your API key as an environment variable (see "Set up your API key" above)

    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }
    // For text-and-image input (multimodal), use the gemini-pro-vision model
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);

    final imageParts = [
      DataPart('image/jpeg', file),
    ];
    final promptType = TextPart(
        "question1: choose the type of image?, option: 1. medicine 2. food 3. medical condition");
    final promptWhat = TextPart(
        "question2: what is this?");
   final responseFormat =
        TextPart("The output should be a JSON with key question1, question2");
    final response = await model.generateContent([
      Content.multi([promptType,promptWhat, responseFormat, ...imageParts])
    ]);
    print("getTypeOfImage");
    
    final promptResponse = response.text?.replaceAll("`", "").replaceAll("json", "") ?? "";
    print(promptResponse);
    final jsonResponse = json.decode(promptResponse);

    final what = jsonResponse["question2"];
    final imageType = jsonResponse["question1"];
    final returnValue = PromptBasicResponse(what, imageType: getPromptTypeImage(imageType));
    return returnValue;
  }

  PromptImageType getPromptTypeImage(String promptResponse) {
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
}
class PromptBasicResponse {
    final PromptImageType imageType;
    final String what;

  PromptBasicResponse(this.what, {required this.imageType});
    
}