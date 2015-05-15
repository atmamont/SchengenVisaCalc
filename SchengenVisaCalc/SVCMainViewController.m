//
//  ViewController.m
//  SchengenVisaCalc
//
//  Created by atMamont on 21.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import "SVCMainViewController.h"
#import "SVCTripsTableViewCell.h"
#import "Trip.h"

@interface SVCMainViewController ()

@end

@implementation SVCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    
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
    
    self.calc = [[MainVisaCalc alloc] init];
    
    [self.calc addTrip:startDate and:endDate named:@"Trip1"];
    
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
    
    [self.calc addTrip:startDate and:endDate named:@"Trip3"];
    
    NSInteger totalUsedDays = [self.calc getTotalRemainingDays];
    NSLog(@"Remaining days: %ld", (long)totalUsedDays);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *simpleTableIdentifier = @"SVCTableViewCell";
    
    SVCTripsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[SVCTripsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    Trip *trip = [self.calc.trips objectAtIndex:indexPath.row];
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    cell.dateInLabel.text = [dateFormatter stringFromDate:trip.startDate];
    cell.dateOutLabel.text = [dateFormatter stringFromDate:trip.endDate];
    cell.daysCountLabel.text = [NSString stringWithFormat:@"%ld",[trip getTripDurationBetweenDates:trip.startDate and:trip.endDate]];
  
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.calc.trips count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
}

@end
