//
//  Trip.h
//  SchengenVisaCalc
//
//  Created by atMamont on 29.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property (nonatomic) NSDate* startDate;
@property (nonatomic) NSDate* endDate;
@property (nonatomic) NSString* name;

- (NSDate *) startDate;
- (NSDate *) endDate;

- (NSInteger) getTripDurationBetweenDates: (NSDate *) date1
                                      and: (NSDate *) date2;
@end
