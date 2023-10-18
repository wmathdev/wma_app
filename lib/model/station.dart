import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ContactStation {
  int id;
  String name;
  ContactStation({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory ContactStation.fromMap(Map<String, dynamic> map) {
    return ContactStation(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactStation.fromJson(String source) => ContactStation.fromMap(json.decode(source) as Map<String, dynamic>);

  ContactStation copyWith({
    int? id,
    String? name,
  }) {
    return ContactStation(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'ContactStation(id: $id, name: $name)';
}

