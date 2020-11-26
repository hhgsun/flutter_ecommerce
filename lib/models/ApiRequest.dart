class ApiRequest {
  String page;
  String offset;
  String limit;

  ApiRequest({
    this.page,
    this.limit,
    this.offset,
  });

  Map<String, dynamic> toMap() => {
        "page": this.page,
        "offset": this.offset,
        "limit": this.limit,
      };
}
