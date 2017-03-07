//
//  HomeTableViewController.m
//  CFAlertViewControllerDemo
//
//  Created by Vinayak Parmar on 15/06/16.
//  Copyright © 2016 Codigami Labs Inc. All rights reserved.
//

#import "HomeTableViewController.h"
#import "CFAlertViewControllerDemo-Swift.h"
#import "CustomFooterView.h"



#define DEFAULT_BTN_TITLE           @"DEFAULT"
#define DEFAULT_BTN_COLOR           [UIColor colorWithRed:41.0/255.0 green:198.0/255.0 blue:77.0/255.0 alpha:1.0]
#define DEFAULT_BTN_TITLE_COLOR     [UIColor whiteColor]

#define DESTRUCTIVE_BTN_TITLE       @"DESTRUCTIVE"
#define DESTRUCTIVE_BTN_COLOR       [UIColor colorWithRed:255.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1.0]
#define DESTRUCTIVE_BTN_TITLE_COLOR [UIColor whiteColor]

#define CANCEL_BTN_TITLE            @"CANCEL"
#define CANCEL_BTN_COLOR            [[UIColor grayColor] colorWithAlphaComponent:0.3]
#define CANCEL_BTN_TITLE_COLOR      [UIColor grayColor]





@interface HomeTableViewController ()

// Alert Type
@property (weak, nonatomic) IBOutlet UISegmentedControl *alertTypeSegment;

// Text
@property (weak, nonatomic) IBOutlet UITextField *titleTextfield;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textAlignmentSegment;

// Action
@property (weak, nonatomic) IBOutlet UISwitch *actionDefaultSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *actionCancelSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *actionDestructiveSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *actionAlignmentSegment;

// Other
@property (weak, nonatomic) IBOutlet UISwitch *settingCloseOnBackgroundTapSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *settingAddHeaderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *settingAddFooterSwitch;

@end



@implementation HomeTableViewController

#pragma mark - View Life Cycle Methods

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    NSLog(@"View Will Appear");
}

- (void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
    NSLog(@"View Did Appear");
}

- (void) viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    NSLog(@"View Will Disappear");
}

- (void) viewDidDisappear:(BOOL)animated  {
    [super viewDidDisappear:animated];
    NSLog(@"View Did Disappear");
}

#pragma mark - Button Click Events

