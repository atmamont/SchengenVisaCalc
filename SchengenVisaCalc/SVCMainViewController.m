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

- (void)saveTripsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.calc.trips.count == 0)
    {
        [userDefaults removeObjectForKey:@"Trips"];
    }
    else
    {
        NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:self.calc.trips.count];
        for (Trip *trip in self.calc.trips)
        {
            NSData *tripEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:trip];
            [archiveArray addObject:tripEncodedObject];
            
            [userDefaults setObject:archiveArray forKey:@"Trips"];
        }
    }
    [userDefaults synchronize];
}

- (void)loadTripsData
{
    NSArray *archiveArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"Trips"];
    if (archiveArray != nil)
    {
        for (NSData *trip in archiveArray)
        {
            Trip  *unarchivedTrip = [NSKeyedUnarchiver unarchiveObjectWithData:trip];
            if (unarchivedTrip != nil) [self.calc.trips addObject:unarchivedTrip];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.calc = [[MainVisaCalc alloc] init];
    
    [self loadTripsData];
    
    NSInteger totalUsedDays = [self.calc getTotalRemainingDays];
    NSLog(@"Remaining days: %ld", (long)totalUsedDays);
    
    self.daysCounterView = [[JDFlipNumberView alloc] initWithDigitCount:2];
    self.daysCounterView.value = 89;
    [self.view addSubview:self.daysCounterView];
  
    // self.daysCounterView.frame = CGRectMake(65,75,250,180);
    int targetWidth = self.view.frame.size.width / 1.5 - 100;
    int targetHeight = self.view.frame.size.height / 3.7;
    
    self.daysCounterView.frame = CGRectMake(65,75,targetWidth, targetHeight);
    
    // add UIRefreshView
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tripsTableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self action:@selector(addNewTrip:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.daysCounterView];
    self.daysCounterView.value = [self.calc getTotalRemainingDays];
    [self.tripsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


// ====================== TABLEVIEW STUFF
// ======================================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *simpleTableIdentifier = @"SVCTableViewCell";
    
    SVCTripsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[SVCTripsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    Trip *trip = [self.calc.trips objectAtIndex:indexPath.row];
   
    // if there is no description - move days counter a little bit lower
    if ([trip.name isEqualToString:@""])
        cell.daysCountLabel.center = CGPointMake(cell.daysCountLabel.center.x, 40);
    else
        cell.daysCountLabel.center = CGPointMake(cell.daysCountLabel.center.x, 30);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    cell.dateInLabel.text = [dateFormatter stringFromDate:trip.startDate];
    
    if (trip.endDate != nil)
    {
        cell.dateOutLabel.text = [dateFormatter stringFromDate:trip.endDate];
        cell.daysCountLabel.text = [NSString stringWithFormat:@"%ld",[trip getTripDurationBetweenDates:trip.startDate and:trip.endDate]];
    }
    else
    {
        cell.dateOutLabel.text = @"In process";
        cell.daysCountLabel.text = [NSString stringWithFormat:@"%ld",[trip getTripDurationBetweenDates:trip.startDate and:[NSDate date]]];
    }
    
    
    cell.tripDescriptionLabel.text = trip.name;
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
        
        [self saveTripsData];
        
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
        //self.daysCounterView.value++;
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
