//
//  SettingViewController.m
//  Music Earth
//
//  Created by  on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "BirthdayViewController.h"
#import "SexViewController.h"
#import "GenreViewController.h"
#import "SceneViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Setting"; 
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated{
    //read user default
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    NSLog(@"back to music earth view0");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"back to music earth view1");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Time";
            break;
        case 1:
            return @"Profile";
        default:
            return nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *profileDict=[defaults dictionaryForKey:@"profile"];
    NSDictionary *timeDict = [defaults dictionaryForKey:@"time"];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
                    if( aCell == nil ) {
                        //read defaults
                        
                        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"];
                        aCell.textLabel.text = @"Month";
                        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                        aCell.accessoryView = switchView;
                        [[timeDict objectForKey:@"Month"] isEqual:@"ON"] ? [switchView setOn:YES animated:NO] : [switchView setOn:NO animated:NO];
                        [switchView addTarget:self action:@selector(switchChangedMonth:) forControlEvents:UIControlEventValueChanged];
                        [switchView release];
                    }
                    return aCell;
                }
                    break;
                case 1:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
                    if( aCell == nil ) {
                        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"];
                        aCell.textLabel.text = @"Day of the Week";
                        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                        aCell.accessoryView = switchView;
                        [[timeDict objectForKey:@"DayOfTheWeek"]isEqualToString:@"ON"] ? [switchView setOn:YES animated:NO] : [switchView setOn:NO animated:NO];
                        [switchView addTarget:self action:@selector(switchChangedDayOfTheWeek:) forControlEvents:UIControlEventValueChanged];
                        [switchView release];
                    }
                    return aCell;
                }
                    break;
                case 2:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
                    if( aCell == nil ) {
                        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"];
                        aCell.textLabel.text = @"Time Zone";
                        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                        aCell.accessoryView = switchView;
                        [[timeDict objectForKey:@"TimeZone"]isEqual:@"ON"] ? [switchView setOn:YES animated:NO] : [switchView setOn:NO animated:NO];
                        [switchView addTarget:self action:@selector(switchChangedTimeZone:) forControlEvents:UIControlEventValueChanged];
                        [switchView release];
                    }
                    return aCell;
                }
                    break;
                case 3:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
                    if( aCell == nil ) {
                        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SwitchCell"];
                        aCell.textLabel.text = @"Time zone";
                        
                        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                        UISlider *mySlider = [[UISlider alloc] initWithFrame:CGRectMake(174,12,120,23)];
                        aCell.accessoryView = mySlider;
                        [mySlider setValue:0.5 animated:YES];
                        [mySlider addTarget:self action:@selector(settingSliderChanged:) forControlEvents:UIControlEventValueChanged];
                        [mySlider release];
                    }
                    return aCell;
                }
                    break;            
            }
        case 1:
            switch (indexPath.row) {
                case 0:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
                    //read user default
                    aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProfileCell"];
                    aCell.textLabel.text = @"Sex";
                    aCell.detailTextLabel.text = [profileDict objectForKey:@"Sex"];
                    aCell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                    aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [switchView setOn:NO animated:NO];
                    [switchView addTarget:self action:@selector(switchChangedMonth:) forControlEvents:UIControlEventValueChanged];
                    [switchView release];
                    return aCell;
                }
                    break;
                    
                case 1:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCellBirthday"];
                    //read user default
                    aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProfileCellBirthday"];
                    aCell.textLabel.text = @"Birthday";
                    //aCell.detailTextLabel.text = [profileDict objectForKey:@"Birthday"];
                    aCell.detailTextLabel.text = [profileDict objectForKey:@"Birthday"];
                    aCell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return aCell;
                }
                    break;
                    
                case 2:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCellGenre"];
                    //read user default
                    aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProfileCellGenre"];
                    aCell.textLabel.text = @"Favorite Genre";
                    aCell.detailTextLabel.text = [profileDict objectForKey:@"Genre"];
                    aCell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;                        
                    return aCell;
                }
                    break;
                    
                case 3:{
                    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCellScene"];
                    //read user default
                    aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProfileCellScene"];
                    aCell.textLabel.text = @"Favorite Scene";
                    aCell.detailTextLabel.text = [profileDict objectForKey:@"Scene"];;
                    aCell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;                        
                    return aCell;
                }
                    break;            
            }
        default:
            return nil;
            break;
    }
    return nil;
}

