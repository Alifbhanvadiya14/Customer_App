
import 'package:Service/services/api_services.dart';
import 'package:Service/src/Models/places_model.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier{

  BitmapDescriptor _pinLocationIcon;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon;

  Map<MarkerId,Marker> _markers;
    Map<MarkerId,Marker> get markers => _markers;

    final MarkerId markerId = MarkerId("1");

Location _location;
Location get location => _location;

LatLng _locationPosition;
LatLng get locationPosition => _locationPosition;

bool locationServiceActive = false;



// PLace Provider 
  final placesService = ApiService();
   Place selectedLocationStatic = Place(name: "Fetching");

  List<PlaceSearch> searchResults;

bool isShowMap;

 searchPlaces(String searchTerm) async {
   searchResults=[];
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    // selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
_locationPosition = LatLng(selectedLocationStatic.geometry.location.lat, selectedLocationStatic.geometry.location.lng);
    searchResults = null;
    isShowMap =true;
    notifyListeners();
  }







LocationProvider(){
  _location = Location();
}

initializtion()async{
await getuserLocation();
await setCustomMapPin();
isShowMap = true;
print("map initializtoin");
}

getuserLocation() async{

  bool _serviceEnabled;
  PermissionStatus _permisionGranted;

  _serviceEnabled = await location.serviceEnabled();

  if(!_serviceEnabled){
    _serviceEnabled  = await location.requestService();

    if(!_serviceEnabled){
      return;
    }
  }

  _permisionGranted = await location.hasPermission();

  if(_permisionGranted == PermissionStatus.denied){
    _permisionGranted = await location.requestPermission();
    if(_permisionGranted != PermissionStatus.granted){
return;
    }

  }

  location.getLocation().then((LocationData currentLocation) => {
_locationPosition = LatLng(currentLocation.latitude, currentLocation.longitude)

  });

  location.onLocationChanged.listen((LocationData currentLocation) {
// _locationPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
print(_locationPosition);

_markers = Map<MarkerId,Marker>();
Marker marker = Marker(markerId: markerId,position: LatLng(_locationPosition.latitude, _locationPosition.longitude),
icon: pinLocationIcon,draggable: true,
onDragEnd: (newPosition){
_locationPosition = LatLng(newPosition.latitude, newPosition.latitude);
notifyListeners();
});
_markers[markerId] = marker;
notifyListeners();
  });
  
}

setCustomMapPin() async{
_pinLocationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 5), "assets/marker.png");
}

}