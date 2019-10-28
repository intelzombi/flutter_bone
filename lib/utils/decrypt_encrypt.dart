import 'dart:typed_data';

import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/data/password_data.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/models/wallet_item.dart';
import 'package:flutter_bone/models/wallet_item_encrypt.dart';

class EncryptUtil {

  static Future<WalletItemEncrypted> encryptFrom( WalletItem walletItem) async{
    Uint8List lockerNameEncrypted;
    Uint8List usernameEncrypted;
    Uint8List passwordEncrypted;
    await CypherChannel.encryptMsg((str, uilValue) { lockerNameEncrypted = uilValue; }, walletItem.lockerName , PasswordData.clearPassword, SaltPepper.salt, SaltPepper.pepper);
    await CypherChannel.encryptMsg((str, uilValue) { usernameEncrypted = uilValue; }, walletItem.userName , PasswordData.clearPassword, SaltPepper.salt, SaltPepper.pepper);
    await CypherChannel.encryptMsg((str, uilValue) { passwordEncrypted = uilValue; }, walletItem.password , PasswordData.clearPassword, SaltPepper.salt, SaltPepper.pepper);
    return WalletItemEncrypted(walletItem.lockerType, LockerName(walletItem.lockerName, lockerNameEncrypted), UserName(walletItem.userName, usernameEncrypted), Password(walletItem.password, passwordEncrypted));
  }

}

class DecryptUtil {

  static Future<WalletItem> decryptFrom(WalletItemEncrypted walletItemEncrypted) async {
    String lockerNameClear;
    String userNameClear;
    String passwordClear;
    await CypherChannel.decryptMsg((strValue) { lockerNameClear = strValue; }, walletItemEncrypted.lockerName.lockerNameEncrypted, PasswordData.clearPassword, SaltPepper.salt, SaltPepper.pepper);
    await CypherChannel.decryptMsg((strValue) { userNameClear = strValue; }, walletItemEncrypted.userName.userNameEncrypted, PasswordData.clearPassword, SaltPepper.salt, SaltPepper.pepper);
    await CypherChannel.decryptMsg((strValue) { passwordClear = strValue; }, walletItemEncrypted.password.passwordEncrypted, PasswordData.clearPassword, SaltPepper.salt, SaltPepper.pepper);
    return WalletItem.withId(walletItemEncrypted.id, lockerNameClear, userNameClear,passwordClear,walletItemEncrypted.lockerType );
  }
}