- (IBAction) showAlertButtonClicked:(id)sender {
    
    // Create Header View
    UIView *headerView;
    if (self.settingAddHeaderSwitch.isOn) {
        headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_image"]];
        headerView.contentMode = UIViewContentModeBottom;
        headerView.clipsToBounds = YES;
        headerView.frame = CGRectMake(0, 0, 0, 70.0);
    }
    
    // Create Title & Subtitle
    NSString *titleText = [self.titleTextfield.text isEqualToString:@""] ? nil : self.titleTextfield.text;
    NSString *descText = [self.descriptionTextField.text isEqualToString:@""] ? nil : self.descriptionTextField.text;
    
    // Create Footer View
    UIView *footerView;
    if (self.settingAddFooterSwitch.isOn) {
        footerView = [[CustomFooterView alloc] init];
    }
    
    // Create Alert
    CFAlertViewController *alert = [CFAlertViewController alertControllerWithTitle:titleText
                                                                           message:descText
                                                                     textAlignment:[self getTextAlignment]
                                                                    preferredStyle:[self getAlertStyle]
                                                                        headerView:headerView
                                                                        footerView:footerView
                                                            didDismissAlertHandler:^(BOOL isBackgroundTapped) {
                                                                NSLog(@"Alert Dismissed");
                                                                if (isBackgroundTapped) {
                                                                    // Handle background tap here
                                                                    NSLog(@"Alert background tapped");
                                                                }
                                                            }];
    
    // Add Alert Reference Into Footer View
    if (footerView && [footerView isKindOfClass:[CustomFooterView class]]) {
        ((CustomFooterView *)footerView).alertController = alert;
    }
    
    // Configure Background
    alert.backgroundStyle = CFAlertControllerBackgroundStyleBlur;
    alert.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    alert.shouldDismissOnBackgroundTap = self.settingCloseOnBackgroundTapSwitch.isOn;
    
    // Add Default Button Action
    if (self.actionDefaultSwitch.isOn) {
        CFAlertAction *actionDefault = [CFAlertAction actionWithTitle:DEFAULT_BTN_TITLE
                                                                style:CFAlertActionStyleDefault
                                                            alignment:[self getActionsTextAlignment]
                                                      backgroundColor:DEFAULT_BTN_COLOR
                                                            textColor:DEFAULT_BTN_TITLE_COLOR
                                                              handler:nil];
        [alert addAction:actionDefault];
    }
    
    // Add Destructive Button Action
    if (self.actionDestructiveSwitch.isOn) {
        CFAlertAction *actionDestruct = [CFAlertAction actionWithTitle:DESTRUCTIVE_BTN_TITLE
                                                                 style:CFAlertActionStyleDestructive
                                                             alignment:[self getActionsTextAlignment]
                                                       backgroundColor:DESTRUCTIVE_BTN_COLOR
                                                             textColor:DESTRUCTIVE_BTN_TITLE_COLOR
                                                               handler:nil];
        [alert addAction:actionDestruct];
    }
    
    // Add Cancel Button Action
    if (self.actionCancelSwitch.isOn) {
        CFAlertAction *actionCancel = [CFAlertAction actionWithTitle:CANCEL_BTN_TITLE
                                                               style:CFAlertActionStyleCancel
                                                           alignment:[self getActionsTextAlignment]
                                                     backgroundColor:CANCEL_BTN_COLOR
                                                           textColor:CANCEL_BTN_TITLE_COLOR
                                                             handler:nil];
        [alert addAction:actionCancel];
    }
    
    if (alert.actions.count==0 &&
        titleText == nil &&
        descText == nil &&
        !self.settingAddHeaderSwitch.isOn
        && !self.settingAddFooterSwitch.isOn)
    {
        // Display Error
        [self showEmptyFieldsAlert];
    }
    else {
        // Present Alert Controller
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Mapping Methods

- (NSTextAlignment) getTextAlignment {
    
    switch (self.textAlignmentSegment.selectedSegmentIndex) {
        case 0:
            return NSTextAlignmentLeft;
            break;
            
        case 1:
            return NSTextAlignmentCenter;
            break;
            
        case 2:
            return NSTextAlignmentRight;
            break;
            
        default:
            break;
    }
    return NSTextAlignmentCenter;
}

- (CFAlertActionAlignment) getActionsTextAlignment {
    
    switch (self.actionAlignmentSegment.selectedSegmentIndex) {
        case 0:
            return CFAlertActionAlignmentJustified;
            break;
            
        case 1:
            return CFAlertActionAlignmentLeft;
            break;
            
        case 2:
            return CFAlertActionAlignmentCenter;
            break;
            
        case 3:
            return CFAlertActionAlignmentRight;
            break;
            
        default:
            break;
    }
    return CFAlertActionAlignmentCenter;
}

- (CFAlertControllerStyle) getAlertStyle {
    
    switch (self.alertTypeSegment.selectedSegmentIndex) {
        case 0:
            return CFAlertControllerStyleAlert;
            break;
            
        case 1:
            return CFAlertControllerStyleActionSheet;
            break;
            
        default:
            break;
    }
    return CFAlertControllerStyleAlert;
}

#pragma mark - Error Handler Methods

- (void) showEmptyFieldsAlert   {
    
    CFAlertViewController *alert = [CFAlertViewController alertControllerWithTitle:@"Oops!"
                                                                           message:@"Please set some properties of Alert view"
                                                                     textAlignment:NSTextAlignmentCenter
                                                                    preferredStyle:CFAlertControllerStyleAlert
                                                            didDismissAlertHandler:^(BOOL isBackgroundTapped) {
                                                                NSLog(@"Alert Dismissed");
                                                            }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
