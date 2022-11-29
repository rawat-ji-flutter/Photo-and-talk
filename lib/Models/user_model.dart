import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseModels
{
  Future addUserInfoToDB(
      {required Map<String, dynamic> userInfoMap,required docId}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return  await FirebaseFirestore.instance
        .collection("users")
        .doc(docId)
        .set(userInfoMap);


  }

  Future<QuerySnapshot> getUserInfo(String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();
  }

  Stream<QuerySnapshot> getUserByUserName(String username)  {

    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .snapshots();
  }



  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }
}