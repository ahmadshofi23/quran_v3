class DoaModels {
  bool? status;
  Request? request;
  Info? info;
  List<Datum>? data;

  DoaModels({this.status, this.request, this.info, this.data});

  factory DoaModels.fromJson(Map<String, dynamic> json) => DoaModels(
    status: json["status"],
    request: Request.fromJson(json["request"]),
    info: Info.fromJson(json["info"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "request": request?.toJson(),
    "info": info?.toJson(),
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class Datum {
  String? arab;
  String? indo;
  String? judul;
  Source? source;

  Datum({this.arab, this.indo, this.judul, this.source});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    arab: json["arab"],
    indo: json["indo"],
    judul: json["judul"],
    source: sourceValues.map[json["source"]],
  );

  Map<String, dynamic> toJson() => {
    "arab": arab,
    "indo": indo,
    "judul": judul,
    "source": sourceValues.reverse[source],
  };
}

enum Source { HADITS, HAJI, HARIAN, IBADAH, LAINNYA, PILIHAN, QURAN }

final sourceValues = EnumValues({
  "hadits": Source.HADITS,
  "haji": Source.HAJI,
  "harian": Source.HARIAN,
  "ibadah": Source.IBADAH,
  "lainnya": Source.LAINNYA,
  "pilihan": Source.PILIHAN,
  "quran": Source.QURAN,
});

class Info {
  int? min;
  int? max;

  Info({this.min, this.max});

  factory Info.fromJson(Map<String, dynamic> json) =>
      Info(min: json["min"], max: json["max"]);

  Map<String, dynamic> toJson() => {"min": min, "max": max};
}

class Request {
  String? path;

  Request({this.path});

  factory Request.fromJson(Map<String, dynamic> json) =>
      Request(path: json["path"]);

  Map<String, dynamic> toJson() => {"path": path};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
