import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_samples/res/custom_colors.dart';
import 'package:flutterfire_samples/screens/database/crud/db_edit_screen.dart';
import 'package:flutterfire_samples/services/usermanagement.dart';
import 'package:flutterfire_samples/utils/database.dart';

class DbItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String docID = snapshot.data!.docs[index].id;
              String title = noteInfo['title'];
              String description = noteInfo['description'];

              return Ink(
                decoration: BoxDecoration(
                  color: Palette.firebaseGrey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () {
                    Usermanagement().authorizeEditAccess(
                        context, title, description, docID);
                  },
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Palette.firebaseOrange,
            ),
          ),
        );
      },
    );
  }
}
