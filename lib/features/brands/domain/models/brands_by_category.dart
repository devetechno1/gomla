import 'package:sixam_mart/features/category/domain/models/category_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';

class BrandByCategoryModel {
  CategoryModel? id;
  ItemModel? moduleId;


  BrandByCategoryModel({
    this.id,
    this.moduleId,

  });

  BrandByCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['module_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_id'] = moduleId;

    return data;
  }
}
