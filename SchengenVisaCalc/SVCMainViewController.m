//
//  ViewController.m
//  SchengenVisaCalc
//
//  Created by atMamont on 21.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import "SVCMainViewController.h"
#import "SVCAddTripViewController.h"
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
    NSDateComponents* date2 = [[NSDateComponents alloc] init];
    NSDate* startDate;
    NSDate* endDate;
    
    self.calc = [[MainVisaCalc alloc] init];

    // TRIP 1
    [date1 setDay:5];
    [date1 setMonth:2];
    [date1 setYear:2015];
    
    [date2 setDay:10];
    [date2 setMonth:4];
    [date2 setYear:2015];
    startDate = [cal dateFromComponents:date1];
    endDate = [cal dateFromComponents:date2];
    
    [self.calc addTrip:startDate and:endDate named:@"Trip3"];
 
    // TRIP 2
    [date1 setDay:01];
    [date1 setMonth:01];
    [date1 setYear:2015];
    
    [date2 setDay:31];
    [date2 setMonth:01];
    [date2 setYear:2015];
    startDate = [cal dateFromComponents:date1];
    endDate = [cal dateFromComponents:date2];
    
    [self.calc addTrip:startDate and:endDate named:@"Trip2"];

    // TRIP3
    [date1 setDay:17];
    [date1 setMonth:11];
    [date1 setYear:2014];
    
    [date2 setDay:17];
    [date2 setMonth:12];
    [date2 setYear:2014];
    startDate = [cal dateFromComponents:date1];
    endDate = [cal dateFromComponents:date2];

    [self.calc addTrip:startDate and:endDate named:@"Trip1"];
    
    NSInteger totalUsedDays = [self.calc getTotalRemainingDays];
    NSLog(@"Remaining days: %ld", (long)totalUsedDays);
    
    
    self.daysCounterView = [[JDFlipNumberView alloc] initWithDigitCount:2];
    self.daysCounterView.value = 99;
    [self.view addSubview:self.daysCounterView];
  
    self.daysCounterView.frame = CGRectMake(65,75,250,180);
    
    // add UIRefreshView
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tripsTableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(addNewTrip:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.daysCounterView];
    [self updateDaysCounter];
    [self.tripsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


// ================= ==== TABLEVIEW STUFF
// ======================================

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
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
  
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return [self.calc.trips count];
}

// ===== Swipe to delete.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.calc.trips removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateDaysCounter];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"PushAddTripScreen" sender:self];
}


// ================= >>>> END OF TABLEVIEW STUFF


- (void)updateDaysCounter {
    
    if (self.daysCounterView) {
        NSInteger totalUsedDays = [self.calc getTotalRemainingDays];
        if (totalUsedDays != self.daysCounterView.value)
            [self.daysCounterView animateToValue:totalUsedDays duration:2];
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SVCAddTripViewController *nextScreen = [segue destinationViewController];
    nextScreen.mainViewController = self;
}

- (void)addNewTrip:(UIRefreshControl *)controller {
    [self performSegueWithIdentifier:@"PushAddTripScreen" sender:self];
}

@end
