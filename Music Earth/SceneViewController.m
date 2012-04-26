//
//  SceneViewController.m
//  Music Earth
//
//  Created by  on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SceneViewController.h"

@interface SceneViewController ()

@end

@implementation SceneViewController

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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch (indexPath.row) {
        case 0:
            if( cell == nil ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.textLabel.text = @"Work";
                //cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
            break;
        case 1:
            if( cell == nil ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.textLabel.text = @"Relax";
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
            break;
        case 2:
            if( cell == nil ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.textLabel.text = @"Commute";
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
            break;
        case 3:
            if( cell == nil ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.textLabel.text = @"Cooking";
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //write user default
    NSString *myScene = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"profile"]];
    //update birthday
    [defaultProfile setObject:myScene forKey:@"Scene"];
    [defaults setObject:defaultProfile forKey:@"profile"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
}

@end
