class Urls {
  int id;
  String url;

  Urls(
    this.id,
    this.url,
  );

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'urls': url,
      };
}
