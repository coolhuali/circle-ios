//
//  MyLocationInfo.h
//  OpenFireClient
//
//  Created by admin on 13-9-28.
//  Copyright (c) 2013年 com.cti. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MBaseModel.h"

@interface MyLocationInfo : MBaseModel<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *checkinLocation;
    NSDate *startTime;
    BOOL hasGotLoaction;
}
- (void) updateLocation;
@end
