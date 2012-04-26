//
//  SexViewController.m
//  Music Earth
//
//  Created by  on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SexViewController.h"



@interface SexViewController ()

@end

@implementation SexViewController
@synthesize lastIndexPath;

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
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"sex view will appear");
}

-(void) viewWillDisappear:(BOOL)animated{
    NSLog(@"sex view will disappear");

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch (indexPath.row) {
        case 0:
            if( cell == nil ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.textLabel.text = @"Female";
                //cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
            break;
        case 1:
            if( cell == nil ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.textLabel.text = @"Male";
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
            break;
        default:
            break;
    }
    return nil;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (indexPath.row == 0) {
            UITableViewCell *anotherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            anotherCell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            UITableViewCell *anotherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            anotherCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //write user default
    NSString *mySex = (indexPath.row) ? @"Male" : @"Female";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"profile"]];
    //update birthday
    [defaultProfile setObject:mySex forKey:@"Sex"];
    [defaults setObject:defaultProfile forKey:@"profile"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
}



@end
