import 'dart:developer';

class InventoryCheckLinkedList {
  static InventoryLinkedListSection? root;

  static void printSingleSectionDetails(String id){
    if(root!=null){
      root!.printSingleSectionDetails(id);
    }
  }

  static void addSection(String id, bool? essentialSection) {
    if (root == null) {
      root = InventoryLinkedListSection(id, essentialSection ?? false);
    } else {
      root!.addSection(id, essentialSection ?? false);
    }
    log("Size: ${getSize().toString()}");
  }

  static void deleteSection(String sectionToDeleteId) {
    if (root == null) {
      return;
    }

    if (root!.id == sectionToDeleteId && root!.hasNext()) {
      log(root!.id);
      root = root!.getNext();
      log("deleted section");
      log(root!.id);
      return;
    } else if (root!.id == sectionToDeleteId && !root!.hasNext()) {
      root=null;
    } else if (root!.id != sectionToDeleteId && root!.hasNext()) {
      root!.deleteSection(sectionToDeleteId);
    }
  }

  static void deleteInputField(String sectionId, String inputFieldId) {
    if (root != null) {
      root!.deleteInputField(sectionId, inputFieldId);
    }
  }

  static void addInputField(String sectionId, String inputFieldId) {
    if (root != null) {
      root!.addInputField(sectionId, inputFieldId);
    }
  }

  static int getSize() {
    if (root != null) {
      return root!.size();
    } else {
      return 0;
    }
  }

  static String toStringS() {
    return root.toString();
  }

  static void clear() {
    root = null;
  }

  static void populateSectionFields(String sectionId, String sectionTitle){
    if(root!=null){
      root!.updateSectionFields(sectionTitle, sectionId);
    }
  }
  // static void populateSectionFields(String sectionId, String sectionTitle){
  //   if(root!=null){
  //     root!.updateSectionFields(sectionTitle, sectionId);
  //   }
  // }

  static void populateSectionInputFields(String sectionId, String fieldId, bool fieldComplete, String fieldTitle, String fieldDetails){
    if(root!=null){
      root!.populateSectionInputFields(sectionId, fieldId, fieldComplete, fieldTitle, fieldDetails);
    }
  }
}

class InventoryLinkedListSection {
  InventoryLinkedListSection(this.id, this.essentialSection);

  bool essentialSection = false;
  String id;
  String? title;
  InventoryLinkedListInputField? rootInputField;
  InventoryLinkedListSection? nextSection;

  bool hasNext() {
    if (nextSection != null) {
      return true;
    }
    return false;
  }

  InventoryLinkedListSection getNext() {
    return nextSection!;
  }

  int size() {
    if (nextSection != null) {
      return 1 + nextSection!.size();
    } else {
      return 1;
    }
  }

  void addSection(String newSectionId, bool essentialSection) {
    if (id == newSectionId) {
      return;
    }

    if (nextSection == null) {
      nextSection = InventoryLinkedListSection(newSectionId, essentialSection);
      log("Section added: $id");
      log("\tessential section: $essentialSection");
    } else {
      nextSection!.addSection(newSectionId, essentialSection);
    }
  }

  void addInputField(String sectionId, String newInputFieldId) {
    if (id != sectionId) {
      if (nextSection != null) {
        nextSection!.addInputField(sectionId, newInputFieldId);
      } else if (nextSection == null) {
        return;
      }
    } else {
      if (rootInputField == null) {
        rootInputField = InventoryLinkedListInputField(id);
      } else {
        rootInputField!.addInputField(newInputFieldId);
      }
    }
  }

  @override
  String toString() {
    if (nextSection != null) {
      return "$id ${nextSection.toString()}";
    } else {
      return id;
    }
  }

  void deleteSection(String sectionId) {
    if (nextSection == null) {
      return;
    }
    if (nextSection!.id == sectionId && nextSection!.hasNext()) {
      nextSection = nextSection!.getNext();
      log("deleted section");
    } else if (nextSection!.id == sectionId && !nextSection!.hasNext()) {
      nextSection = null;
      log("deleted section");
    } else if (nextSection!.id != sectionId && nextSection!.hasNext()) {
      // nextSection!.getNext().deleteSection(sectionId);
      nextSection!.deleteSection(sectionId);
    }
  }

