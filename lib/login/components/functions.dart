import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../home.dart';
// import '../../secrets/secrets.dart';
import 'collection_not_found_dialog.dart';
import 'database_error_dialog.dart';

bool isCorrectIdPass({required idController, required passController}) {
  var id = idController.text.trim();
  var pass = passController.text.trim();

  //! correct...
  // if (id == '' || pass == '' || pass != univPass || id != univId) {
  if (id == '' || pass == '') {
    return false;
  }
  return true;
}

Future<void> checkDbAndGotoHome(
    BuildContext context, String collec, String database) async {
  MongoDatabase.connect(collecName: collec, dbName: database).then(
    (db) async {
      db.open().then(
        (_) {
          db.getCollectionNames().then(
            (collecList) {
              if (collecList.contains(collec)) {
                MongoDatabase.userCollection = db.collection(collec);
                Navigator.of(context).pop(); //For Loading
                Navigator.of(context).pop(); //For Login Screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              } else {
                Navigator.of(context).pop(); //For Loading Screen
                showDialog(
                  context: context,
                  builder: (context) => const CollectionNotFound(),
                );
              }
            },
          );
        },
      ).catchError(
        (error, stackTrace) {
          Navigator.of(context).pop(); //For Loading Screen
          showDialog(
            context: context,
            builder: (context) => const DatabaseError(),
          );
        },
      );
    },
  );
}
