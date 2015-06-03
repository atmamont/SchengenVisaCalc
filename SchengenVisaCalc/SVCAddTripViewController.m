//
//  SVCAddTripViewController.m
//  SchengenVisaCalc
//
//  Created by Vit on 21.05.15.
//  Copyright (c) 2015 Andrey Mamchenko. All rights reserved.
//

#import "SVCAddTripViewController.h"
#import "Trip.h"
#import "SVCSwitchTableViewCell.h"
#import "SVCTripNameTableViewCell.h"

#define kDatePickerTag              99     // view tag identifiying the date picker view
#define kSwitchTag                  100     // view tag for switch
#define kTextFieldTag               101
#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

// keep track of which rows have date cells
#define kDateStartRow   0
#define kDateEndRow     2
#define kSwitchRow      1

@interface SVCAddTripViewController ()

@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (strong, nonatomic) NSDate *entryDate, *departureDate;
@property (strong, nonatomic) NSString *tripDescription;


@property (assign) NSInteger pickerCellRowHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SVCAddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.188 green:0.227 blue:0.65 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.145 green:0.169 blue:0.557 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0.145 green:0.169 blue:0.557 alpha:1];
    [self.view addSubview:statusBarView];
    
    [self setNeedsStatusBarAppearanceUpdate];

    self.pickerCellRowHeight = 220;
    
    if (!self.mainViewController.refreshControl.refreshing) {
        NSIndexPath *path = [self.mainViewController.tripsTableView indexPathForSelectedRow];
        Trip *selectedTrip = [self.mainViewController.calc.trips objectAtIndex:path.row];
        self.entryDate = selectedTrip.startDate;
        self.departureDate = selectedTrip.endDate;
        self.tripDescription = selectedTrip.name;
        self.navigationItem.title = @"Edit trip";
    } else
    {
        self.entryDate = [NSDate date];
        self.departureDate = [NSDate date];
        self.navigationItem.title = @"Add trip";
        self.tripDescription = @"";
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)updateButtonClick:(id)sender {
    if (!self.mainViewController.refreshControl.refreshing) {               // we're editing existing trip
        NSIndexPath *path = [self.mainViewController.tripsTableView indexPathForSelectedRow];
        Trip *selectedTrip = [self.mainViewController.calc.trips objectAtIndex:path.row];
    
        selectedTrip.startDate = self.entryDate;
        selectedTrip.endDate = self.departureDate;
        
        path = [NSIndexPath indexPathForRow:0 inSection:0];
        SVCTripNameTableViewCell *cell = (SVCTripNameTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        selectedTrip.name = cell.descriptionTextField.text;
    }
    else {      // we're adding new trip
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        SVCTripNameTableViewCell *cell = (SVCTripNameTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        [self.mainViewController.calc addTrip:self.entryDate and:self.departureDate named:cell.descriptionTextField.text];
        
        [self.mainViewController.refreshControl endRefreshing];
    }

    [self.mainViewController saveTripsData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClick:(id)sender {
    if (self.mainViewController.refreshControl.refreshing)
        [self.mainViewController.refreshControl endRefreshing];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:1]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            NSIndexPath *dateCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:1];
            UITableViewCell *dateCell = [self.tableView cellForRowAtIndexPath:dateCellIndexPath];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            targetedDatePicker.date = [dateFormatter dateFromString:dateCell.detailTextLabel.text];
            
            // prevent departure date to be earlier than entry date
            if (self.datePickerIndexPath.row == 3) targetedDatePicker.minimumDate = self.entryDate;
            
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if (indexPath.section != 1) return hasDate;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}

- (BOOL)indexPathHasSwitch:(NSIndexPath *)indexPath
{
    BOOL hasSwitch = NO;
    
    if (indexPath.section != 1) return hasSwitch;
    
    if ((indexPath.row == kSwitchRow) || ([self hasInlineDatePicker] && (indexPath.row == kSwitchRow + 1)))
        hasSwitch = YES;
    
    return hasSwitch;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    
    if ([self hasInlineDatePicker])
        // we have a date picker, so allow for it in the number of rows in this section
        return 4;
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSString *cellID = @"descriptionCellID";
    
    if (indexPath.section == 1)
    {
        if ([self indexPathHasPicker:indexPath])
        {
            // the indexPath is the one containing the inline date picker
            cellID = @"datePickerCellID";     // the current/opened date picker cell
        }
        else if ([self indexPathHasDate:indexPath])
        {
            // the indexPath is one that contains the date information
            cellID = @"dateCellID";       // the start/end date cells
        }
        else if ([self indexPathHasSwitch:indexPath])
        {
            cellID = @"switchCellID";
        }
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if ((indexPath.row == 0 && indexPath.section == 0) || [self indexPathHasSwitch:indexPath])
    {
        // we decide here that first cell in the table is not selectable (it's just an indicator)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // return description field cell
    if ([cellID isEqualToString:@"descriptionCellID"])
    {
        SVCTripNameTableViewCell *nameCell = (SVCTripNameTableViewCell *)cell;
        nameCell.descriptionTextField.text = self.tripDescription;
        nameCell.descriptionTextField.delegate = self;
        return nameCell;
    }

    // return date of entry cell
    if (indexPath.row == 0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
        cell.textLabel.text = @"Date of entry";
        cell.detailTextLabel.text = [dateFormatter stringFromDate:self.entryDate];
        
        return cell;
    }
    
    if ([cellID isEqualToString:@"switchCellID"])
    {
        SVCSwitchTableViewCell *switchCell = (SVCSwitchTableViewCell *)cell;
        if (!self.departureDate) switchCell.tripSwitch.on = YES; else switchCell.tripSwitch.on = NO;
        return switchCell;
    }
    
    // return departure date cell
    if ([cellID isEqualToString:@"dateCellID"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
        cell.textLabel.text = @"Date of departure";

        if (!self.departureDate) {
            cell.detailTextLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        else cell.detailTextLabel.text = [dateFormatter stringFromDate:self.departureDate];
    }
    
    return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:1]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:1];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:1];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"dateCellID"])
    {
       [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (IBAction)datePickerValueChanged:(id)sender {
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            NSIndexPath *dateCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:1];
            UITableViewCell *dateCell = [self.tableView cellForRowAtIndexPath:dateCellIndexPath];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateCell.detailTextLabel.text = [dateFormatter stringFromDate:targetedDatePicker.date];
            
            if (self.datePickerIndexPath.row == 1) self.entryDate = targetedDatePicker.date;
            else self.departureDate = targetedDatePicker.date;
            
        }
    }
}

// limit the input length of description textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 20) ? NO : YES;
}

- (IBAction)switchValueChanged:(id)sender {
    UISwitch *tripSwitch = (UISwitch *)sender;
    
    // check if inline datepicker is curenctly shown under departure date and if yes - remove it
    if ([self hasInlineDatePicker] && self.datePickerIndexPath.row == 3)
    {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:1]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
        [self.tableView endUpdates];
    }
    
    if (tripSwitch.isOn)
    {
        // disable departure date cell and set its date to empty
        self.departureDate = nil;
        NSInteger targetRow = 2;
        if ([self hasInlineDatePicker]) targetRow++;
        NSIndexPath *departureRowIndexPath = [NSIndexPath indexPathForRow:targetRow inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:departureRowIndexPath];
        cell.detailTextLabel.text = @"";
        cell.userInteractionEnabled = NO;
    } else
    {
        // enable dep cell, set date to today
        self.departureDate = [NSDate date];
        NSInteger targetRow = 2;
        if ([self hasInlineDatePicker]) targetRow++;
        NSIndexPath *departureRowIndexPath = [NSIndexPath indexPathForRow:targetRow inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:departureRowIndexPath];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        cell.detailTextLabel.text = [dateFormatter stringFromDate:self.departureDate];
        cell.userInteractionEnabled = YES;
    }
}


@end
