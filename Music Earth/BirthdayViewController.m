//
//  BirthdayViewController.m
//  Music Earth
//
//  Created by  on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirthdayViewController.h"

@interface BirthdayViewController ()

@end

@implementation BirthdayViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    //write user default
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    myFormatter.dateFormat = @"yyyy/MM/dd";
    NSString *myBirthday = [NSString stringWithString:[myFormatter stringFromDate:myDatePicker.date] ];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"profile"]];
    //update birthday
    [defaultProfile setObject:myBirthday forKey:@"Birthday"];
    [defaults setObject:defaultProfile forKey:@"profile"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
