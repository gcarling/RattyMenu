//
//  FoodViewerViewController.h
//  RattyMenu
//
//  Created by Graham Carling on 3/12/14.
//  Copyright (c) 2014 Graham Carling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodViewerViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)goBack:(id)sender;

@end