#pragma mark - Setting Changed

- (void) switchChangedMonth:(id)sender {
    //it should be change to detecting back button and seve as dictionary
    
    
    UISwitch* switchControl = sender;
    NSString *switchVal = switchControl.on ? @"ON" : @"OFF";
    //write user default
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"time"]];
    //update birthday
    [defaultProfile setObject:switchVal forKey:@"Month"];
    [defaults setObject:defaultProfile forKey:@"time"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
    
    
    
    
    //reference
    /*
    NSMutableDictionary* pin = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                [curItem valueForProperty:MPMediaItemPropertyTitle], @"Title", 
                                [curItem valueForProperty:MPMediaItemPropertyArtist], @"Artist",
                                [curItem valueForProperty:MPMediaItemPropertyAlbumTitle], @"Album",
                                [NSString stringWithFormat:@"%f", [labelLatitude.text floatValue]+arc4random()%100*0.00001-0.0005], @"Latitude",
                                [NSString stringWithFormat:@"%f", [labelLongitude.text floatValue]+arc4random()%100*0.00001-0.0005], @"Longitude",
                                timeZone,@"Time zone",
                                year, @"Year",
                                month, @"Month",
                                dayOfTheMonth, @"DayOfTheMonth",
                                dayOfTheWeek, @"DayOfTheWeek",
                                hour, @"Hour",
                                minute, @"Minute",
                                second, @"Second",
                                labelVolumeNum.text, @"Volume",
                                sceneNSNum, @"Scene",
                                nil];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOld=[defaults arrayForKey:@"privateLog"];
    NSLog(@"arrayOldNum: %d", arrayOld.count);
    
    NSMutableArray* array = [NSMutableArray array];
    //add old pins
    for (int i=0; i<arrayOld.count; i++) {
        [array addObject:[arrayOld objectAtIndex:i]];
    }
    //add new pin
    [array addObject:pin];
    //[array addObject:myArray];
    [defaults setObject:array forKey:@"privateLog"];
    
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
    */
    
}

- (void) switchChangedDayOfTheWeek:(id)sender {
    UISwitch* switchControl = sender;
    NSString *switchVal = switchControl.on ? @"ON" : @"OFF";
    //write user default
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"time"]];
    //update birthday
    [defaultProfile setObject:switchVal forKey:@"DayOfTheWeek"];
    [defaults setObject:defaultProfile forKey:@"time"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
}

- (void) switchChangedTimeZone:(id)sender {
    UISwitch* switchControl = sender;
    NSString *switchVal =switchControl.on ? @"ON" : @"OFF";
    //write user default
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"time"]];
    //update birthday
    
    [defaultProfile setObject:switchVal forKey:@"TimeZone"];
    [defaults setObject:defaultProfile forKey:@"time"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
}
-(void) settingSliderChanged:(id)sender{
    UISlider *myUISlider = sender;
    NSLog(@"The valude of slider is %f", myUISlider.value);
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    BirthdayViewController *myBirthdayViewController = [[BirthdayViewController alloc] initWithNibName:@"BirthdayViewController" bundle:nil];
    SexViewController *mySexViewController = [[SexViewController alloc] initWithNibName:@"SexViewController" bundle:nil];
    GenreViewController *myGenreViewController = [[GenreViewController alloc] initWithNibName:@"GenreViewController" bundle:nil];
    SceneViewController *mySceneViewController = [[SceneViewController alloc] initWithNibName:@"SceneViewController" bundle:nil];
    
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0://Sex
                    [[self navigationController] pushViewController:mySexViewController animated:YES];
                    
                    break;    
                case 1://Birthday
                    [[self navigationController] pushViewController:myBirthdayViewController animated:YES];
                    break;
                case 2://Favorite Genre
                    [[self navigationController] pushViewController:myGenreViewController animated:YES];
                    break;
                case 3://Favorite Scene
                    [[self navigationController] pushViewController:mySceneViewController animated:YES];
                    break;

                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}



@end
