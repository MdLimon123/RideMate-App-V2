class PrivacyPolicyModel {
  final String? pageName;
  final String? content;

  PrivacyPolicyModel({this.pageName, this.content});

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
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
