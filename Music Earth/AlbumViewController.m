//
//  AlbumViewController.m
//  Music Earth
//
//  Created by  on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

@synthesize annotationLatitude;
@synthesize annotationLongitude;
@synthesize annotationMediaTitleArray;

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
    self.title = @"Album";
    myTableView.dataSource = self;
    myTableView.delegate = self;
    //起動時は全ての曲をリストに追加する    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    player = [MPMusicPlayerController iPodMusicPlayer];  
    songItems = songsQuery.items;
    [songItems retain];
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
    
    //<< I WILL CHANGE HERE!! >>
    //1. get correct times that current coodinate is equal to user defaults
    // this time I use one to one pin so use 1 but i will chante grouping pin
    
    return [annotationMediaTitleArray count];
    //old ver
    //return  [songItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MPMediaItem *item = [songItems objectAtIndex:indexPath.row];
        
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier];
                
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"行=%d", indexPath.row];
    //cell.textLabel.text = [NSString stringWithFormat:@"行=%d", indexPath.row];
    
    //<< I WILL CHANGE HERE!! >>
    //1. get tapped latitude and longitude
    //2. search from user defaults
    //3. if correnct add cell
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Song：LAT%@LON%@", annotationLatitude, annotationLongitude];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ by %@", annotationMediaTitle, annotationMediaArtist];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [annotationMediaTitleArray objectAtIndex:indexPath.row]];
    
    //oldver
    //cell.textLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
    
    return cell;
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
    NSLog(@"%d selected!!---------------------------------", indexPath.row);
    UITableViewCell  *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    
    //test
    NSLog(@"all music in the tapped pin NUM:%i DESC:%@", [annotationMediaTitleArray count], [annotationMediaTitleArray description]);
    NSLog(@"selected music:INDEX%i TITLE:%@", indexPath.row, cellText);
    
    //search song 
    MPMediaQuery* query = [MPMediaQuery songsQuery];
    NSMutableArray *collections = [[NSMutableArray alloc] initWithCapacity:1];
    //below row user tapped 
    for (int i=indexPath.row; i<annotationMediaTitleArray.count; i++) {
        MPMediaPropertyPredicate* pred;
        pred = [MPMediaPropertyPredicate predicateWithValue:[annotationMediaTitleArray objectAtIndex:i] forProperty:MPMediaItemPropertyTitle comparisonType:MPMediaPredicateComparisonEqualTo];
        [query addFilterPredicate:pred];
        [collections addObjectsFromArray:query.items];
        [query  removeFilterPredicate:pred];
    }
    /*
    //above row user tappd (from the index 0)
    for (int i=0; i<indexPath.row; i++) {
        MPMediaPropertyPredicate* pred;
        pred = [MPMediaPropertyPredicate predicateWithValue:[annotationMediaTitle objectAtIndex:i] forProperty:MPMediaItemPropertyTitle comparisonType:MPMediaPredicateComparisonEqualTo];
        [query addFilterPredicate:pred];
        [collections addObjectsFromArray:query.items];
        [query  removeFilterPredicate:pred];
    } 
    */
    NSLog(@"collections:%@", [collections description]);
    MPMediaItemCollection *finalCollection = [MPMediaItemCollection collectionWithItems:collections];
    [player setQueueWithItemCollection:finalCollection];
    [player play];    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
