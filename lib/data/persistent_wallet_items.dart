import 'package:flutter_bone/models/wallet_item.dart';
import 'package:flutter_bone/models/wallet_item_encrypt.dart';

class PersistentWalletItems {
  static Map<int,WalletItem> _persistentWalletItemMap = Map<int,WalletItem>();

  static Map<int,WalletItem> get persistentWalletItemMap =>
      _persistentWalletItemMap;

  static set persistentWalletItemMap(Map<int,WalletItem> value) {
    _persistentWalletItemMap = value;
  }
  static Map<int,WalletItemEncrypted> _persistentWalletItemEncryptedMap = Map<int,WalletItemEncrypted>();

  static Map<int,WalletItemEncrypted> get persistentWalletItemEncryptedMap =>
      _persistentWalletItemEncryptedMap;

  static set persistentWalletItemEncryptedMap(Map<int,WalletItemEncrypted> value) {
    _persistentWalletItemEncryptedMap = value;
  }
}