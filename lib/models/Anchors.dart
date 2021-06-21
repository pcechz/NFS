class Anchors {
  String uuid;
  String description;
  String verses;
  String prayers;
  String topic;
  String bibleReading;
  String wordOFToday;
  String oneYear;
  Year year;
  Year month;
  Year day;
  String createdAt;
  String updatedAt;

  Anchors(
      {this.uuid,
      this.description,
      this.verses,
      this.bibleReading,
      this.prayers,
      this.oneYear,
      this.wordOFToday,
      this.topic,
      this.year,
      this.month,
      this.day,
      this.createdAt,
      this.updatedAt});

  Anchors.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    description = json['description'];
    prayers = json['prayers'] ?? "";
    bibleReading = json['bible_reading'] ?? "";
    oneYear = json['one_year'] ?? "";
    wordOFToday = json['word_of_today'] ?? "";
    topic = json['topic'] ?? "";
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

    if (this.prayers != null) {
      data['prayers'] = this.prayers;
    }
    if (this.topic != null) {
      data['topic'] = this.topic;
    }
    if (this.wordOFToday != null) {
      data['word_of_today'] = this.wordOFToday;
    }
    if (this.oneYear != null) {
      data['one_year'] = this.oneYear;
    }

    if (this.bibleReading != null) {
      data['bible_reading'] = this.bibleReading;
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
