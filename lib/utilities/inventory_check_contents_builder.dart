import 'package:test_flutter_app/models/inventoryCheckContents.dart';
import 'package:test_flutter_app/utilities/inventory_check_linked_list.dart';
import 'package:uuid/uuid.dart';

class InventoryCheckContentsBuilder{
  static InventoryCheckContents? build(String id, String propertyId, String dateCompleted){
    InventoryCheckContents inventoryCheckContents = InventoryCheckContents(id: id, propertyId: propertyId, dateCompleted: dateCompleted);

    InventoryLinkedListSection? currentNode = InventoryCheckLinkedList.root;
    while(currentNode!=null){
      String sectionId = const Uuid().v4();
      List<Map> inputAreas = getInputAreas(currentNode, sectionId);
      inventoryCheckContents.addSection(currentNode.essentialSection, currentNode.title!, propertyId, sectionId, inputAreas);
      currentNode=currentNode.nextSection;
    }

    return inventoryCheckContents;
  }

  static List<Map> getInputAreas(InventoryLinkedListSection sectionNode, String sectionId){
    List<Map> inputAreas = [];

    InventoryLinkedListInputField? currentInputField = sectionNode.rootInputField;

    while(currentInputField!=null){
      Map currentInputFieldMap = InventoryCheckContents.buildInputArea(currentInputField.fieldComplete!=null?currentInputField.fieldComplete!:false, currentInputField.details!=null?currentInputField.details!:"", currentInputField.title!=null?currentInputField.title!:"", inputAreas.length+1, sectionId);
      inputAreas.add(currentInputFieldMap);
      currentInputField=currentInputField.nextInputField;
    }

    return inputAreas;
  }
}