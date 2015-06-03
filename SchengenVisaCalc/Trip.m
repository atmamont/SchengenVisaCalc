//
//  Trip.m
//  SchengenVisaCalc
//
//  Created by atMamont on 29.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import "Trip.h"

@implementation Trip

- (instancetype)init
{
    self = [super init];
    if (self) {
}
    return self;
}


- (NSInteger) getTripDurationBetweenDates: (NSDate *) date1
                                      and: (NSDate *) date2
{
    
    NSDate* startDate_ = self.startDate == nil ? [[NSDate alloc]init] : self.startDate;
    NSDate* endDate_   = self.endDate == nil ? [[NSDate alloc]init] : self.endDate;
    
    // checking for out of period
    if ([[endDate_ earlierDate:date1] isEqualToDate:endDate_] || [[startDate_ laterDate:date2] isEqualToDate:startDate_]) return 0;
    // check for period intersections
    if ([[date1 laterDate:startDate_] isEqualToDate:date1] && [[date1 earlierDate:endDate_] isEqualToDate:date1])
    {
        startDate_ = date1;
    }
    if ([[date2 earlierDate:endDate_] isEqualToDate:date2] && [[date2 laterDate:startDate_] isEqualToDate:date2])
    {
        endDate_ = date2;
    }
    
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [cal components:NSCalendarUnitDay
                                                        fromDate:startDate_
                                                          toDate:endDate_
                                                         options:0];
    
    // all calculations with HMS = 00:00:00 so need to add 1 day
    return [components day]+1;

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Trip named %@ period: %@ - %@", self.name, self.startDate, self.endDate];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil)
    {
        _startDate = [aDecoder decodeObjectForKey:@"StartDate"];
        _endDate = [aDecoder decodeObjectForKey:@"EndDate"];
        _name = [aDecoder decodeObjectForKey:@"Name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_startDate forKey:@"StartDate"];
    [aCoder encodeObject:_endDate forKey:@"EndDate"];
    [aCoder encodeObject:_name forKey:@"Name"];
}

@end
