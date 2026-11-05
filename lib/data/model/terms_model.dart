class TermsModel {
  final String? pageName;
  final String? content;

  TermsModel({this.pageName, this.content});

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
      pageName: json['page_name'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_name': pageName,
      'content': content,
    };
  }
}
