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
#import <AudioToolbox/AudioToolbox.h>

#import "SimpleAnnotation.h"
#import "CustomAnnotationView.h"

@class AlbumViewController;

@interface Music_EarthViewController : UIViewController<MPMediaPickerControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>{
    //ipod
    MPMusicPlayerController *player;
    IBOutlet UILabel *labelSongTitle;
    IBOutlet UILabel *labelAlbumTitle;
    IBOutlet UILabel *labelArtist;
    IBOutlet UIImageView *imageArtWork;
    IBOutlet UISlider *sliderPlayerPos;
    IBOutlet UILabel *labelPastTime;
    IBOutlet UILabel *labelRestTime;
    IBOutlet UIButton *buttonPlay;
    IBOutlet UIButton *buttonPause;
    IBOutlet UIButton *buttonRepeatWhite;
    IBOutlet UIButton *buttonRepeatBlue;
    IBOutlet UIButton *buttonRepeatOne;
    IBOutlet UIButton *buttonShuffleWhite;
    IBOutlet UIButton *buttonShuffleBlue;
    //map
    IBOutlet MKMapView *myMapView;
    CLLocationManager *myLocationManager;
    IBOutlet UILabel *labelLatitude;
    IBOutlet UILabel *labelLongitude;
    IBOutlet UILabel *labelTappedLatitude;
    IBOutlet UILabel *labelTappedLongitude;
    IBOutlet UIImageView *compassImg;
    IBOutlet UIView *viewMapBack;
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
    //rating
    IBOutlet UIButton *buttonLikeWhite;
    IBOutlet UIButton *buttonLikeBlue;
    IBOutlet UIButton *buttonDislike;
    //xml
    int sceneNum;
    
    //coodination
    //CLLocationCoordinate2D
    float latitudeDeltaOld, longitudeDeltaOld;
    CGPoint PinPos;
    //air play button
    IBOutlet UIView *viewAirplay;
    IBOutlet MPVolumeView *airplayButton;
    //volume bar
    IBOutlet UIView *viewVolumeBack;
    IBOutlet MPVolumeView *viewVolume;
    IBOutlet UILabel *labelAirplay;
    //indexPath.row
    IBOutlet UILabel *labelIndexPathRow;
    //clustering
    IBOutlet UILabel *labelZoomRange;
    IBOutlet UILabel *labelMapSize;
    //play back device
    IBOutlet UIButton *buttonMicWhite;
    IBOutlet UIButton *buttonMicBlue;
    AUGraph myAUGraph;
    BOOL isMicPlaying;
}

-(IBAction) playOrPause;
-(IBAction) skipToNext;
-(IBAction) skipToPrevious;
-(IBAction) showMediaPicker;
-(IBAction) playerPosChange;
-(IBAction) likeWhite;
-(IBAction) likeBlue;
-(IBAction) dislike;
-(IBAction) scene1;
-(IBAction) scene2;
-(IBAction) repeatWhite;
-(IBAction) repeatBlue;
-(IBAction) repeatOne;
-(IBAction) shuffleWhite;
-(IBAction) shuffleBlue;
//mic
-(void) showButtonMic;
-(void) hideButtonMic;
-(void) prepareAUGraph;
-(void) micPlay;
-(void) micStop;
-(IBAction) micSwitch;
//setting view
-(IBAction) showSettingView;

@end
