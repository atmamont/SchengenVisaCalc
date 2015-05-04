//
//  AppDelegate.m
//  SchengenVisaCalc
//
//  Created by atMamont on 21.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import "AppDelegate.h"
#import "mainVisaCalc.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* date1 = [[NSDateComponents alloc] init];
    [date1 setDay:17];
    [date1 setMonth:11];
    [date1 setYear:2014];
    
    NSDateComponents* date2 = [[NSDateComponents alloc] init];
    [date2 setDay:17];
    [date2 setMonth:12];
    [date2 setYear:2014];

    NSDate* startDate = [cal dateFromComponents:date1];
    NSDate* endDate = [cal dateFromComponents:date2];

    mainVisaCalc* calc = [[mainVisaCalc alloc]init];
    [calc addTrip:startDate and:endDate named:@"Trip1"];
    
    [date1 setDay:01];
    [date1 setMonth:01];
    [date1 setYear:2015];
    
    [date2 setDay:31];
    [date2 setMonth:01];
    [date2 setYear:2015];
    startDate = [cal dateFromComponents:date1];
    endDate = [cal dateFromComponents:date2];
    
//    [calc addTrip:startDate and:endDate named:@"Trip2"];
    
    [date1 setDay:5];
    [date1 setMonth:2];
    [date1 setYear:2015];
    
    [date2 setDay:10];
    [date2 setMonth:2];
    [date2 setYear:2015];
    startDate = [cal dateFromComponents:date1];
    endDate = [cal dateFromComponents:date2];
    
    [calc addTrip:startDate and:endDate named:@"Trip3"];

    NSInteger totalUsedDays = [calc getTotalRemainingDays];
    NSLog(@"Remaining days: %ld", (long)totalUsedDays);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
