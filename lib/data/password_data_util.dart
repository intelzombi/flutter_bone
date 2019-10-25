import 'dart:typed_data';

import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/models/password_item.dart';
import 'package:flutter_bone/utils/database_helper.dart';

class PasswordDataUtil {
  static Future<void> getPasswordData(
      DatabaseHelper databaseHelper, Function passwordStateFunction) async {
    await databaseHelper.initializeDatabase();
    List<PasswordItem> passwordItemList =
        await databaseHelper.getPasswordItemList();
    passwordStateFunction(passwordItemList);
  }

  //Update database with new SaltPepper.
  static Future<void> generatePasswordData(DatabaseHelper databaseHelper,
      String passwordClear, Function passwordStateFunction) async {
    databaseHelper.initializeDatabase();
    int cnt = await getPasswordItemCount(databaseHelper);
    Uint8List password = await CypherChannel.encryptMsg(passwordStateFunction,
        passwordClear, passwordClear, SaltPepper.salt, SaltPepper.pepper);
    if (cnt == 0) {
      insertPasswordItem(databaseHelper, new PasswordItem(password));
    } else if (cnt == 1) {
      updatePasswordItem(databaseHelper, new PasswordItem(password));
    }
  }

  static void insertPasswordItem(
      DatabaseHelper databaseHelper, PasswordItem passwordItem) async {
    int result = await databaseHelper.insertPasswordItem(passwordItem);
  }

  static void updatePasswordItem(
      DatabaseHelper databaseHelper, PasswordItem passwordItem) async {
    int result = await databaseHelper.updatePasswordItem(passwordItem);
  }

  static Future<int> getPasswordItemCount(DatabaseHelper databaseHelper) async {
    int result = await databaseHelper.getPasswordItemCount();
    return result;
  }

  static void deletePasswordItem(
      DatabaseHelper databaseHelper, PasswordItem passwordItem) async {
    int result = await databaseHelper.deletePasswordItem(passwordItem.id);
  }
}
