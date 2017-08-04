# GoogleMap
Get Current Location, Location Search API, add custom pin so on.

# Show Map and Location 
```
@property (strong, nonatomic) IBOutlet GMSMapView *mapContainerView;

//GoogleMap Settings
self.mapContainerView.myLocationEnabled = YES;
self.mapContainerView.settings.myLocationButton = YES;
self.mapContainerView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
self.mapContainerView.settings.compassButton = YES;
self.mapContainerView.mapType = kGMSTypeTerrain;

GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:16];
self.mapContainerView.camera = camera;

GMSMarker *marker = [[GMSMarker alloc] init];
marker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
marker.title = @"Current Location";
marker.snippet = @"Current Location";
marker.map = self.mapContainerView;

```

# GoogleMap Delegate
Mehods for GoogleMap location update and finished.
- ```GMSMapViewDelegate``` GoogleMap delegate should be required.
```
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    NSLog(@"LAT:%f LONG:%f",latitude,longitude);
    
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    [self CallLocationGetAddress:latitude Long:longitude];
    NSLog(@"Complited LAT:%f LONG:%f",latitude,longitude);
}
```

# GoogleMap URL
- Send Latitude and Longitude to get full address of location.
```
[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=%@",Lat,Long,GOOGLE_API_KEY]
```
- GoogleMap Search API.
```
[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&input=%@",GOOGLE_API_KEY,strValue]
```
- Send PlaceID to get location of latitude and longitude.
```
[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",strPlaceID,GOOGLE_API_KEY]
```
