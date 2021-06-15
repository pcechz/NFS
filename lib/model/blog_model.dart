class Blog {
  String imageUrl;
  String id;
  String name;
  String slug;
  bool liked;
  String created_at;
  String content;

  Blog(
      {this.imageUrl,
      this.id,
      this.name,
      this.slug,
      this.liked,
      this.created_at,
      this.content,
      String urlToImage});
}

final List<Blog> blogs = [Blog()];
