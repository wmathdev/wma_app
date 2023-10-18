import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Workflow {
  int id;
  String state;
  int progress;
  String label;
  String completedAt;
  List<Transactions> tansactions;
  Workflow({
    required this.id,
    required this.state,
    required this.progress,
    required this.label,
    required this.completedAt,
    required this.tansactions,
  });

  Workflow copyWith({
    int? id,
    String? state,
    int? progress,
    String? label,
    String? completedAt,
    List<Transactions>? tansactions,
  }) {
    return Workflow(
      id: id ?? this.id,
      state: state ?? this.state,
      progress: progress ?? this.progress,
      label: label ?? this.label,
      completedAt: completedAt ?? this.completedAt,
      tansactions: tansactions ?? this.tansactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'state': state,
      'progress': progress,
      'label': label,
      'completed_at': completedAt,
      'tansactions': tansactions.map((x) => x.toMap()).toList(),
    };
  }

  factory Workflow.fromMap(Map<String, dynamic> map) {
    return Workflow(
      id: map['id'] as int,
      state: map['state'] as String,
      progress: map['progress'] as int,
      label: map['label'] as String,
      completedAt: map['completed_at'] as String,
      tansactions: List<Transactions>.from((map['tansactions'] as List<int>).map<Transactions>((x) => Transactions.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Workflow.fromJson(String source) =>
      Workflow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Workflow(id: $id, state: $state, progress: $progress, label: $label, completed_at: $completedAt, tansactions: $tansactions)';
  }

  @override
  bool operator ==(covariant Workflow other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.state == state &&
      other.progress == progress &&
      other.label == label &&
      other.completedAt == completedAt &&
      listEquals(other.tansactions, tansactions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      state.hashCode ^
      progress.hashCode ^
      label.hashCode ^
      completedAt.hashCode ^
      tansactions.hashCode;
  }
}

class Transactions {
  int id;
  String reporter;
  String assign;
  String type;
  String createAt;
  String time;
  Signer signer;
  Transactions({
    required this.id,
    required this.reporter,
    required this.assign,
    required this.type,
    required this.createAt,
    required this.time,
    required this.signer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'reporter': reporter,
      'assign': assign,
      'type': type,
      'time': time,
      'created_at': createAt,
      'signer': signer.toMap(),
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'] as int,
      reporter: map['reporter'] as String,
      assign: map['assign'] == null ? '' : map['assign'] as String,
      type: map['type'] as String,
      createAt: map['created_at'] as String,
      time: map['time'] as String,
      signer: Signer.fromMap(map['signer'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source) as Map<String, dynamic>);

  Transactions copyWith({
    int? id,
    String? reporter,
    String? assign,
    String? type,
    String? createAt,
    String? time,
    Signer? signer,
  }) {
    return Transactions(
      id: id ?? this.id,
      reporter: reporter ?? this.reporter,
      assign: assign ?? this.assign,
      type: type ?? this.type,
      createAt: createAt ?? this.createAt,
      time: time ?? this.time,
      signer: signer ?? this.signer,
    );
  }

  @override
  String toString() {
    return 'Transactions(id: $id, reporter: $reporter, assign: $assign, type: $type, createAt: $createAt, signer: $signer)';
  }
}

class Signer {
  String user;
  String? comment;
  Signer({
    required this.user,
    this.comment,
  });

  Signer copyWith({
    String? user,
    String? comment,
  }) {
    return Signer(
      user: user ?? this.user,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'comment': comment,
    };
  }

  factory Signer.fromMap(Map<String, dynamic> map) {
    return Signer(
      user: map['user'] as String,
      comment: map['comment'] != null ? map['comment'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Signer.fromJson(String source) =>
      Signer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Signer(user: $user, comment: $comment)';

  @override
  bool operator ==(covariant Signer other) {
    if (identical(this, other)) return true;

    return other.user == user && other.comment == comment;
  }

  @override
  int get hashCode => user.hashCode ^ comment.hashCode;
}
