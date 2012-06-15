//
//  GenreViewController.m
//  Music Earth
//
//  Created by  on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GenreViewController.h"
#import "AddGenreViewController.h"

@interface GenreViewController ()

@end

@implementation GenreViewController

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
    
    
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.editing = YES;
    //self.navigationItem.rightBarButtonItem = [self editButtonItem];
    myNumberOfRowsInSection1 = 4;//should be change to the number which is readed in user defaults.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    NSLog(@"hoge:%@ count:%i",[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].textLabel.text, [self.tableView numberOfRowsInSection:0]);
    
    //read dictionary of genre setting
    for (int i=0; i<[self.tableView numberOfRowsInSection:0]; i++) {
        NSLog(@"for ");
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"will disapper");
    //user default
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //stop here
    /*
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"privateGenre"]];
    
    //update birthday
    [defaultProfile setObject:myGenre forKey:@"Genre"];
    [defaults setObject:defaultProfile forKey:@"privateGenre"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
    */
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (section == 1) {
        return myNumberOfRowsInSection1;        
    }else {
        return 1;
    }
}

#pragma mark - cellForRowAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Pop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"Add Genre";
        //cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else {
        switch (indexPath.row) {
            case 0:
                if( cell == nil ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.textLabel.text = @"Rock";
                    //cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
                break;
            case 1:
                if( cell == nil ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.textLabel.text = @"Jazz";
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
                break;
            case 2:
                if( cell == nil ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.textLabel.text = @"Classic";
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
                break;
            case 3:
                if( cell == nil ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.textLabel.text = @"Country";
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
                break;
            default:
                if( cell == nil ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.textLabel.text = @"ADDED";
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
                break;

        }
    }
    return nil;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"edit mode on");
    UITableViewCellEditingStyle result;
    if (indexPath.section == 0) {
        result = UITableViewCellEditingStyleInsert;
    }else {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        myNumberOfRowsInSection1--;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        /*
        myNumberOfRowsInSection1++;
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:myNumberOfRowsInSection1-1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
         */
        //[[self navigationController] pushViewController:myAddGenreViewController animated:YES]; 
        AddGenreViewController *myAddGenreViewController = [[AddGenreViewController alloc] initWithNibName:@"AddGenreViewController" bundle:nil];        
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:myAddGenreViewController];
        
        [self.navigationController presentModalViewController:navBar animated:YES];
       
        //[[self navigationController] presentModalViewController:myAddGenreViewController animated:YES];
    }
}


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
    NSString *myGenre = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //read old profile
    NSMutableDictionary *defaultProfile = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"profile"]];
    //update birthday
    [defaultProfile setObject:myGenre forKey:@"Genre"];
    [defaults setObject:defaultProfile forKey:@"profile"];
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
}

@end
