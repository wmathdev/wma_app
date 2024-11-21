// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Doc {
  int id;

  Doc({
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }

  factory Doc.fromMap(Map<String, dynamic> map) {
    return Doc(
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Doc.fromJson(String source) =>
      Doc.fromMap(json.decode(source) as Map<String, dynamic>);

  Doc copyWith({
    int? id,
  }) {
    return Doc(
      id: id ?? this.id,
    );
  }

  @override
  String toString() => 'Doc(id: $id)';
}
