//
//  RattyMenuViewController.m
//  RattyMenu
//
//  Created by Graham Carling on 3/12/14.
//  Copyright (c) 2014 Graham Carling. All rights reserved.
//

#import "RattyMenuViewController.h"
#import "ASIHTTPRequest.h"
#import "FoodViewerViewController.h"

@interface RattyMenuViewController ()

@end

NSString *breakfastURL;
NSString *lunchURL;
NSString *dinnerURL;
NSMutableArray *items;

@implementation RattyMenuViewController

@synthesize breakfastButton = _breakfastButton;
@synthesize lunchButton = _lunchButton;
@synthesize dinnerButton = _dinnerButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateMenu];
    items = [[NSMutableArray alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = (int)[comps weekday];
    if (weekday == 1){
        [_breakfastButton setTitle:@"BRUNCH" forState:UIControlStateNormal];
        [_lunchButton setTitle:@"DINNER" forState:UIControlStateNormal];
        _dinnerButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMenu{
    //make URL
    NSString *str = @"http://www.brown.edu/Student_Services/Food_Services/eateries/refectory_menu.php";
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //setup request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:5];
    [request setDelegate:self];
    [request startSynchronous];
    //get and handle response
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSArray *array = [response componentsSeparatedByString:@"frameborder=\"0\" "];
        for (int i = 1; i < [array count]; i++){
            NSString *cur = [array objectAtIndex:i];
            NSArray *urlArray = [cur componentsSeparatedByString:@"\""];
            NSString *url = [urlArray objectAtIndex:1];
            if (i == 1){
                breakfastURL = url;
            }
            else if (i == 2){
                lunchURL = url;
            }
            else if (i == 3){
                dinnerURL = url;
            }
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong!"
                                                        message:@"Couldn't get data from the Ratty. Check the Ratty's menu online - if it's down then this app won't work."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getMeal:(NSString*)str{
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //setup request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:5];
    [request setDelegate:self];
    [request startSynchronous];
    //get and handle response
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSArray *array = [response componentsSeparatedByString:@"</td>"];
        NSMutableArray *roots = [[NSMutableArray alloc] init];
        [roots addObject:@"Roots & Shoots"];
        NSMutableArray *grill = [[NSMutableArray alloc] init];
        [grill addObject:@"Grill"];
        NSMutableArray *chefs = [[NSMutableArray alloc] init];
        [chefs addObject:@"Chef's Corner"];
        NSMutableArray *bistro = [[NSMutableArray alloc] init];
        [bistro addObject:@"Bistro"];
        for (int i = 2; i < [array count]-1; i++){
            NSString *cur = [array objectAtIndex:i];
            NSArray *split = [cur componentsSeparatedByString:@">"];
            for (int j = 1; j < 5; j++){
                NSString *food = [split objectAtIndex:j];
                if (![food hasPrefix:@"."] && ![food hasPrefix:@"<"]){
                    NSArray *foodTemp = [food componentsSeparatedByString:@"<"];
                    NSString *item = [foodTemp firstObject];
                    item = [item stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                    if (j == 1){
                        [roots addObject:item];
                    }
                    else if (j == 2){
                        [grill addObject:item];
                    }
                    else if (j == 3){
                        [chefs addObject:item];
                    }
                    else if (j == 4){
                        [bistro addObject:item];
                    }
                }
            }
        }
        for (int i = 0; i < [bistro count]; i++){
            [items addObject:[bistro objectAtIndex:i]];
        }
        for (int i = 0; i < [chefs count]; i++){
            [items addObject:[chefs objectAtIndex:i]];
        }
        for (int i = 0; i < [roots count]; i++){
            [items addObject:[roots objectAtIndex:i]];
        }
        for (int i = 0; i < [grill count]; i++){
            [items addObject:[grill objectAtIndex:i]];
        }
        [self performSegueWithIdentifier:@"showFood" sender:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong!"
                                                        message:@"Couldn't get data from the Ratty. Check the Ratty's menu online - if it's down then this app won't work."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)getBreakfast:(id)sender {
    [self getMeal:breakfastURL];
}

- (IBAction)getLunch:(id)sender {
    [self getMeal:lunchURL];
}

- (IBAction)getDinner:(id)sender {
    [self getMeal:dinnerURL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showFood"]){
        FoodViewerViewController *controller = (FoodViewerViewController*)[segue destinationViewController];
        [controller setItems:items];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
