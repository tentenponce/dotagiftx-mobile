import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'catalog_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class CatalogResponse extends Equatable {
  final List<DotaItemModel> data;

  const CatalogResponse({required this.data});

  factory CatalogResponse.fromJson(Map<String, dynamic> json) =>
      _$CatalogResponseFromJson(json);

  @override
  List<Object?> get props => [data];

  Map<String, dynamic> toJson() => _$CatalogResponseToJson(this);
}
