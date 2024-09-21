class RequestList {
  int? property_id;
  String? property_name;
  String? property_un;
  String? property_isAvailable;
  int? property_price;
  int? property_area;
  String? property_areaUnit;
  String? property_locality;
  String? property_city;
  List? pi_name;
  String? total_rating;
  int? review_count;

  RequestList(
      {this.property_id,
        this.property_name,
        this.property_un,
        this.property_isAvailable,
        this.property_price,
        this.property_area,
        this.property_areaUnit,
        this.property_locality,
        this.property_city,
        this.pi_name,
        this.total_rating,
        this.review_count
      });


  RequestList.fromJson(Map<String,dynamic> json){
    property_id = json['property_id'];
    property_name = json['property_name'];
    property_un = json['property_un'];
    property_isAvailable = json['property_isAvailable'];
    property_price = json['property_price'];
    property_area = json['property_area'];
    property_areaUnit = json['property_areaUnit'];
    property_locality = json['property_locality'];
    property_city = json['property_city'];
    pi_name = json['pi_name'];
    total_rating = json['total_rating'];
    review_count =  json['review_count'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data =  <String,dynamic>{};
    data['property_id'] = property_id;
    data['property_name'] = property_name;
    data['property_un'] = property_un;
    data['property_isAvailable'] = property_isAvailable;
    data['property_price'] = property_price;
    data['property_area'] = property_area;
    data['property_areaUnit'] = property_areaUnit;
    data['property_locality'] = property_locality;
    data['property_city'] = property_city;
    data['pi_name'] = pi_name;
    data['total_rating'] = total_rating;
    data['review_count'] = review_count;
    return data;
  }


}