  void deleteInputField(String sectionId, String inputFieldId) {
    if (id != sectionId && nextSection != null) {
      nextSection!.deleteInputField(sectionId, inputFieldId);
    } else if (id != sectionId && nextSection == null) {
      return;
    }

    if (rootInputField == null) {
      return;
    }
    if (rootInputField!.id == inputFieldId && !rootInputField!.hasNext()) {
      rootInputField = null;
    } else if (rootInputField!.id == inputFieldId &&
        rootInputField!.hasNext()) {
      rootInputField = rootInputField!.getNextNode();
    } else if (rootInputField!.id != inputFieldId &&
        rootInputField!.hasNext()) {
      rootInputField!.getNextNode().deleteInputField(inputFieldId);
    }
  }

  void updateSectionFields(String sectionTitle, String sectionId){
    if(id==sectionId){
      title=sectionTitle;
    }else if(id!=sectionId && nextSection!=null){
      nextSection!.updateSectionFields(sectionTitle, sectionId);
    }
  }
  
  void populateSectionInputFields(String sectionId, String fieldId, bool fieldComplete, String fieldTitle, String fieldDetails) {
    if(id==sectionId && rootInputField!=null){
      rootInputField!.updateInputFields(fieldId, fieldComplete, fieldTitle, fieldDetails);
    }else if(id!=sectionId && nextSection!=null){
      nextSection!.populateSectionInputFields(sectionId, fieldId, fieldComplete, fieldTitle, fieldDetails);
    }
  }
  
  void printSingleSectionDetails(String sectionId) {
    if(id==sectionId){
      log("""Section: $id
        title: $title
        essential: $essentialSection""");
    }else if(id!=sectionId && nextSection!=null){
      nextSection!.printSingleSectionDetails(sectionId);
    }
  }
}

class InventoryLinkedListInputField {
  InventoryLinkedListInputField(this.id);
  String id;
  bool? fieldComplete;
  String? title;
  String? details;
  InventoryLinkedListInputField? nextInputField;

  InventoryLinkedListInputField getNextNode() {
    return nextInputField!;
  }

  bool hasNext() {
    return nextInputField != null;
  }

  void addInputField(String newInputFieldId) {
    if (id == newInputFieldId) {
      return;
    }

    if (nextInputField == null) {
      nextInputField = InventoryLinkedListInputField(newInputFieldId);
      log("Input field added: $id");
    } else {
      nextInputField!.addInputField(newInputFieldId);
    }
  }

  void deleteInputField(String inputFieldId) {
    if (nextInputField == null) {
      return;
    }
    if (nextInputField!.id == inputFieldId && nextInputField!.hasNext()) {
      nextInputField = nextInputField!.getNextNode();
    } else if (nextInputField!.id == inputFieldId &&
        !nextInputField!.hasNext()) {
      nextInputField = null;
    } else if (nextInputField!.id != inputFieldId &&
        nextInputField!.hasNext()) {
      nextInputField!.deleteInputField(inputFieldId);
    }
  }
  
  void updateInputFields(String fieldId, bool inputFieldComplete, String inputFieldTitle, String inputFieldDetails) {
    if(id==fieldId){
      fieldComplete=inputFieldComplete;
      title=inputFieldTitle;
      details=inputFieldDetails;
      printInputFieldDetails();
    }else if(id!=fieldId && nextInputField!=null){
      nextInputField!.updateInputFields(fieldId, inputFieldComplete, inputFieldTitle, inputFieldDetails);
    }
  }
  
  void printInputFieldDetails() {
    log("""        field id: $id
        title: $title
        field complete: $fieldComplete
        details: $details
        """);

    // if(nextInputField!=null){
    //   nextInputField!.printInputFieldDetails();
    // }
  }
}
