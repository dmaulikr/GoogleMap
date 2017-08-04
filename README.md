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
