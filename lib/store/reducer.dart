

import 'package:test_flutter_app/store/actions.dart';

bool reducer(bool previousState, dynamic action) {

  if(action == Actions.setFalse) {
    return false; 
  }else{
    return true;
  }
}