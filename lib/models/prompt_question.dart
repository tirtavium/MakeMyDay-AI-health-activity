import 'package:MakeMyDay/models/prompt_result.dart';

abstract class PromptQuestion {
 final String diagnoseQuestion;
 final String takeActionQuestion;

  PromptQuestion(this.diagnoseQuestion, this.takeActionQuestion);
}
class PromptQuestionFood extends PromptQuestion {
  PromptQuestionFood() : super("What this food called?", "Does eat this bring problem to my health issue?");
}

class PromptQuestionDisease extends PromptQuestion {
  PromptQuestionDisease() : super(" What is the disease and explain?", "What action should be taken?");
}
class PromptQuestionMedicine extends PromptQuestion {
  PromptQuestionMedicine() : super("What this medice and explain?", "Does this medicine have contraction with my health issue?");

}

class PromptQuestionFactory{
  PromptQuestion getQuestion(PromptImageType typeImage){
    switch (typeImage) {
      case PromptImageType.food:
        return PromptQuestionFood();
      case PromptImageType.disease:
        return PromptQuestionDisease();
      case PromptImageType.medicine:
        return PromptQuestionMedicine();
      case PromptImageType.notdetected:
       return PromptQuestionFood();
    }
  }
}