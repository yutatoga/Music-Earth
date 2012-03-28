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
    MPMusicPlayerController *player;
    IBOutlet UITableView *myTableView;
}
@property (nonatomic, retain) NSString *annotationLatitude;  
@property (nonatomic, retain) NSString *annotationLongitude;
@property (nonatomic, retain) NSArray *annotationMediaTitle;
@property (nonatomic, retain) NSString *annotationMediaArtist;
@property (nonatomic, readwrite) float annotationNum;
@end
