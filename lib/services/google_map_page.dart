import 'package:Service/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  GoogleMapScreen({Key key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> with AutomaticKeepAliveClientMixin{

  final _locationController = TextEditingController();

   @override
  bool get wantKeepAlive => true;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<LocationProvider>(context,listen:false).initializtion();

  }


  @override
  Widget build(BuildContext context) {
            var applicationBloc = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // title: Text("Map Made by Ayush.
      title: Container(
        child: TextField(
                      controller: _locationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: applicationBloc.selectedLocationStatic.name,
                        // suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) { 
                        
                        applicationBloc.searchPlaces(value);
                        if(value.length >0){
                          applicationBloc.isShowMap = false;

                        }else{
applicationBloc.isShowMap = true;

                        }
                        
                        },
                   
                      // onTap: () => applicationBloc.clearSelectedLocation(),
                    ),
      ),  
        
        ),
    
      body: applicationBloc.isShowMap ==true? googleMapUI(): placeNameSuggestion()
    );
  }


Widget placeNameSuggestion(){
  //  var placeChange = Provider.of<LocationProvider>(context);

return Container(
  height: 500,
  child: Consumer<LocationProvider>(
      builder: (context,model,child){
      if(model.searchResults ==null){
        return Center(child: CircularProgressIndicator());
      }else{
      return ListView.builder(
        itemCount: model.searchResults.length,
        itemBuilder: (context,index){
return ListTile(title: Text(model.searchResults[index].description),
onTap: (){
  // placeChange.setSelectedLocation(model.searchResults[index].placeId);
  model.setSelectedLocation(model.searchResults[index].placeId);
  _locationController.clear();
},
);
      });
      }
      },
    ),
);
}


Widget googleMapUI(){
    return Consumer<LocationProvider>(
      builder: (context,model,child){
      if(model.locationPosition ==null){
        return Center(child: CircularProgressIndicator());
      }else{
      return Column(
        children: [
          Expanded(
            child: GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(
              model.locationPosition.latitude,model.locationPosition.longitude
              // 26.841981, 75.56204450000001
              ),
            zoom: 18
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller){

            },
            markers: Set<Marker>.of(model.markers.values),
            mapType: MapType.normal,
            ),
          ),
        ],
      );
      }
      },
    );
  }
}