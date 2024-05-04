import 'package:zwap_test/model/post.dart';

class Categories {
  int? id;
  String? name;
  String? description;
  Null? parentId;
  String? createdAt;
  String? updatedAt;

  Categories({
    this.id,
    this.name,
    this.description,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    parentId = json['parent_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['parent_id'] = this.parentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }
}
