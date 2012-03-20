//
//  AlbumViewController.h
//  Music Earth
//
//  Created by  on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface AlbumViewController : UITableViewController{
    NSArray *songItems;
    IBOutlet UITableView *myTableView;
}
@property (nonatomic, retain) NSString *annotationLatitude;  
@property (nonatomic, retain) NSString *annotationLongitude;

@end
