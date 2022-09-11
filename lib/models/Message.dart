class Message {
  late String senderId, receiverId, dateTime, text;

  Message(
      {required this.text,
      required this.dateTime,
      required this.receiverId,
      required this.senderId});

  Message.fromJson({required Map<String, dynamic> json}) {
    text = json['text']?? "";
    dateTime = json['dateTime'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime': dateTime,
      'receiverId': receiverId,
      'senderId': senderId,
    };
  }
}
