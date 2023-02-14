import 'dart:developer';

class InventoryCheckLinkedList {
  static InventoryLinkedListSection? root;

  static void addSection(String id) {
    if (root == null) {
      root = InventoryLinkedListSection(id);
    } else {
      root!.addSection(id);
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
}

class InventoryLinkedListSection {
  InventoryLinkedListSection(this.id);

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

  void addSection(String newSectionId) {
    if (id == newSectionId) {
      return;
    }

    if (nextSection == null) {
      nextSection = InventoryLinkedListSection(newSectionId);
      log("Section added: $id");
    } else {
      nextSection!.addSection(newSectionId);
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
}

class InventoryLinkedListInputField {
  InventoryLinkedListInputField(this.id);
  String id;
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
}
