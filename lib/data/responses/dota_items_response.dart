import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dota_items_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class DotaItemsResponse extends Equatable {
  final List<DotaItemModel> data;
  final int totalCount;

  const DotaItemsResponse({required this.data, required this.totalCount});

  factory DotaItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$DotaItemsResponseFromJson(json);

  @override
  List<Object?> get props => [data];

  Map<String, dynamic> toJson() => _$DotaItemsResponseToJson(this);
}
