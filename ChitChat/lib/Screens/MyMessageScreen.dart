import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyMessageScreen extends StatefulWidget {
  DocumentSnapshot<Object?> userSnapshot;
  MyMessageScreen({super.key, required this.userSnapshot});

  @override
  State<MyMessageScreen> createState() => _MyMessageScreenState();
}

class _MyMessageScreenState extends State<MyMessageScreen> {
  TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String formatTimeStamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.jm().format(dateTime);
    String formattedDate = DateFormat.yMMMd().format(dateTime);
    return "$formattedTime, $formattedDate";
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 113, 70, 213),
                Color.fromARGB(255, 140, 100, 230),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.18),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false, // Remove default leading space
            titleSpacing: 0, // Remove default title padding
            title: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.deepPurple[100],
                  backgroundImage: widget.userSnapshot["profilepic"] != null &&
                          widget.userSnapshot["profilepic"].toString().isNotEmpty
                      ? NetworkImage("${widget.userSnapshot["profilepic"]}")
                      : null,
                  child: widget.userSnapshot["profilepic"] == null ||
                          widget.userSnapshot["profilepic"].toString().isEmpty
                      ? Icon(Icons.person, size: 28, color: Colors.deepPurple[300])
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${widget.userSnapshot["username"]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Optional: Subtle background image or pattern
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.04,
          //     child: Image.asset('assets/chat_bg.png', fit: BoxFit.cover),
          //   ),
          // ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Chat")
                      .where("reciever",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where("sender", isEqualTo: widget.userSnapshot.id)
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, SenderSnapshot) {
                    if (SenderSnapshot.hasData) {
                      var senderMessage = SenderSnapshot.data!.docs;

                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Chat")
                            .where("sender",
                                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .where("reciever", isEqualTo: widget.userSnapshot.id)
                            .orderBy('timestamp')
                            .snapshots(),
                        builder: (context, receiverSnapshot) {
                          if (receiverSnapshot.hasData) {
                            var receiverMessage = receiverSnapshot.data!.docs;

                            var allMessage = [...senderMessage, ...receiverMessage];

                            allMessage.sort(
                              (a, b) => (a["timestamp"] as Timestamp)
                                  .compareTo(b["timestamp"] as Timestamp),
                            );

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToBottom();
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              itemCount: allMessage.length,
                              itemBuilder: (context, index) {
                                var message = allMessage[index];
                                String SENDER_ID = message["sender"];
                                bool isCurrentUserISSender = SENDER_ID ==
                                    FirebaseAuth.instance.currentUser!.uid;

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    mainAxisAlignment: isCurrentUserISSender
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (!isCurrentUserISSender)
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            "${widget.userSnapshot["username"][0].toString().toUpperCase()}",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 113, 70, 213),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      else
                                        SizedBox(width: 36),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Material(
                                          elevation: 2,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(
                                                isCurrentUserISSender ? 20 : 0),
                                            bottomRight: Radius.circular(
                                                isCurrentUserISSender ? 0 : 20),
                                          ),
                                          color: isCurrentUserISSender
                                              ? Color.fromARGB(255, 113, 70, 213)
                                              : Colors.white,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 18),
                                            child: Column(
                                              crossAxisAlignment: isCurrentUserISSender
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${message["message"]}",
                                                  style: TextStyle(
                                                    color: isCurrentUserISSender
                                                        ? Colors.white
                                                        : Colors.deepPurple[900],
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  formatTimeStamp(
                                                      message["timestamp"] as Timestamp),
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (isCurrentUserISSender)
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.person,
                                              color: Color.fromARGB(255, 113, 70, 213)),
                                        )
                                      else
                                        SizedBox(width: 36),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else if (SenderSnapshot.hasError) {
                      return Center(
                        child: Text("Something went wrong"),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Divider(height: 1, color: Colors.deepPurple[50]),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 16),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(color: Colors.deepPurple[900], fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Type your message...",
                              hintStyle: TextStyle(color: Colors.deepPurple[200]),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.send_rounded,
                            color: Color.fromARGB(255, 113, 70, 213),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String? messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance.collection("Chat").add({
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "reciever": widget.userSnapshot.id,
        "message": messageText,
        "timestamp": Timestamp.now(),
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }
}