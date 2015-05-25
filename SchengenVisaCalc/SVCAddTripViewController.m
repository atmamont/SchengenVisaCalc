//
//  SVCAddTripViewController.m
//  SchengenVisaCalc
//
//  Created by Vit on 21.05.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import "SVCAddTripViewController.h"
#import "Trip.h"

@interface SVCAddTripViewController ()

@end

@implementation SVCAddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.mainViewController.refreshControl.refreshing) {
        NSIndexPath *path = [self.mainViewController.tripsTableView indexPathForSelectedRow];
        Trip *selectedTrip = [self.mainViewController.calc.trips objectAtIndex:path.row];
        self.inDatePicker.date = selectedTrip.startDate;
        self.outDatePicker.date = selectedTrip.endDate;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.mainViewController.refreshControl.refreshing)
        [self.updateButton setTitle:@"Add Trip" forState:UIControlStateNormal];
    else
        [self.updateButton setTitle:@"Update" forState:UIControlStateNormal];
    
}

- (IBAction)updateButtonClick:(id)sender {
    if (!self.mainViewController.refreshControl.refreshing) {
        NSIndexPath *path = [self.mainViewController.tripsTableView indexPathForSelectedRow];
        Trip *selectedTrip = [self.mainViewController.calc.trips objectAtIndex:path.row];
    
        selectedTrip.startDate = self.inDatePicker.date;
        selectedTrip.endDate = self.outDatePicker.date;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.mainViewController.calc addTrip:self.inDatePicker.date and:self.outDatePicker.date named:@""];
        [self.mainViewController.refreshControl endRefreshing];
    }
}

- (IBAction)cancelButtonClick:(id)sender {
    if (self.mainViewController.refreshControl.refreshing)
        [self.mainViewController.refreshControl endRefreshing];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
