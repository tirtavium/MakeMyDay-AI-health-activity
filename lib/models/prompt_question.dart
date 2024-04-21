import 'package:MakeMyDay/models/prompt_result.dart';

abstract class PromptQuestion {
 final String diagnoseQuestion;
 final String takeActionQuestion;

  PromptQuestion(this.diagnoseQuestion, this.takeActionQuestion);
}
class PromptQuestionFood extends PromptQuestion {
  PromptQuestionFood() : super("what this food called?", "can I eat this?");
}

class PromptQuestionDisease extends PromptQuestion {
  PromptQuestionDisease() : super(" What is the disease and explain?", "What action should be taken?");
}
class PromptQuestionMedicine extends PromptQuestion {
  PromptQuestionMedicine() : super("what this medice and explain?", "does this medicine have contraction with?");

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