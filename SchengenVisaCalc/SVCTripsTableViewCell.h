//
//  SVCTripsTableViewCell.h
//  SchengenVisaCalc
//
//  Created by Vit on 15.05.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCTripsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateInLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripDescriptionLabel;

@end
