import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bone/data/persistent_wallet_items.dart';
import 'package:flutter_bone/models/wallet_item.dart';
import 'package:flutter_bone/models/wallet_item_encrypt.dart';
import 'package:flutter_bone/screens/wallet_item_detail.dart';
import 'package:flutter_bone/utils/database_helper.dart';
import 'package:flutter_bone/utils/decrypt_encrypt.dart';
import 'package:sqflite/sqflite.dart';

class WalletItemListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletItemListScreenState();
  }
}

class WalletItemListScreenState extends State<WalletItemListScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<WalletItem> walletItemList;
  int count = 0;

  @override
  void initState() {
    if (walletItemList == null) {
      walletItemList = List<WalletItem>();
      updateListViewFromEncrypted();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Wallet'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('floating action pressed');
          navigateToDetail(WalletItem(2, '', '', ''), "Add Wallet Item");
        },
        tooltip: '2 cents',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getLockerTypeColor(this.walletItemList[position].lockerType),
              child:
                  getLockerTypeIcon(this.walletItemList[position].lockerType),
            ),
            title: Text(
              this.walletItemList[position].lockerName,
              style: titleStyle,
            ),
            subtitle: Text(this.walletItemList[position].password),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, walletItemList[position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(
                  this.walletItemList[position], 'Edit Wallet Item');
            },
          ),
        );
      },
    );
  }

  Color getLockerTypeColor(int lockerType) {
    switch (lockerType) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getLockerTypeIcon(int lockerType) {
    switch (lockerType) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, WalletItem note) async {
    int result = await databaseHelper.deleteWalletItem(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Wallet Item Deleted Successfully');
      updateListViewFromEncrypted();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(WalletItem walletItem, String lockerName) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WalletItemDetailScreen(walletItem, lockerName);
    }));

    if (result) {
      updateListViewFromEncrypted();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WalletItem>> walletItemListFuture =
          databaseHelper.getWalletItemList();
      walletItemListFuture.then((walletItemList) {
        setState(() {
          this.walletItemList = walletItemList;
          this.count = walletItemList.length;
        });
      });
    });
  }

  //Stream<WalletItem> updateListViewFromEncrypted() async* {
  Future<void> updateListViewFromEncrypted() async {
    List<WalletItem> walletItemList = List<WalletItem>();
    await databaseHelper.initializeDatabase();
    List<WalletItemEncrypted> walletItemListEncrypted =
        await databaseHelper.getWalletItemEncryptedList();
    for (WalletItemEncrypted wie in walletItemListEncrypted) {
      if (PersistentWalletItems.persistentWalletItemEncryptedMap
          .containsKey(wie.id)) {
        WalletItemEncrypted pwie =
            PersistentWalletItems.persistentWalletItemEncryptedMap[wie.id];
        if (pwie.password.passwordEncrypted.toString() == wie.password.passwordEncrypted.toString() &&
            pwie.lockerName.lockerNameEncrypted.toString() ==
                wie.lockerName.lockerNameEncrypted.toString() &&
            pwie.userName.userNameEncrypted.toString() == wie.userName.userNameEncrypted.toString()) {
          walletItemList.add(WalletItem.withId(
              pwie.id,
              pwie.lockerName.lockerName,
              pwie.userName.userName,
              pwie.password.password,
              pwie.lockerType));
        } else {
          WalletItemEncrypted walletItemEncrypted =
              await DecryptUtil.decryptFrom(wie);
          PersistentWalletItems.persistentWalletItemEncryptedMap[wie.id] =
              walletItemEncrypted;
          walletItemList.add(WalletItem.withId(
              walletItemEncrypted.id,
              walletItemEncrypted.lockerName.lockerName,
              walletItemEncrypted.userName.userName,
              walletItemEncrypted.password.password,
              walletItemEncrypted.lockerType));
        }
      } else {
        WalletItemEncrypted walletItemEncrypted =
        await DecryptUtil.decryptFrom(wie);
        PersistentWalletItems.persistentWalletItemEncryptedMap[wie.id] =walletItemEncrypted;
        walletItemList.add(WalletItem.withId(
            walletItemEncrypted.id,
            walletItemEncrypted.lockerName.lockerName,
            walletItemEncrypted.userName.userName,
            walletItemEncrypted.password.password,
            walletItemEncrypted.lockerType));
      }
    }
    setState(() {
      this.walletItemList = walletItemList;
      this.count = walletItemList.length;
    });
  }
}
