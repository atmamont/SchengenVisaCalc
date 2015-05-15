//
//  mainVisaCalc.h
//  SchengenVisaCalc
//
//  Created by atMamont on 22.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

// TO DO LIST
// 1. add init with dates
// 2. checking trips intersections while adding new trip

@interface MainVisaCalc : NSObject
@property (strong, nonatomic) NSMutableArray *trips; // of Trip
@property (strong, nonatomic) NSDate* entryDate; // now by default

- (void) addTrip: (NSDate *) startDate and: (NSDate*) endDate named: (NSString*) name;

- (NSInteger) getTotalRemainingDays;

@end
