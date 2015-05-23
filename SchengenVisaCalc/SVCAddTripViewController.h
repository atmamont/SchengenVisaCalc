//
//  SVCAddTripViewController.h
//  SchengenVisaCalc
//
//  Created by Vit on 21.05.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVCMainViewController.h"

@interface SVCAddTripViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *inDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *outDatePicker;

@property (weak, nonatomic) SVCMainViewController *mainViewController;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic) BOOL isEditing;

@end
