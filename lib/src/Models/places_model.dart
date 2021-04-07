
// import 'package:LocationCordinate/LocationCordinate.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String vicinity;

  Place({this.name,this.vicinity,this.geometry});

  factory Place.fromJson(Map<String,dynamic> json){
    return Place(
        geometry:  Geometry.fromJson(json['geometry']),
        name: json['formatted_address'],
        vicinity: json['vicinity'],
    );
  }
}
  
class PlaceSearch {
  final String description;
  final String placeId;

  PlaceSearch({this.description, this.placeId});

  factory PlaceSearch.fromJson(Map<String,dynamic> json){
    return PlaceSearch(
        description: json['description'],
        placeId: json['place_id']
    );
  }
}


class Geometry {
  final LocationCordinate location;

  Geometry({this.location});

  Geometry.fromJson(Map<dynamic,dynamic> parsedJson)
      :location = LocationCordinate.fromJson(parsedJson['location']);
}

class LocationCordinate{
  final double lat;
  final double lng;

  LocationCordinate({this.lat, this.lng});

  factory LocationCordinate.fromJson(Map<dynamic,dynamic> parsedJson){
    return LocationCordinate(
        lat: parsedJson['lat'],
        lng: parsedJson['lng']
    );
  }

}