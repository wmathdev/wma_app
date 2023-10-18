import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  int id;
  String name;
  String email;
  String phoneNumber;
  int roleId;
  int? stationId;
  int status;
  Role role;
  Stations stations;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    this.stationId,
    required this.status,
    required this.role,
    required this.stations,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phoneNumber,
    int? roleId,
    int? stationId,
    int? status,
    Role? role,
    Stations? stations,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roleId: roleId ?? this.roleId,
      stationId: stationId ?? this.stationId,
      status: status ?? this.status,
      role: role ?? this.role,
      stations: stations ?? this.stations,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'role_id': roleId,
      'station_id': stationId,
      'status': status,
      'role': role.toMap(),
      'stations': stations.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map, bool forSharedperference) {
    print(map);
    if (forSharedperference) {
      return User(
        id: map['id'] as int,
        name: map['name'] as String,
        email: map['email'] as String,
        phoneNumber: map['phone_number'] as String,
        roleId: map['role_id'] as int,
        stationId: map['station_id'] != null ? map['station_id'] as int : null,
        status: map['status'] as int,
        role: Role.fromMap(map['role'] as Map<String, dynamic>),
        stations: Stations.fromMap(map['stations']),
      );
    }
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone_number'] as String,
      roleId: map['role_id'] as int,
      stationId: map['station_id'] != null ? map['station_id'] as int : null,
      status: map['status'] as int,
      role: Role.fromMap(map['role'] as Map<String, dynamic>),
      stations: Stations.fromList(map['stations']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source,bool mode) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>,mode);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, roleId: $roleId, stationId: $stationId, status: $status, role: $role, stations: $stations)';
  }
}

class Role {
  int id;
  String slug;
  String name;
  int supervisor;
  Role({
    required this.id,
    required this.slug,
    required this.name,
    required this.supervisor,
  });

  Role copyWith({
    int? id,
    String? slug,
    String? name,
    int? supervisor,
  }) {
    return Role(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      supervisor: supervisor ?? this.supervisor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'slug': slug,
      'name': name,
      'supervisor': supervisor,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'] as int,
      slug: map['slug'] as String,
      name: map['name'] as String,
      supervisor: map['supervisor'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) =>
      Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Role(id: $id, slug: $slug, name: $name, supervisor: $supervisor)';
  }
}

class Stations {
  List<Station> stations;
  Stations({
    required this.stations,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stations': stations.map((x) => x.toMap()).toList(),
    };
  }

  factory Stations.fromList(List<dynamic> map) {
    List<Station> mystations = [];

    for (var i = 0; i < map.length; i++) {
      Station temp = Station.fromMap(map[i]);
      mystations.add(temp);
    }
    return Stations(stations: mystations);
  }



  String toJson() => json.encode(toMap());

  // factory Stations.fromJson(String source) =>
  //     Stations.fromMap(json.decode(source) as Map<String, dynamic>);

  Stations copyWith({
    List<Station>? stations,
  }) {
    return Stations(
      stations: stations ?? this.stations,
    );
  }

  @override
  String toString() => 'Stations(stations: $stations)';

  factory Stations.fromMap(Map<String, dynamic> map) {
    return Stations(
      stations: List<Station>.from((map['stations'] as List<dynamic>).map<Station>((x) => Station.fromMap(x as Map<String,dynamic>),),),
    );
  }

  factory Stations.fromJson(String source) => Stations.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Station {
  int id;
  String name;
  Pivot pivot;

  Station({
    required this.id,
    required this.name,
    required this.pivot,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'pivot': pivot.toMap(),
    };
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      id: map['id'] as int,
      name: map['name'] as String,
      pivot: Pivot.fromMap(map['pivot'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Station.fromJson(String source) =>
      Station.fromMap(json.decode(source) as Map<String, dynamic>);

  Station copyWith({
    int? id,
    int? value,
    String? name,
    Pivot? pivot,
  }) {
    return Station(
      id: id ?? this.id,
      name: name ?? this.name,
      pivot: pivot ?? this.pivot,
    );
  }

  @override
  String toString() {
    return 'Station(id: $id,  name: $name, pivot: $pivot)';
  }
}

class Pivot {
  int userId;
  int stationId;

  Pivot({
    required this.userId,
    required this.stationId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'station_id': stationId,
    };
  }

  factory Pivot.fromMap(Map<String, dynamic> map) {
    return Pivot(
      userId: map['user_id'] as int,
      stationId: map['station_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pivot.fromJson(String source) =>
      Pivot.fromMap(json.decode(source) as Map<String, dynamic>);

  Pivot copyWith({
    int? userId,
    int? stationId,
  }) {
    return Pivot(
      userId: userId ?? this.userId,
      stationId: stationId ?? this.stationId,
    );
  }

  @override
  String toString() => 'Pivot(userId: $userId, stationId: $stationId)';
}
