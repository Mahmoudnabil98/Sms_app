class SmsModel {
  int? id;
  int? threadId;
  String? address;
  String? body;
  bool? read;
  int? date;
  int? dateSent;
  SmsModel({
    this.address,
    this.body,
    this.date,
    this.dateSent,
    this.id,
    this.read,
    this.threadId,
  });

  SmsModel.fomJson(Map map) {
    address = map['address'];
    body = map['body'];
    date = map['date'];
    dateSent = map['dateSent'];
    id = map['id'];
    read = map['read'];
    threadId = map['threadId'];
  }

  toJson() {
    return {
      'address': address,
      'body': body,
      'dateSent': dateSent,
      'date': date,
      'id': id,
      'read': read == true ? 1 : 0,
      'threadId': threadId,
    };
  }
}
