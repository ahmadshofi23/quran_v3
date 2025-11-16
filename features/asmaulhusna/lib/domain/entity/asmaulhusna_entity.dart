class AsmaulhusnaEntity {
  final String? arab;
  final int? id;
  final String? indo;
  final String? latin;
  AsmaulhusnaEntity({this.arab, this.id, this.indo, this.latin});

  AsmaulhusnaEntity copyWith({
    String? arab,
    int? id,
    String? indo,
    String? latin,
  }) => AsmaulhusnaEntity(
    arab: arab ?? this.arab,
    id: id ?? this.id,
    indo: indo ?? this.indo,
    latin: latin ?? this.latin,
  );

  Map<String, dynamic> toMap() {
    return {'arab': arab, 'id': id, 'indo': indo, 'latin': latin};
  }

  factory AsmaulhusnaEntity.fromMap(Map<String, dynamic> map) {
    return AsmaulhusnaEntity(
      arab: map['arab'] as String?,
      id: map['id'] as int?,
      indo: map['indo'] as String?,
      latin: map['latin'] as String?,
    );
  }
}
