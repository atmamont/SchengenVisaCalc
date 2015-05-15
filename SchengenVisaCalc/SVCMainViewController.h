//
//  ViewController.h
//  SchengenVisaCalc
//
//  Created by atMamont on 21.04.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVisaCalc.h"

@interface SVCMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tripsTableView;
@property (strong, nonatomic) MainVisaCalc *calc;

@end

