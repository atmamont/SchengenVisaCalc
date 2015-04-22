//
//  mainVisaCalc.h
//  SchengenVisaCalc
//
//  Created by atMamont on 22.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainVisaCalc : NSObject
+ (void) setEntryDate: (NSDate *) date;
+ (void) setExitDate: (NSDate *) date;

+ (int) getDays:(void)a;
@end
