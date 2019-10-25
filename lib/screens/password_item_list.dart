import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/screens/wallet_item_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bone/models/wallet_item.dart';
import 'package:flutter_bone/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';


class WalletItemList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletItemListState();
  }
}

class WalletItemListState extends State<WalletItemList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<WalletItem> walletItemList;
  int count = 0;

  //static const platform = const MethodChannel('iceberg.gunsnhoney.flutter_bone/cypher');
  ByteBuffer _iv;
  //String _iv ;

//  Future<void> _getIV() async {
//     ByteBuffer iv;
////   String iv='nothing has changed';
//    try {
////      final Uint8List result = await platform.invokeMethod('getIV');
////      iv.addAll(result);
//      final Uint8List result = await platform.invokeMethod('getIV');
//      iv = Uint8List.fromList(result).buffer;
//    } on PlatformException catch (e) {
//     //iv='we didn\'t see the cat';
//    }
//
//    setState(() {
//      _iv=iv;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    if(walletItemList == null) {
      walletItemList = List<WalletItem>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Wallet'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        debugPrint('floating action pressed');
        navigateToDetail(WalletItem( 2,'','',''),"Add Wallet Item");
      },
        tooltip: '2 cents',
        child: Icon(Icons.add),),

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
              backgroundColor: getLockerTypeColor(this.walletItemList[position].lockerType),
              child: getLockerTypeIcon(this.walletItemList[position].lockerType),
            ),
            title: Text(this.walletItemList[position].lockerName, style: titleStyle,),
            subtitle: Text(this.walletItemList[position].password),
            trailing: GestureDetector(
              child: Icon(Icons.delete,color: Colors.grey,),
              onTap: () {
                _delete(context, walletItemList[position]);
              },
            ),
            onTap: () {
              CypherChannel.getIV(ivSetState);
              debugPrint("ListTile Tapped" + _iv.toString());
              navigateToDetail(this.walletItemList[position],'Edit Wallet Item');
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

  void ivSetState(ByteBuffer iv) {
    setState(() {
      _iv = iv;
    });
  }

  void _delete(BuildContext context, WalletItem note) async {
    int result = await databaseHelper.deleteWalletItem(note.id);
    if(result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(WalletItem passwordItem, String lockerName) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WalletItemDetail(passwordItem, lockerName);
    }));

    if(result) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WalletItem>> passwordItemListFuture = databaseHelper.getWalletItemList();
      passwordItemListFuture.then((passwordItemList) {
        setState(() {
          this.walletItemList=passwordItemList;
          this.count=passwordItemList.length;
        });
      });
    });
  }
}

