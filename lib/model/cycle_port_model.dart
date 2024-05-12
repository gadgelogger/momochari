import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle_port_model.freezed.dart';
part 'cycle_port_model.g.dart';

@freezed
class CyclePort with _$CyclePort {
  const factory CyclePort({
    required String name,
    required String rent,
    required String returnNumber,
    required String lat,
    required String lng,
    required String imageAsset,
  }) = _CyclePort;

  factory CyclePort.fromJson(Map<String, dynamic> json) =>
      _$CyclePortFromJson(json);
}
