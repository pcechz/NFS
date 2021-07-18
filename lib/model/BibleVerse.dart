class BibleVerse {
  String bookId;
  String bookName;
  int chapter;
  int verse;
  String text;

  BibleVerse({this.bookId, this.bookName, this.chapter, this.verse, this.text});

  BibleVerse.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookName = json['book_name'];
    chapter = json['chapter'];
    verse = json['verse'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['book_name'] = this.bookName;
    data['chapter'] = this.chapter;
    data['verse'] = this.verse;
    data['text'] = this.text;
    return data;
  }
}