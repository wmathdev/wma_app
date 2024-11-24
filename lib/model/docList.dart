import 'dart:convert';

import 'package:wma_app/model/doc.dart';

class DocList {
  List<Doc> id;
  String status;

  DocList({
    required this.id,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    List<int> data = [];
    for (var i = 0; i < id.length; i++) {
      data.add(id[i].id);
    }
    String str = jsonEncode(data);
    return <String, dynamic>{
      'document_ids': str,
      'status': status,
    };
  }

  factory DocList.fromMap(Map<String, dynamic> map) {
    return DocList(
      id: List<Doc>.from((map['document_ids'] as List<int>)
          .map<Doc>((x) => Doc.fromMap(x as Map<String, dynamic>))),
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DocList.fromJson(String source) =>
      DocList.fromMap(json.decode(source) as Map<String, dynamic>);

  // Doc copyWith({
  //   List<Doc> id,
  //   String? status,
  // }) {
  //   return Doc(
  //     id: id ?? this.id,
  //     status: status ?? this.status,
  //   );
  // }
}
