import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Comments extends StatelessWidget {
  Comments({required this.post_id, Key? key}) : super(key: key);
  String post_id;
  Future<List<Items>> GetPhotos() async {
    var url = Uri.parse(base_url +
        "get_comments.php?post_id=" +
        post_id +
        "&auth_key=" +
        auth_key);
    var Photos = await http.get(url);
    var JsonData = json.decode(Photos.body);
    final List<Items> rows = [];

    for (var u in JsonData) {
      Items item =
          Items(u["user_id"], u["user_name"], u["comment_content"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.DarkBlueColour,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
                text: 'All Comments',
                fontsize: 0.03,
                isbold: true,
                color: CustomColors.WhiteColour,
                textalign: TextAlign.start),
          ],
        ),
        // actions: [

        // ],
      ),
      body: Container(
        decoration: GradientbackgroundColour(),
        child: FutureBuilder(
          future: GetPhotos(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                    child: CircularProgressIndicator(color: Colors.white)),
              );
            } else if (snapshot.data[0].code == "0") {
              return Container(
                child: Center(
                  child: CustomTextWidget(
                      text: "No Comments",
                      fontsize: 0.03,
                      isbold: true,
                      color: Colors.white,
                      textalign: TextAlign.start),
                ),
              );
            } else {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextWidget(
                            text: snapshot.data[index].comment_content,
                            fontsize: 0.03,
                            isbold: true,
                            color: Colors.white,
                            textalign: TextAlign.start),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Items {
  final String user_id;
  final String user_name;
  final String comment_content;
  final String code;
  Items(this.user_id, this.user_name, this.comment_content, this.code);
}
