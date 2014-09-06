//
//  RattyMenuViewController.h
//  RattyMenu
//
//  Created by Graham Carling on 3/12/14.
//  Copyright (c) 2014 Graham Carling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RattyMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *breakfastButton;
@property (weak, nonatomic) IBOutlet UIButton *lunchButton;
@property (weak, nonatomic) IBOutlet UIButton *dinnerButton;
- (void)updateMenu;
- (IBAction)getBreakfast:(id)sender;
- (IBAction)getLunch:(id)sender;
- (IBAction)getDinner:(id)sender;

@end
