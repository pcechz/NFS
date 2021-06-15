class Comments {
  int id;
  String userId;
  String firstName;
  String lastName;
  String anchorId;
  String comment;
  String createdAt;
  String updatedAt;

  Comments(
      {this.id,
      this.userId,
      this.firstName,
      this.lastName,
      this.anchorId,
      this.comment,
      this.createdAt,
      this.updatedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    anchorId = json['anchor_id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['anchor_id'] = this.anchorId;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
