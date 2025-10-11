class HadistModels {
  bool? status;
  Request? request;
  Info? info;
  List<Datum>? data;

  HadistModels({this.status, this.request, this.info, this.data});

  factory HadistModels.fromJson(Map<String, dynamic> json) => HadistModels(
    status: json["status"],
    request: Request.fromJson(json["request"]),
    info: Info.fromJson(json["info"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "request": request?.toJson(),
    "info": info?.toJson(),
    "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
  };
}

class Datum {
  String? arab;
  String? indo;
  String? judul;
  String? no;

  Datum({this.arab, this.indo, this.judul, this.no});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    arab: json["arab"],
    indo: json["indo"],
    judul: json["judul"],
    no: json["no"],
  );

  Map<String, dynamic> toJson() => {
    "arab": arab,
    "indo": indo,
    "judul": judul,
    "no": no,
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
