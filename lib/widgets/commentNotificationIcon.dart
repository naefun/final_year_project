import 'package:flutter/material.dart';
import 'package:test_flutter_app/models/inventoryCheck.dart';
import 'package:test_flutter_app/utilities/comment_utilities.dart';
import 'package:test_flutter_app/utilities/global_values.dart';

class CommenNotificationIcon extends StatefulWidget {
  const CommenNotificationIcon({
    super.key,
    required this.inventoryCheck,
  });

  final InventoryCheck inventoryCheck;

  @override
  State<CommenNotificationIcon> createState() => _CommenNotificationIconState();
}

class _CommenNotificationIconState extends State<CommenNotificationIcon> {
  bool? newComments;
  @override
  Widget build(BuildContext context) {
    if (newComments == null) checkForNewComments();

    return Image(
      image: AssetImage(newComments != null && newComments! == true
          ? IconPaths.commentWithNotificationIconPath.path
          : IconPaths.commentIconPath.path),
      width: 28,
      height: 28,
    );
  }

  void checkForNewComments() async {
    bool newCommentsExist = false;
    await CommentUtilities.inventoryCheckHasNewComments(
            widget.inventoryCheck.id!)
        .then((value) => newCommentsExist = value);

    setState(() {
      newComments = newCommentsExist;
    });
  }
}