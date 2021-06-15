class Anchors {
  String uuid;
  String description;
  String verses;
  Year year;
  Year month;
  Year day;
  String createdAt;
  String updatedAt;

  Anchors(
      {this.uuid,
      this.description,
      this.verses,
      this.year,
      this.month,
      this.day,
      this.createdAt,
      this.updatedAt});

  Anchors.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    description = json['description'];
    verses = json['verses'];
    year = json['year'] != null ? new Year.fromJson(json['year']) : null;
    month = json['month'] != null ? new Year.fromJson(json['month']) : null;
    day = json['day'] != null ? new Year.fromJson(json['day']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['description'] = this.description;
    data['verses'] = this.verses;
    if (this.year != null) {
      data['year'] = this.year.toJson();
    }
    if (this.month != null) {
      data['month'] = this.month.toJson();
    }
    if (this.day != null) {
      data['day'] = this.day.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Year {
  int id;
  String name;
  String createdAt;
  String updatedAt;

  Year({this.id, this.name, this.createdAt, this.updatedAt});

  Year.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
