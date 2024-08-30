class Order {

  String createDate;
  String stage;
  String fullId;
  String price;
  String submissionDate;
  String phoneNumber;

  Order({
  required this.createDate,required this.stage,
    required this.fullId,
    required this.price,
    required this.submissionDate,
    required this.phoneNumber
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      createDate: json['Create Date'],
      stage: json['Stage'],
      fullId: json['Full_ID'],
      price: json['Price'],
      submissionDate: json['Submission_Date'],
      phoneNumber: json['Mobile_Number']
    );
  }
}