import 'dart:convert';

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/configs/images.dart';
import 'package:app/models/Comments.dart';
import 'package:app/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsPage extends StatefulWidget {
  final String uuid;
  CommentsPage(this.uuid);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List<Comments> _comments = List<Comments>();
  bool _autoValidate = false;
  String _username;
  String _password;
  bool _isLoading = false;
  // get uuid => this.uuid;

  @override
  void initState() {
    super.initState();
    _populateAnchorsComments();
  }

  Future<bool> _sendComment(String comment, String anchor_id) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var data = {
      'comment': comment,
      'anchor_id': anchor_id,
      "user_id": localStorage.getString('user_id')
    };
    var res = await Network().authData(data, '/anchor/sendComment');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      return true;
    } else {
      print("jh" + body['message']);
      _showMsg(body['message']);
      return false;
    }

    setState(() {
      _isLoading = false;
    });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    // _scaffoldKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _populateAnchorsComments() async {
    // print("the uuid+${uuid}");
    final http.Response response = await http.get(
        "https://nifes.org.ng/api/mobile/anchor/showcomments/${widget.uuid}");
    final Map<String, dynamic> responseData = json.decode(response.body);
    print("thee+${responseData}");

    responseData['comments'].forEach((newsDetail) {
      final Comments news = Comments(
          id: newsDetail['id'],
          userId: newsDetail['user_id'],
          firstName: newsDetail['first_name'] ?? "",
          lastName: newsDetail['last_name'] ?? "",
          anchorId: newsDetail['anchor_id'],
          comment: newsDetail['comment'] ?? "",
          createdAt: newsDetail['created_at'],
          updatedAt: newsDetail['updated_at']);
      setState(() {
        _comments.add(news);
      });
    });
  }

  Widget commentChild() {
    return _comments.isEmpty
        ? Center(child: Text('No feedbacks yet!'))
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _comments.length,
            itemBuilder: (BuildContext context, int index) {
              return makeCard(_comments[index]);
              // print(
              //     "nownow${_comments[index].firstName + " " + _comments[index].lastName}");
            },
            // children: [
            //   for (var i = 0; i < data.length; i++)

            // ],
          );
  }

  Card makeCard(Comments comm) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(64, 75, 96, .9),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () async {
                    // Display the image in large form.
                    print("Comment Clicked");
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: new BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            new BorderRadius.all(Radius.circular(50))),
                    child: CircleAvatar(
                        radius: 50, backgroundImage: AppImages.commentpic),
                  ),
                ),
                title: Text(
                  "${comm.firstName + " " + comm.lastName}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  comm.comment,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FeedBacks"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        child: CommentBox(
          //AppImages.commentpic,
          userImage: "",
          //"https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400",
          child: commentChild(),
          labelText: 'Write a feedback...',
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState.validate()) {
              print(commentController.text);
              setState(() async {
                var localStorage = await SharedPreferences.getInstance();
                Comments vals = Comments(
                    id: 0,
                    comment: commentController.text,
                    userId: localStorage.getString('user_id'),
                    firstName: localStorage.getString('name'),
                    createdAt: "",
                    updatedAt: "",
                    lastName: "",
                    anchorId: widget.uuid);
                // var value = {
                //   'name': 'New User',
                //   'pic':
                //       'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                //   'message': commentController.text
                // };
                var inserted =
                    _sendComment(commentController.text, widget.uuid);
                if (inserted != false) {
                  print("commentController");
                  _comments.insert(0, vals);
                  commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              });
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
