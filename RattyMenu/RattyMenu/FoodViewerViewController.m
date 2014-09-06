//
//  FoodViewerViewController.m
//  RattyMenu
//
//  Created by Graham Carling on 3/12/14.
//  Copyright (c) 2014 Graham Carling. All rights reserved.
//

#import "FoodViewerViewController.h"

@interface FoodViewerViewController ()

@end

@implementation FoodViewerViewController

@synthesize items = _items;
@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    int numExtras = 0;
    for (int i = 0; i < [_items count]; i++){
        NSString *text = [_items objectAtIndex:i];
        double calc = text.length / 34.0;
        int rows = ceil(calc);
        UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + (40 * i) + (20 * numExtras), 280, 25*rows)];
        numExtras += (rows - 1);
        NSString *food = [_items objectAtIndex:i];
        if ([food isEqualToString:@"Roots & Shoots"] || [food isEqualToString:@"Grill"] || [food isEqualToString:@"Chef's Corner"] || [food isEqualToString:@"Bistro"]){
            UIFont *font = [UIFont boldSystemFontOfSize:22];
            temp.font = font;
        }
        temp.text = food;
        temp.textAlignment = NSTextAlignmentCenter;
        temp.numberOfLines = 0;
        temp.lineBreakMode = NSLineBreakByWordWrapping;
        [labels addObject:temp];
    }
    [_scrollView setScrollEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(320, 30 + (20 * numExtras) + (40 * [_items count]))];
    for (int i = 0; i < [labels count]; i++){
        UILabel *temp = [labels objectAtIndex:i];
        [_scrollView addSubview:temp];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self performSegueWithIdentifier:@"showFoodToMain" sender:self];
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
