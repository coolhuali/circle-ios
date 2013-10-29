//
//  MyLocationInfo.m
//  OpenFireClient
//
//  Created by admin on 13-9-28.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import "MyLocationInfo.h"
#import "JSONKit.h"

@implementation MyLocationInfo

- (void) updateLocation {
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        locationManager.delegate = self;
        //locationManager.distanceFilter = 10;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        startTime = [NSDate date];
        hasGotLoaction = NO;
        //启动请求：
        [locationManager startUpdatingLocation];
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
        /*self.locationManager.delegate = self;
         self.locationManager.distanceFilter = 1000;
         locationManager.desiredAccuracy = kCLLocationAccuracyBest;
         [self.locationManager startUpdatingLocation];*/
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"Starting CLLocationManager didFailWithError");
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if(hasGotLoaction && [newLocation.timestamp timeIntervalSinceDate:startTime]>20)
    {
        NSLog(@"this is just taking too long");
        [locationManager stopUpdatingLocation];
        return;
    }
    if(newLocation.horizontalAccuracy>100 && newLocation.verticalAccuracy>100){
        NSLog(@"newLocation horizontalAccuracy more than 100");
        return;
    }
    //使用下面代码停止请求
    [locationManager stopUpdatingLocation];
    hasGotLoaction = YES;
    checkinLocation = newLocation;
    //do something else
    //可以使用下面代码从CLLocation 实例中获取经纬度
    //经度
    double latitude = newLocation.coordinate.latitude;
    //纬度
    double longitude = newLocation.coordinate.longitude;
    //使用下面代码获取你的海拔：
    double altitude = newLocation.altitude;
    //使用下面代码获取你的位移：
    double distance = [oldLocation distanceFromLocation:newLocation];
    NSString *ns_latitude = [[NSNumber numberWithDouble:latitude] stringValue];
    NSString *ns_longitude = [[NSNumber numberWithDouble:longitude] stringValue];
    NSString *ns_altitude = [[NSNumber numberWithDouble:altitude] stringValue];
    NSString *ns_distance = [[NSNumber numberWithDouble:distance] stringValue]; 
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];  
    [geocoder  reverseGeocodeLocation: newLocation completionHandler:
    ^(NSArray *placemarks, NSError *error) {
        //NSMutableArray *items = [[NSMutableArray arrayWithCapacity:1] init];
        CLPlacemark *placemark = placemarks[placemarks.count-1];
        //for (CLPlacemark *placemark in placemarks) {
            NSLog(@"location----------name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",placemark.name,placemark.country,placemark.postalCode,placemark.ISOcountryCode,placemark.ocean,placemark.inlandWater,placemark.administrativeArea,placemark.subAdministrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare);
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            [item setObject:ns_latitude forKey:@"latitude"];
            [item setObject:ns_longitude forKey:@"longitude"];
            [item setObject:ns_altitude forKey:@"altitude"];
            [item setObject:ns_distance forKey:@"distance"];
            if(placemark.name!=nil)
                [item setObject:placemark.name forKey:@"name"];
            if(placemark.country!=nil)
                [item setObject:placemark.country forKey:@"country"];
            if(placemark.postalCode!=nil)
                [item setObject:placemark.postalCode forKey:@"postalCode"];
            if(placemark.ISOcountryCode!=nil)
                [item setObject:placemark.ISOcountryCode forKey:@"ISOcountryCode"];
            if(placemark.ocean!=nil)
                [item setObject:placemark.ocean forKey:@"ocean"];
            if(placemark.inlandWater!=nil)
                [item setObject:placemark.inlandWater forKey:@"inlandWater"];
            if(placemark.administrativeArea!=nil)
                [item setObject:placemark.administrativeArea forKey:@"administrativeArea"];
            if(placemark.subAdministrativeArea!=nil)
                [item setObject:placemark.subAdministrativeArea forKey:@"subAdministrativeArea"];
            if(placemark.locality!=nil)
                [item setObject:placemark.locality forKey:@"locality"];
            if(placemark.subLocality!=nil)
                [item setObject:placemark.subLocality forKey:@"subLocality"];
            if(placemark.thoroughfare!=nil)
                [item setObject:placemark.thoroughfare forKey:@"thoroughfare"];
            if(placemark.subThoroughfare!=nil)
            [item setObject:placemark.subThoroughfare forKey:@"subThoroughfare"];
            //[items addObject:item];
        //}
     [self updateLoactionToServer:item completed:^(NSObject *result, BOOL hasError) {
         
     }];
    }];
    locationManager = nil;
}
-(void) updateLoactionToServer:(NSDictionary *)dict completed:(ActionCompletedBlock)completedBlock{
    
    [self postRequest:[NSString stringWithFormat:API_LOCATION_UPDATE_URL] before:^(ASIHTTPRequest *request) {
        ASIFormDataRequest *_request=(ASIFormDataRequest*)request;
        NSArray *array = dict.allKeys;
        for(int i=0;i<array.count;i++){
            [_request addPostValue:[dict objectForKey:array[i]] forKey:array[i]];
        }
    } completed:^(NSObject *result, BOOL hasError) {
        if(completedBlock) completedBlock(result,hasError);
    }];
}
@end
