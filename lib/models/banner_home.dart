class BannerHome {
  String title;
  String imageUrl;
  String catId;
  String tagId;

  BannerHome({
    this.title,
    this.imageUrl,
    this.catId,
    this.tagId,
  });

  factory BannerHome.fromJson(Map<String, dynamic> json) => BannerHome(
        title: json['title'],
        imageUrl: json['image_url'],
        catId: json['cat_id'],
        tagId: json['tag_id'],
      );
}
