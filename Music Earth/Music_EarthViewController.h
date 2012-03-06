//
//  Music_EarthViewController.h
//  Music Earth
//
//  Created by  on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface Music_EarthViewController : UIViewController<MPMediaPickerControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>{
    //ipod
    MPMusicPlayerController *player;
    IBOutlet UIView *viewMainSide;
    IBOutlet UILabel *labelSongTitle;
    IBOutlet UILabel *labelAlbumTitle;
    IBOutlet UILabel *labelArtist;
    IBOutlet UIImageView *imageArtWork;
    IBOutlet UISlider *sliderPlayerPos;
    IBOutlet UILabel *labelPastTime;
    IBOutlet UILabel *labelRestTime;
    IBOutlet UIButton *buttonPlay;
    IBOutlet UIButton *buttonPause;
    //map
    IBOutlet MKMapView *myMapView;
    CLLocationManager *myLocationManager;
    IBOutlet UILabel *latitude;
    IBOutlet UILabel *longitude;
    IBOutlet UIImageView *compassImg;
    //time
    NSTimer *timerClock;//for renew the time view
    IBOutlet UILabel *labelDate;
    IBOutlet UILabel *labelTime;
    //volume
    int volumeChagedTimes;
    IBOutlet UILabel *labelVolumeChangedTimes;
    IBOutlet UILabel *labelVolumeNum;
    IBOutlet UISlider *sliderVolume;
    //scene
    IBOutlet UIButton *buttonScene1;
    IBOutlet UIButton *buttonScene2;
    IBOutlet UIButton *buttonScene1Back;
    IBOutlet UIButton *buttonScene2Back;
    
    //xml
    int sceneNum;
    
    
}
-(IBAction) playOrPause;
-(IBAction) skipToNext;
-(IBAction) skipToPrevious;
-(IBAction) flipTOMoreSide;
-(IBAction) flipToMainSide;
-(IBAction) showMediaPicker;
-(IBAction) volumeChange;
-(IBAction) playerPosChange;
-(IBAction) like;
-(IBAction) dislike;
-(IBAction) scene1;
-(IBAction) scene2;
@end
