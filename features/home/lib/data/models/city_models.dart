class CityModels {
  bool? status;
  Request? request;
  List<Data>? data;

  CityModels({this.status, this.request, this.data});

  CityModels.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.request != null) {
      data['request'] = this.request?.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Request {
  String? path;
  String? keyword;

  Request({this.path, this.keyword});

  Request.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['keyword'] = this.keyword;
    return data;
  }
}

class Data {
  String? id;
  String? lokasi;

  Data({this.id, this.lokasi});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lokasi = json['lokasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lokasi'] = this.lokasi;
    return data;
  }
}
