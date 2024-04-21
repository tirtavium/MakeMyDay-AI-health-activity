const labelProfile = "Profile";
const labelSetupPersonalInformation = "Personal Information";
const labelSetupAccountInformation = "Account Information";
const labelSetupHealthCondition = "Health Condition";
const labelSetupCurrentMedication = "Current Medication";
const labelSetupFoodAlergies = "Food Alergies";
const labelLogout = "Log out";
const labelLogoutConfirmation = "Are you sure?";

enum ConditionType { foodAlergies, currentMedication, healthCondition }

extension ConditionTypeExtension on ConditionType {
  String getTitle() {
    switch (this) {
      case ConditionType.currentMedication:
        return "Current Medication";
      case ConditionType.foodAlergies:
        return "Food Alergies";
      case ConditionType.healthCondition:
        return "Health Condition";
    }
  }
}
