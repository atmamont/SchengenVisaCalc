//
//  SVCAddTripViewController.h
//  SchengenVisaCalc
//
//  Created by Vit on 21.05.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVCMainViewController.h"

@interface SVCAddTripViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>


@property (weak, nonatomic) SVCMainViewController *mainViewController;


@property (nonatomic) BOOL isEditing;

@end
