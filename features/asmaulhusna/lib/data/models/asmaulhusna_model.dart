class AsmaulHusnaModels {
  bool? status;
  Request? request;
  Info? info;
  List<Datum>? data;

  AsmaulHusnaModels({this.status, this.request, this.info, this.data});

  factory AsmaulHusnaModels.fromJson(Map<String, dynamic> json) =>
      AsmaulHusnaModels(
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
  int? id;
  String? indo;
  String? latin;

  Datum({this.arab, this.id, this.indo, this.latin});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    arab: json["arab"],
    id: json["id"],
    indo: json["indo"],
    latin: json["latin"],
  );

  Map<String, dynamic> toJson() => {
    "arab": arab,
    "id": id,
    "indo": indo,
    "latin": latin,
  };
}

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
