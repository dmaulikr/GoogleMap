//
//  ViewController.m
//  GoogleMap
//
//  Created by Ravi on 03/08/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "WebService.h"
#import "GoogleSearchLocationTableViewCell.h"

#define POST_REQUEST                                                        @"POST"
#define GET_REQUEST                                                         @"GET"

#define GOOGLE_API_KEY                                                      @"AIzaSyBta5jqM-1C9iMoDYgtuSFdmYkz-kbdd8M"
#define LAT_LONG_API_TO_GET_ADDRESS(Lat,Long,GOOGLE_API_KEY)                [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=%@",Lat,Long,GOOGLE_API_KEY]
#define GoogleAutoCompletWS(GOOGLE_API_KEY, strValue)                       [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&input=%@",GOOGLE_API_KEY,strValue]
#define GooglePlaceLatLogWS(GOOGLE_API_KEY, strPlaceID)                     [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",strPlaceID,GOOGLE_API_KEY]

@interface ViewController ()<CLLocationManagerDelegate,GMSMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    __weak IBOutlet UIActivityIndicatorView *indicatorView;
    __weak IBOutlet UITableView *tblGoogleSearch;
    __weak IBOutlet UITextField *txtSearch;
    
    NSMutableArray *arrMapSearch;
}

@property (strong, nonatomic) IBOutlet GMSMapView *mapContainerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Location
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    //GoogleMap Settings
    self.mapContainerView.myLocationEnabled = YES;
    self.mapContainerView.settings.myLocationButton = YES;
    self.mapContainerView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
    self.mapContainerView.settings.compassButton = YES;
    self.mapContainerView.mapType = kGMSTypeTerrain;
    
    [self startLocationManager];
    /*
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        marker.title = @"Sydney";
        marker.snippet = @"Australia";
        marker.map = self.mapContainerView;
     */
    tblGoogleSearch.hidden=YES;
    indicatorView.hidden=YES;
    
    arrMapSearch = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}
- (void)startLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil)
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                                longitude:currentLocation.coordinate.longitude
                                                                     zoom:16];
        self.mapContainerView.camera = camera;
        
    }
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            placemark = [placemarks lastObject];
            NSString *currentLocation = [NSString stringWithFormat:@"%@,%@", placemark.locality, placemark.country];
            NSLog(@"%@",currentLocation.description);
            [locationManager stopUpdatingLocation];
        }
    }];
}

#pragma mark - GoogleMap Delegate
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

#pragma mark - API Call
- (void)CallLocationGetAddress:(double)Lat Long:(double)Long
{
    CLGeocoder *ceo = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:Lat longitude:Long];
    
    [ceo reverseGeocodeLocation: loc completionHandler:^(NSArray *placemarks, NSError *error)
    {
         CLPlacemark *placemarkLocation = [placemarks objectAtIndex:0];
         NSLog(@"==============================================");
         NSLog(@"placemark :-%@",placemarkLocation);
        
         //String to hold address
         NSString *locatedAt = [[placemarkLocation.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary:\n%@",placemarkLocation.addressDictionary);
        
         NSLog(@"==============================================");
         NSLog(@"region                         :-%@",placemarkLocation.region);
         NSLog(@"country                        :-%@",placemarkLocation.country);  // Give Country Name
         NSLog(@"locality                       :-%@",placemarkLocation.locality); // Extract the city name
         NSLog(@"name                           :-%@",placemarkLocation.name);
         NSLog(@"ocean                          :-%@",placemarkLocation.ocean);
         NSLog(@"postalCode                     :-%@",placemarkLocation.postalCode);
         NSLog(@"subLocality                    :-%@",placemarkLocation.subLocality);
         NSLog(@"ISOcountryCode                 :-%@",placemarkLocation.ISOcountryCode);
         NSLog(@"administrativeArea             :-%@",placemarkLocation.administrativeArea);
         NSLog(@"subAdministrativeArea          :-%@",placemarkLocation.subAdministrativeArea);
         NSLog(@"subLocality                    :-%@",placemarkLocation.subLocality);
         NSLog(@"thoroughfare                   :-%@",placemarkLocation.thoroughfare);
         NSLog(@"subThoroughfare                :-%@",placemarkLocation.subThoroughfare);
         NSLog(@"timeZone                       :-%@",placemarkLocation.timeZone);
         NSLog(@"location                       :-%@",placemarkLocation.location);
         NSLog(@"==============================================");
         //Print the location to console
         NSLog(@"I am currently at :-%@",locatedAt);
         NSLog(@"==============================================");
     }];
}

#pragma mark - SearchLocationAPICall
-(void)APISearchLocation:(NSString *)str
{
    indicatorView.hidden=NO;
    [indicatorView startAnimating];
    [WebService callApiWithParameters:@{} apiName:GoogleAutoCompletWS(GOOGLE_API_KEY, str) type:GET_REQUEST responseData:^(NSDictionary *response, NSError *error)
     {
         indicatorView.hidden=YES;
         [indicatorView stopAnimating];
         NSLog(@"%@",response.description);
         [arrMapSearch removeAllObjects];
         arrMapSearch = [response valueForKey:@"predictions"];
         [tblGoogleSearch reloadData];
     }];
}
-(void)APIForTapLocationSearch:(NSString *)str
{
    indicatorView.hidden=NO;
    [indicatorView startAnimating];
    [WebService callApiWithParameters:@{} apiName:GooglePlaceLatLogWS(GOOGLE_API_KEY, str) type:GET_REQUEST responseData:^(NSDictionary *response, NSError *error)
     {
         indicatorView.hidden=YES;
         [indicatorView stopAnimating];
         [txtSearch resignFirstResponder];
         NSLog(@"%@",response.description);
         tblGoogleSearch.hidden=YES;

         GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[response valueForKeyPath:@"result.geometry.location.lat"] floatValue]
                                                                 longitude:[[response valueForKeyPath:@"result.geometry.location.lng"] floatValue]
                                                                      zoom:16];
         self.mapContainerView.camera = camera;
     }];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMapSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoogleSearchLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.lblSearch.text = [NSString stringWithFormat:@"%@",[[arrMapSearch valueForKey:@"description"] objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strPlaceID = [NSString stringWithFormat:@"%@",[[arrMapSearch valueForKey:@"place_id"] objectAtIndex:indexPath.row]];
    txtSearch.text=[NSString stringWithFormat:@"%@",[[arrMapSearch valueForKey:@"description"] objectAtIndex:indexPath.row]];
    [self APIForTapLocationSearch:strPlaceID];
}

#pragma mark - UITextFielddelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    tblGoogleSearch.hidden = NO;
    NSString *substring = [NSString stringWithString:txtSearch.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self APISearchLocation:substring];
    return YES;
}
-(IBAction)TextFielDEditOfMapLocationSearch:(id)sender
{
    if ([txtSearch.text isEqualToString:@""])
    {
        tblGoogleSearch.hidden=YES;
    }
    else if ([txtSearch.text length] == 0)
    {
        tblGoogleSearch.hidden=YES;
    }
    else
    {
        tblGoogleSearch.hidden=NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
