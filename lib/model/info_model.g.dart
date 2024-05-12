// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InfoModelImpl _$$InfoModelImplFromJson(Map<String, dynamic> json) =>
    _$InfoModelImpl(
      title: json['title'] as String,
      date: json['date'] as String,
      imageUrl: json['imageUrl'] as String,
      articleUrl: json['articleUrl'] as String,
    );

Map<String, dynamic> _$$InfoModelImplToJson(_$InfoModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date,
      'imageUrl': instance.imageUrl,
      'articleUrl': instance.articleUrl,
    };
