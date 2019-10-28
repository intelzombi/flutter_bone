import 'dart:typed_data';

import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/models/salt_pepper_item.dart';
import 'package:flutter_bone/utils/database_helper.dart';

class SaltPepperUtil {
  static void getSaltPepper(
      DatabaseHelper databaseHelper,
      Function saltStateFunction,
      Function pepperStateFunction,
      Function setState) async {
    await databaseHelper.initializeDatabase();
      int cnt = await getSaltPepperCount(databaseHelper);

        if (cnt == 0) {
          Uint8List salt = await CypherChannel.generateSalt(saltStateFunction);
          Uint8List pepper = await CypherChannel.generatePepper(pepperStateFunction);
              insertSaltPepper(databaseHelper,
                  new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
        } else if (cnt == 1) {
          List<SaltPepperItem> saltPepperItemList = await databaseHelper.getSaltPepperItemList();
            setState(saltPepperItemList);
        }

  }

  //Update database with new SaltPepper.
  static Future<void>  generateSaltPepper(DatabaseHelper databaseHelper,
      Function saltStateFunction, Function pepperStateFunction) async {
    await databaseHelper.initializeDatabase();
      int cnt = await getSaltPepperCount(databaseHelper);
      Uint8List salt = await CypherChannel.generateSalt(saltStateFunction);
      Uint8List pepper = await CypherChannel.generatePepper(pepperStateFunction);
      if (cnt == 0) {
        insertSaltPepper(databaseHelper,
            new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
      } else if (cnt == 1) {
        updateSaltPepper(databaseHelper,
            new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
      }
  }

  static void insertSaltPepper(
      DatabaseHelper databaseHelper, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.insertSaltPepperItem(saltPepperItem);
  }

  static void updateSaltPepper(
      DatabaseHelper databaseHelper, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.updateSaltPepperItem(saltPepperItem);
  }

  static Future<int> getSaltPepperCount(DatabaseHelper databaseHelper) async {
    int result = await databaseHelper.getSaltPepperCount();
    return result;
  }

  static void deleteSaltPepper(DatabaseHelper databaseHelper, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.deleteSaltPepperItem(saltPepperItem.id);
  }
}
