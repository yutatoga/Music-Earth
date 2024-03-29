//
//  Music_EarthViewController.m
//  Music Earth
//
//  Created by  on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define GRIDNUMX 4
#define GRIDNUMY 3

#import "Music_EarthViewController.h"
#import "AlbumViewController.h"
#import "SettingViewController.h"

@implementation Music_EarthViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


//audio session
static void propertyListener(void *                  inClientData,
                             AudioSessionPropertyID	inID,
                             UInt32                  inDataSize,
                             const void *            inData){
    Music_EarthViewController *controller = inClientData;
    //デバイスに変更があった場合
    if(inID == kAudioSessionProperty_AudioRouteChange){
        printf("kAudioSessionProperty_AudioRouteChange\n");
        NSDictionary *dict = (NSDictionary*)inData;
        NSLog(@"dict = %@",dict); //変更理由
        /*
        NSLog(@"device: %@", [dict objectForKey:@"OutputDeviceDidChange_NewRoute"]);
        if ([[dict objectForKey:@"OutputDeviceDidChange_NewRoute"] isEqual:@"HeadsetInOut"] ||
            [[dict objectForKey:@"OutputDeviceDidChange_NewRoute"] isEqual:@"Headphone"] ||
            [[dict objectForKey:@"OutputDeviceDidChange_NewRoute"] isEqual:@"Headset"] ||
            [[dict objectForKey:@"OutputDeviceDidChange_NewRoute"] isEqual:@"HeadphonesAndMicrophone"]) {
            [controller showButtonMic];
        } else {
            [controller hideButtonMic];
        }
         */
        NSLog(@"%@",[dict objectForKey:@"OutputDeviceDidChange_NewRoute"]);
        if ([[dict objectForKey:@"OutputDeviceDidChange_NewRoute"] isEqual:@"Speaker"]) {
            [controller changePlayPauseIcon];
        }
    }
    //ヴォリュームの変更
    if(inID == kAudioSessionProperty_CurrentHardwareOutputVolume){
        printf("kAudioSessionProperty_CurrentHardwareOutputVolume\n");
        float *volume = (float*)inData;
        NSLog(@"volume = %f",*volume);
    }
    //マイク等が利用可能・不可能になった場合
    if(inID == kAudioSessionProperty_AudioInputAvailable){
        printf("kAudioSessionProperty_AudioInputAvailable\n");
        
    }
}
-(void)changePlayPauseIcon{
    buttonPause.hidden = true;
    buttonPlay.hidden = false;
}

/*
- (void)showButtonMic{
    NSLog(@"show buttonMic");
    buttonMicWhite.hidden = false;
    buttonMicBlue.hidden = true;
}

- (void)hideButtonMic{
    NSLog(@"hide buttonMic");
    [self micStop];
    buttonMicWhite.hidden = true;
    buttonMicBlue.hidden = true;
}


 -(void)prepareAUGraph{
    AUNode remoteIONode;
    AudioUnit remoteIOUnit;
    
    NewAUGraph(&myAUGraph);
    AUGraphOpen(myAUGraph);
    
    AudioComponentDescription cd;
	cd.componentType = kAudioUnitType_Output;
	cd.componentSubType = kAudioUnitSubType_RemoteIO;
	cd.componentManufacturer = kAudioUnitManufacturer_Apple;
	cd.componentFlags = cd.componentFlagsMask = 0;
	
	AUGraphAddNode(myAUGraph, &cd, &remoteIONode);
    AUGraphNodeInfo(myAUGraph, remoteIONode, NULL, &remoteIOUnit);
    
    //マイク入力をオンにする
    UInt32 flag = 1;
    AudioUnitSetProperty(remoteIOUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         1, //Remote Input
                         &flag,
                         sizeof(flag));
    
    AUGraphConnectNodeInput(myAUGraph,
                            remoteIONode, 1, //Remote Inputと 
                            remoteIONode, 0  //Remote Outputを接続
                            );
    AUGraphInitialize(myAUGraph);
    //allow mix
    OSStatus propertySetErfror = 0;
    UInt32 allowMixing = true;
    propertySetError = AudioSessionSetProperty (
                                                kAudioSessionProperty_OverrideCategoryMixWithOthers,
                                                sizeof (allowMixing), 
                                                &allowMixing 
                                                );
}
 */

-(void)micPlay{
    if(!isMicPlaying)AUGraphStart(myAUGraph);
    isMicPlaying = YES;
}

-(void)micStop{
    if(isMicPlaying)AUGraphStop(myAUGraph);
    isMicPlaying = NO;
}

#pragma mark - View lifecycle

#pragma mark -
#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Music Earth";
	// Do any additional setup after loading the view, typically from a nib.
    
    //ipod
    //1.not use iPod app
    //player = [MPMusicPlayerController applicationMusicPlayer];
    //MPMediaQuery *query = [MPMediaQuery artistsQuery];
    //[player setQueueWithQuery:query];

    //2.use iPod app
    player = [MPMusicPlayerController iPodMusicPlayer];    
    [player play];
    
    [self updateView];
    
    //notification for itemChanged
    NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
    [myNotificationCenter 
     addObserver:self 
     selector:@selector(didItemChanged: ) 
     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
     object:player];
    
    
    
    
    [player beginGeneratingPlaybackNotifications];
    //notification for volume changed
    [myNotificationCenter 
     addObserver:self 
     selector:@selector(didVolumeChanged: ) 
     name:MPMusicPlayerControllerVolumeDidChangeNotification
     object:player];
    //player position
    labelPastTime.text =[NSString stringWithFormat:@"%f", player.currentPlaybackTime];
    //player volume
    sliderVolume.value = player.volume;
    labelVolumeNum.text = [NSString stringWithFormat:@"%f", player.volume];
    //repeat
    player.repeatMode=MPMusicRepeatModeDefault;
    switch (player.repeatMode) {
        case MPMusicRepeatModeNone:
            buttonRepeatWhite.hidden = false;
            buttonRepeatBlue.hidden = true;
            buttonRepeatOne.hidden = true;
            NSLog(@"REPEAT:defalt is none!");
            break;
        case MPMusicRepeatModeAll:
            buttonRepeatWhite.hidden = true;
            buttonRepeatBlue.hidden = false;
            buttonRepeatOne.hidden = true;            
            NSLog(@"REPEAT:defalt is all!");
            break;
        case MPMusicRepeatModeOne:
            buttonRepeatWhite.hidden = true;
            buttonRepeatBlue.hidden = true;
            buttonRepeatOne.hidden = false;
            NSLog(@"REPEAT:defalt is one!");
            break;
        default:
            buttonRepeatBlue.hidden = true;
            buttonRepeatWhite.hidden = false;
            buttonRepeatOne.hidden = true;
            NSLog(@"REPEAT:defalt is defalt!");
            break;
    }
    //shuffle
    player.shuffleMode = MPMusicShuffleModeDefault;
    switch (player.shuffleMode) {
        case MPMusicShuffleModeOff:
            buttonShuffleWhite.hidden=false;
            buttonShuffleBlue.hidden=true;
            NSLog(@"SHUFFLE:defalt is off!");
            break;
        case MPMusicShuffleModeSongs:
            buttonShuffleWhite.hidden=true;
            buttonShuffleBlue.hidden=false;
            NSLog(@"SHUFFLE:defalt is songs!");
            break;
        case MPMusicShuffleModeAlbums:
            buttonShuffleWhite.hidden=true;
            buttonShuffleBlue.hidden=false;
            NSLog(@"SHUFFLE:defalt is albums!");
            break;            
        default:
            buttonShuffleWhite.hidden=false;
            buttonShuffleBlue.hidden=true;
            NSLog(@"SHUFFLE:defalt is defalt!");
            break;
    }
    //map
    myLocationManager = [[CLLocationManager alloc] init];
    myLocationManager.delegate = self;
    myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    myLocationManager.distanceFilter = kCLHeadingFilterNone;
    [myLocationManager startUpdatingLocation];
    [myLocationManager startUpdatingHeading];
    myMapView.showsUserLocation = YES;
    
    MKCoordinateRegion  region = myMapView.region;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [myMapView setRegion:region animated:YES];
    
    //time
    timerClock=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
    
    //read user defaultstitleForHeaderInSection
    //play button
    buttonPlay.hidden = true;
    buttonPause.hidden = false;
    //rating
    buttonLikeBlue.hidden = true;
    buttonLikeWhite.hidden = false;
    //scene
    [buttonScene1 setTitle:@"Relax" forState:UIControlStateNormal];
    [buttonScene2 setTitle:@"Work" forState:UIControlStateNormal];
    sceneNum=1;
    
    //1.read uer defaul and add pins on map
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOld=[defaults arrayForKey:@"privateLog"];//DICTIONARY IN ARRAI!!
    NSLog(@"read pinNum: %d", arrayOld.count);
    
    NSMutableArray* array = [NSMutableArray array];
    //add raw old pins
    for (int i=0; i<arrayOld.count; i++) {
        [array addObject:[arrayOld objectAtIndex:i]];
        //draw pin
        double instantLatitude = [([[arrayOld objectAtIndex:i] objectForKey:@"Latitude"]) floatValue];
        double instantLongitude = [([[arrayOld objectAtIndex:i] objectForKey:@"Longitude"]) floatValue];
        SimpleAnnotation *myAnnotation=[[SimpleAnnotation alloc] initWithLocationCoordinate:CLLocationCoordinate2DMake(instantLatitude, instantLongitude) title:@"1 music" subtitle:nil];
        
        myAnnotation.mediaDictArray = [NSArray arrayWithObject:[arrayOld objectAtIndex:i]];
        
        [myMapView addAnnotation:myAnnotation];
        [myMapView setDelegate:self];
    }
    //[array addObject:myArray];
    
    [defaults setObject:array forKey:@"privateLog"];
    
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
    
    //2.p41 on location programing guide
    
    //convertCoordinate:toPointToView
    //airplayButton = [[MPVolumeView alloc] init];
    //airplayButton.frame = CGRectMake(0, 0, 40, 40);
    //[airplayButton setShowsVolumeSlider:NO];
    //[viewAirPlayButton addSubview:airplayButton];
    //air play button
    //SHOW ONLY THERE IS AIR PLAY SYSTEM!!!
    airplayButton = [[MPVolumeView alloc] init];
    airplayButton.transform = CGAffineTransformMakeScale(1, 1);
    airplayButton.frame = CGRectMake(0, 0, 57, 33);//original size is 38x22
    [airplayButton setShowsVolumeSlider:NO];
    
    [viewAirplay addSubview:airplayButton];

    // volume
    viewVolume = [[MPVolumeView alloc] init];
    viewVolume.frame = CGRectMake(0, 0, 180, 22);
    [viewVolume setShowsRouteButton:NO];
    [viewVolumeBack addSubview:viewVolume];
    
    //CGSize check = [viewVolume sizeThatFits:CGSizeMake(300, 200)];
    //NSLog(@"checkWidth:%f", check.width);
    //NSLog(@"checkHeight:%f", check.height);//result is that height is needed 22px.(2012_03_11) 
    
    //labelAirplay.text = [NSString stringWithFormat:@"%f", player.volume];
    
    
    //audio session
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    UInt32 size = sizeof(UInt32);
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, 
                            size,
                            &category);
    AudioSessionSetActive(YES);
    
    //mic feature
    //プロパティリスナーを登録する
    
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, 
                                    propertyListener ,
                                    self);
    /*
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume ,
                                    propertyListener, 
                                    self);
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, 
                                    propertyListener, 
                                    self);
    
    [self prepareAUGraph];
    */
    
    
    //hide some button in OtO version
    buttonLikeBlue.hidden = true;
    buttonLikeWhite.hidden = true;
    buttonScene1.hidden = true;
    buttonScene1Back.hidden = true;
    buttonScene2.hidden = true;
    buttonScene2Back.hidden = true;
    buttonDislike.hidden =true;
    
    pikcerDone = false;
}
#pragma mark -
#pragma mark iPod
//ipod----------------------------------------------------
-(void)didItemChanged: (NSNotification*) aNote{
    NSString *noteName = [aNote name];
    if ([noteName isEqualToString:MPMusicPlayerControllerNowPlayingItemDidChangeNotification]) {
        //update view
        [self updateView];
    }
}

//volume
-(void)didVolumeChanged: (NSNotification*) aNote{
    NSString *noteName = [aNote name];
    if ([noteName isEqualToString:MPMusicPlayerControllerVolumeDidChangeNotification]) {
        labelVolumeChangedTimes.text = [NSString stringWithFormat:@"%d", volumeChagedTimes++];
        labelVolumeNum.text = [NSString stringWithFormat:@"%f", player.volume];
    }
}

-(IBAction)playOrPause{
    MPMusicPlaybackState state = player.playbackState;
    if (state == MPMusicPlaybackStatePaused) {
        [player play];
        buttonPlay.hidden = true;
        buttonPause.hidden = false;
        
    }
    else if(state == MPMusicPlaybackStatePlaying){
        [player pause];
        buttonPlay.hidden = false;
        buttonPause.hidden = true;
    }
}

-(IBAction)skipToNext{
    [player skipToNextItem];
}

-(IBAction)skipToPrevious{
    
    if (player.currentPlaybackTime < 3.0) {
        [player skipToPreviousItem];
    }else{
        [player skipToBeginning];
    }
    
}

-(IBAction) repeatWhite{
    buttonRepeatWhite.hidden = true;
    buttonRepeatBlue.hidden = false;
    player.repeatMode = MPMusicRepeatModeAll;    
}
-(IBAction) repeatBlue{
    buttonRepeatBlue.hidden = true;
    buttonRepeatOne.hidden = false;
    player.repeatMode = MPMusicRepeatModeOne;
}
-(IBAction) repeatOne{
    buttonRepeatOne.hidden = true;
    buttonRepeatWhite.hidden = false;
    player.repeatMode = MPMusicRepeatModeNone;
}

-(IBAction) shuffleWhite{
    buttonShuffleWhite.hidden = true;
    buttonShuffleBlue.hidden = false;
    player.shuffleMode = MPMusicShuffleModeSongs;
}
-(IBAction) shuffleBlue{
    buttonShuffleBlue.hidden = true;
    buttonShuffleWhite.hidden = false;
    player.shuffleMode = MPMusicShuffleModeOff;
}


-(IBAction)playerPosChange{
    player.currentPlaybackTime = sliderPlayerPos.value;
    labelPastTime.text = [NSString stringWithFormat:@"%01i:%02i ", (int)sliderPlayerPos.value/60, (int)sliderPlayerPos.value%60];
    labelRestTime.text = [NSString stringWithFormat:@"-%01i:%02i ", ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)/60, ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)%60];
}

-(IBAction)likeWhite{
    buttonLikeWhite.hidden = true;
    buttonLikeBlue.hidden = false;
    
}
-(IBAction)likeBlue{
    buttonLikeBlue.hidden = true;
    buttonLikeWhite.hidden = false;
}


-(IBAction)dislike{
    [player skipToNextItem];
}

#pragma mark -
#pragma mark updateView
-(void)updateView{
    MPMediaItem *curItem = [player nowPlayingItem];
    labelSongTitle.text = [curItem valueForProperty:MPMediaItemPropertyTitle];
    labelAlbumTitle.text = [curItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    labelArtist.text = [curItem valueForProperty:MPMediaItemPropertyArtist];
    labelPastTime.text = [NSString stringWithFormat:@"%01i:%02i ", 0, 0];    
    labelRestTime.text = [NSString stringWithFormat:@"-%01i:%02i ", ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)/60, ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)%60];
    sliderPlayerPos.maximumValue = [[curItem valueForProperty:MPMediaItemPropertyPlaybackDuration] longValue];
    sliderPlayerPos.minimumValue = 0;
    sliderPlayerPos.value = player.currentPlaybackTime;    
    MPMediaItemArtwork *artWork;
    artWork =[curItem valueForProperty:MPMediaItemPropertyArtwork];
    imageArtWork.image = [artWork imageWithSize:imageArtWork.frame.size];
    //scene
    switch (sceneNum) {
        case 1:
            buttonScene1Back.highlighted = true;
            buttonScene2Back.highlighted = false;            
            break;
        case 2:
            buttonScene1Back.highlighted = false;
            buttonScene2Back.highlighted = true;
        default:
            break;
    }
    
    //user default
    NSNumber* sceneNSNum = [[NSNumber alloc] initWithInt:sceneNum];

    //date
    NSDate *date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //time zone
    [formatter setDateFormat:@"Z"];
    NSLog(@"Dict- time zone:%@----------------------------------------------------------", [formatter stringFromDate:date]);
    NSString *timeZone = [NSString stringWithString:[formatter stringFromDate:date]];
    //year
    [formatter setDateFormat:@"y"];
    NSLog(@"Dict- yaer:%@", [formatter stringFromDate:date]);
    NSString *year = [NSString stringWithString:[formatter stringFromDate:date]];
    //month
    [formatter setDateFormat:@"M"];
    NSLog(@"Dict- month:%@", [formatter stringFromDate:date]);
    NSString *month = [NSString stringWithString:[formatter stringFromDate:date]];
    //day of the month
    [formatter setDateFormat:@"d"];
    NSLog(@"Dict- day of the month:%@", [formatter stringFromDate:date]);
    NSString *dayOfTheMonth = [NSString stringWithString:[formatter stringFromDate:date]];
    //day of the week
    //[formatter setDateFormat:@"E"];
    //NSLog(@"day of the week:%@", [formatter stringFromDate:date]);
    //NSString *dayOfTheWeek = [NSString stringWithString:[formatter stringFromDate:date]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSLog(@"Dict- the number of the day of the week:%i", [comps weekday]);
    NSString *dayOfTheWeek = [NSString stringWithFormat:@"%u", [comps weekday]];
    //hour
    [formatter setDateFormat:@"H"];
    NSLog(@"Dict- hour:%@", [formatter stringFromDate:date]);
    NSString *hour = [NSString stringWithString:[formatter stringFromDate:date]];
    //min
    [formatter setDateFormat:@"m"];
    NSLog(@"Dict- minute:%@", [formatter stringFromDate:date]);
    NSString *minute = [NSString stringWithString:[formatter stringFromDate:date]];
    //sec
    [formatter setDateFormat:@"s"];
    NSLog(@"Dict- second:%@", [formatter stringFromDate:date]);
    NSString *second = [NSString stringWithString:[formatter stringFromDate:date]];
    
    
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
    //NSDictionary* hoge = [userDefaults dictionaryForKey:@"privateLog"];
    NSLog(@"%d", array.count);
    
    
    //annotation
    //user random
    /*
    [myMapView addAnnotation:
     [[[SimpleAnnotation alloc]initWithLocationCoordinate:CLLocationCoordinate2DMake([labelLatitude.text floatValue]+arc4random()%100*0.0001-0.005 , [labelLongitude.text floatValue]+arc4random()%100*0.0001-0.005)
                                                    title:[curItem valueForProperty:MPMediaItemPropertyTitle]
                                                 subtitle:labelDate.text]autorelease]];
    */
     //not use random
    //[myMapView addAnnotation:
    // [[[SimpleAnnotation alloc]initWithLocationCoordinate:CLLocationCoordinate2DMake([labelLatitude.text floatValue] , [labelLongitude.text floatValue])
    //                                                title:[curItem valueForProperty:MPMediaItemPropertyTitle]
    //                                             subtitle:labelDate.text]autorelease]];
    
    //adjest annotation
    //NSSet *nearbySet = [self.mapView annotationsInMapRect:self.mapView.frame];
    //- (NSSet *)annotationsInMapRect:(MKMapRect)mapRect
    //[myMapView annotationsInMapRect:myMapView.visibleMapRect];
    
    
    //NSString *url4YouTube = [NSString stringWithFormat:@"http://www.youtube.com/results?search_query=%@&aq=f", labelArtist.text ];
    //NSLog(url4YouTube);

    //[test setUrl: url4YouTube];
    
    
    /* 1/2-not use random
    SimpleAnnotation *myAnnotation=[[SimpleAnnotation alloc] initWithLocationCoordinate:CLLocationCoordinate2DMake([labelLatitude.text floatValue],[labelLongitude.text floatValue]) title:@"music" subtitle:nil];
    [myAnnotation setUrl:@"http://apple.com"];
    [myMapView addAnnotation:myAnnotation];
    */
    // 2/2-use random
    
    //再生してなかったらnilでbug
    if (player.playbackState == MPMusicPlaybackStatePlaying) {
        SimpleAnnotation *myAnnotation=[[SimpleAnnotation alloc] initWithLocationCoordinate:CLLocationCoordinate2DMake([[pin objectForKey:@"Latitude"] doubleValue],[[pin objectForKey:@"Longitude"] doubleValue]) title:@"1 music" subtitle:nil];
        NSLog(@"Now Playing Pin LAT:%f LON:%f", [myAnnotation coordinate].latitude, [myAnnotation coordinate].longitude);
        
        [myAnnotation setMediaDictArray:[NSArray arrayWithObject:pin]];
        NSLog(@"musicDistArray:%@", [[myAnnotation mediaDictArray] description]);
        [myMapView addAnnotation:myAnnotation];
        [myMapView setDelegate:self];
    }
    NSLog(@"done update");
}


#pragma mark -
#pragma mark picker
//picker----------------------------------------------------
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection {
    [self dismissModalViewControllerAnimated: YES];
    //[self updatePlayerQueueWithMediaCollection: collection];
    for(MPMediaItem *item in collection.items){;
        NSLog(@"title: %@", [item valueForProperty:MPMediaItemPropertyTitle]);
    };
    [player setQueueWithItemCollection:collection];
    [player play];
    pikcerDone = true;
}



- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self dismissModalViewControllerAnimated: YES];
}

- (IBAction) showMediaPicker{
    
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc]
     initWithMediaTypes: MPMediaTypeAnyAudio]; // 1
    [picker setDelegate: self]; // 2
    [picker setAllowsPickingMultipleItems: YES]; // 3
    picker.prompt =
    NSLocalizedString (@"Add songs to play",
                       "Prompt in media item picker");
    [self presentModalViewController: picker animated: YES]; // 4
    [picker release];
}

#pragma mark -
#pragma mark map
//map----------------------------------------------------
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"NEW LOCATION!");
    labelLatitude.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    labelLongitude.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    MKCoordinateRegion  region = myMapView.region;
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    //*should be fix******************************************************************************************************
    //region.span.latitudeDelta = 0.01;
    //region.span.longitudeDelta = 0.01;
    region.span.latitudeDelta = myMapView.region.span.latitudeDelta;
    region.span.longitudeDelta = myMapView.region.span.longitudeDelta;
    NSLog(@"Delta LAT:%f LON :%f", myMapView.region.span.latitudeDelta, myMapView.region.span.longitudeDelta);
    
    [myMapView setRegion:region animated:YES];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    compassImg.transform = CGAffineTransformMakeRotation(newHeading.magneticHeading * M_PI/180*-1);
}

#pragma mark -
#pragma mark time
//time------------------------------------------------------------------
-(void) updateClock:(NSTimer*) theTimer{
    NSDate *date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //date
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    labelDate.text = [formatter stringFromDate: date];
    //time
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    labelTime.text = [formatter stringFromDate: date];
    
    //ipod progress bar
    if (player.playbackState == MPMusicPlaybackStatePlaying) {
        sliderPlayerPos.value = sliderPlayerPos.value+1;
        labelPastTime.text = [NSString stringWithFormat:@"%01i:%02i ", (int)sliderPlayerPos.value/60, (int)sliderPlayerPos.value%60];
        labelRestTime.text = [NSString stringWithFormat:@"-%01i:%02i ", ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)/60, ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)%60];        
    }
}

#pragma mark -
#pragma mark scene
//scene----------------------------------------------------------------------------------
-(IBAction)scene1{
    buttonScene1Back.highlighted=true;
    buttonScene2Back.highlighted=false;
    sceneNum = 1;
}
-(IBAction)scene2{
    buttonScene2Back.highlighted=true;
    buttonScene1Back.highlighted=false;
    sceneNum = 2;
    
}


//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    if(!animated){
//        //Instantaneous change, which means you probably did something code-wise, so you should have handled anything there, but you can do it here as well.
//        
//    } else {
//        //User is most likely scrolling, so the best way to do things here is check if the new region is significantly (by whatever standard) away from the starting region
//        
//        CLLocationDistance *distance = [myMapView.centerCoordinate distanceFromLocation:originalCoodinate];
//        if(distance > 1000){
//            //The map region was shifted by 1000 meters
//            //Remove annotations outsides the view, or whatever
//            //Most likely, instead of checking for a distance change, you might want to check for a change relative to the view size
//        }
//        
//    }
//    
//}

//-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    if (annotation == mapView.userLocation) {
//        return nil;
//    }
//    CustomAnnotationView *annotationView;
//    NSString *identifier = @"pin";
//    annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//    if (nil==annotationView) {
//        annotationView  = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//    }
//    annotationView.annotation = annotation;
//    return  annotationView;
//    
//}

#pragma mark -
#pragma mark annnotation
//ピンが落ちてくる処理。    [_mapView addAnnotation:annotation]が呼ばれると、このメソッドが自動的に呼ばれ、上からピンが落ちてくるアニメーションになる。
-(MKAnnotationView*)mapView:(MKMapView*) mapView viewForAnnotation:(id )annotation
{
    //for album
    labelIndexPathRow.text = [NSString stringWithFormat:@"%i", player.indexOfNowPlayingItem];
    //annotation
    if (annotation == mapView.userLocation) {
        return nil;
    }  
    
    MKPinAnnotationView *annotationView;  
    
    NSString* identifier = @"Pin"; 
    
    annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(nil == annotationView) {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
    } 
    
    annotationView.animatesDrop = NO; //このプロパティでアニメーションドロップを設定
    annotationView.canShowCallout = YES; //このプロパティを設定してコールアウト（文字を表示する吹出し）を表示
    annotationView.annotation = annotation; //このメソッドで設定したアノテーションをannotationViewに再追加してreturnで返す
    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[button addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = button;
    NSLog(@"PIN DROPPED-----------------------------------------------------------------------------------------");
    return annotationView;
} 


#pragma mark -
#pragma mark Second Detail View
- (void)showDetails:(id)sender
{

}

- (void)mapView:(MKMapView*)mapView 
 annotationView:(MKAnnotationView*)view 
calloutAccessoryControlTapped:(UIControl*)control
{

    NSLog(@"PIN LAT2:%f", [((SimpleAnnotation*)view.annotation) coordinate].latitude);    
    NSLog(@"PIN LON2:%f", [((SimpleAnnotation*)view.annotation) coordinate].longitude);
    //change labelTappedLatitude and labelTappedLongitude
    
    NSLog(@"Details comes");
    // the detail view does not want a toolbar so hide it
    [self.navigationController setToolbarHidden:YES animated:NO];
    AlbumViewController *myAlbumViewController= [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    myAlbumViewController.annotationLatitude = [NSString stringWithFormat:@"%f", [(SimpleAnnotation*)view.annotation coordinate].latitude];    
    myAlbumViewController.annotationLongitude = [NSString stringWithFormat:@"%f", [(SimpleAnnotation*)view.annotation coordinate].longitude];
    myAlbumViewController.annotationMediaDictArray = [NSArray arrayWithArray: [(SimpleAnnotation*)view.annotation mediaDictArray]];  
    [[self navigationController] pushViewController:myAlbumViewController animated:YES];    
}

#pragma mark -
#pragma mark regionDidChange
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"REGION DID CHANGE---------------------------------------------------------------------------");
    //get the map range
    labelZoomRange.text = [NSString stringWithFormat:@"LAT:%f / LON:%f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta];
    labelMapSize.text = [NSString stringWithFormat:@"MAP W:%f / H:%f", mapView.visibleMapRect.size.width, mapView.visibleMapRect.size.height];
        
    //[1] save the pins
    NSSet *visiblePins= [NSSet setWithSet:[myMapView annotationsInMapRect:MKMapRectMake(myMapView.visibleMapRect.origin.x, myMapView.visibleMapRect.origin.y, myMapView.visibleMapRect.size.width, myMapView.visibleMapRect.size.height)]];
    //#raw data of pins's coodinate
    NSArray *visiblePinsArray = [NSArray arrayWithArray:[visiblePins allObjects]];
    NSLog(@"visiblePinsArray count:%i", [visiblePinsArray count]);
    int pinCounter = visiblePinsArray.count;
    NSLog(@"pinCounter:%i", pinCounter);
    if (pinCounter>0) {
        //setting basic
        float clusterStepWidth = myMapView.visibleMapRect.size.width/GRIDNUMX;
        float clusterStepHeight = myMapView.visibleMapRect.size.height/GRIDNUMY;    
        NSLog(@"clusterStepWidth%f", clusterStepWidth);
        NSLog(@"clusterStepHeight%f", clusterStepHeight);
        
        //[A] in case map expands (zoom in) 
        if (mapView.region.span.latitudeDelta < latitudeDeltaOld || mapView.region.span.longitudeDelta < longitudeDeltaOld) {

            //[2] delete all pins in visible mapview
            [mapView removeAnnotations:visiblePinsArray];
            
            //[3] set pins on the raw coodinate
            for (int i = 0; i<pinCounter; i++) {
                for (int j =0; j<[[[visiblePinsArray objectAtIndex:i] mediaDictArray] count]; j++) {
                    
                    //read visiblePins's rawCoodinateArray----
                    
                    SimpleAnnotation *rawAnnotation = [[SimpleAnnotation alloc] initWithLocationCoordinate:CLLocationCoordinate2DMake([[[[[visiblePinsArray objectAtIndex:i] mediaDictArray] objectAtIndex:j] objectForKey:@"Latitude"] doubleValue], [[[[[visiblePinsArray objectAtIndex:i] mediaDictArray] objectAtIndex:j] objectForKey:@"Longitude"] doubleValue]) title:@"1 music" subtitle:nil];
                    
                    NSArray *myMediaDictArray= [NSArray arrayWithArray:[[visiblePinsArray objectAtIndex:i] mediaDictArray]];
                    rawAnnotation.mediaDictArray = [NSArray arrayWithObject:[myMediaDictArray objectAtIndex:j]];
                    [myMapView addAnnotation:rawAnnotation];
                    [myMapView setDelegate:self];
                } 
            }
            
            //[4] cluster pins
            for (int i=0; i<GRIDNUMY+1; i++) {
                for (int j=0; j<GRIDNUMX+1; j++) {
                    //fix
                    float x = myMapView.visibleMapRect.origin.x+clusterStepWidth*j;
                    float y = myMapView.visibleMapRect.origin.y+clusterStepHeight*i;
                    float clusterX = floorf(x/clusterStepWidth)*clusterStepWidth;
                    float clusterY = floorf(y/clusterStepHeight)*clusterStepHeight;                
                    
                    NSSet *clusteredSet = [NSSet setWithSet:[myMapView annotationsInMapRect:MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)] ];
                    NSArray *clusteredArray = [NSArray arrayWithArray:[clusteredSet allObjects]];
                    [myMapView removeAnnotations:[[myMapView annotationsInMapRect:MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)] allObjects]];
                    
                    
                    
                    
                    
                    
                    NSLog(@"CLUSTERING--GRIDNUM:%02ux%02u / COUNT:%i", j, i, [clusteredArray count]);
                    
                    if ([clusteredArray count]>0) {
                        NSLog(@"CLUSTERING %u pins----------------------------------------------------------------------------------------------", [clusteredArray count]);
                        MKCoordinateRegion clusterRegion = MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight));
                        CLLocation *centralLoc = [[CLLocation alloc] initWithLatitude:clusterRegion.center.latitude longitude:clusterRegion.center.longitude];
                        CLLocation *instantLoc = [[CLLocation alloc] initWithLatitude:[[clusteredArray objectAtIndex:0] coordinate].latitude longitude:[[clusteredArray objectAtIndex:0] coordinate].longitude];
                        double minimumDist = [centralLoc distanceFromLocation:instantLoc];
                        int clusterPosID = 0;
                        NSMutableArray *clusterTitle = [NSMutableArray array];
                        for (int k=0; k<[clusteredArray count]; k++) {
                            NSArray *clusterMediaDictArray = [NSArray arrayWithArray:[[clusteredArray objectAtIndex:k] mediaDictArray]];
                            [clusterTitle addObjectsFromArray: clusterMediaDictArray];
                            //compare the distance from central and find the most nearest pin from central
                            if (k>0) {
                                CLLocation *instantLocForComparing = [[CLLocation alloc] initWithLatitude:[[clusteredArray objectAtIndex:k] coordinate].latitude longitude:[[clusteredArray objectAtIndex:k] coordinate].longitude];
                                if ([centralLoc distanceFromLocation:instantLocForComparing] < minimumDist) {
                                    minimumDist = [instantLoc distanceFromLocation:instantLocForComparing];
                                    clusterPosID = k;
                                }
                            }
                        }
                        //draw pin on the central of the grid   
                        SimpleAnnotation *newCluterAnnotation = [[SimpleAnnotation alloc]
                                                                 initWithLocationCoordinate:CLLocationCoordinate2DMake([[clusteredArray objectAtIndex:clusterPosID] coordinate].latitude, [[clusteredArray objectAtIndex:clusterPosID] coordinate].longitude)
                                                                 title:[NSString stringWithFormat:@"%i music", clusterTitle.count]
                                                                 subtitle:nil];
                        newCluterAnnotation.mediaDictArray = [NSArray arrayWithArray: clusterTitle];
                        [myMapView addAnnotation:newCluterAnnotation];
                        [myMapView setDelegate:self];
                        
                        NSLog(@"cluster spreaded! pos Lat:%f Lon:%f", CLLocationCoordinate2DMake([mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.latitude, [mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.longitude).latitude, CLLocationCoordinate2DMake([mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.latitude, [mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.longitude).longitude);
                        NSLog(@"Finished Clustering-(zoom in version)---------------------------------------------------------------------------------------");
                    }
                }
            }  
        }else {
            //[B] in case map shrink (zoom out)
            //[4] cluster pins
            for (int i=0; i<GRIDNUMY+1; i++) {
                for (int j=0; j<GRIDNUMX+1; j++) {
                    //fix
                    float x = myMapView.visibleMapRect.origin.x+clusterStepWidth*j;
                    float y = myMapView.visibleMapRect.origin.y+clusterStepHeight*i;
                    float clusterX = floorf(x/clusterStepWidth)*clusterStepWidth;
                    float clusterY = floorf(y/clusterStepHeight)*clusterStepHeight;                
                    
                    NSSet *clusteredSet = [NSSet setWithSet:[myMapView annotationsInMapRect:MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)] ];
                    NSArray *clusteredArray = [NSArray arrayWithArray:[clusteredSet allObjects]];
                    [myMapView removeAnnotations:[[myMapView annotationsInMapRect:MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)] allObjects]]; 
                    NSLog(@"CLUSTERING--GRIDNUM:%02ux%02u / COUNT:%i", j, i, [clusteredArray count]);
                    if ([clusteredArray count]>0) {
                        NSLog(@"CLUSTERING %u pins----------------------------------------------------------------------------------------------", [clusteredArray count]);
                        MKCoordinateRegion clusterRegion = MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight));
                        CLLocation *centralLoc = [[CLLocation alloc] initWithLatitude:clusterRegion.center.latitude longitude:clusterRegion.center.longitude];
                        CLLocation *instantLoc = [[CLLocation alloc] initWithLatitude:[[clusteredArray objectAtIndex:0] coordinate].latitude longitude:[[clusteredArray objectAtIndex:0] coordinate].longitude];
                        double minimumDist = [centralLoc distanceFromLocation:instantLoc];
                        int clusterPosID = 0;
                        NSMutableArray *clusterTitle = [NSMutableArray array];
                        for (int k=0; k<[clusteredArray count]; k++) {
                            NSArray *clusterMediaDictArray = [NSArray arrayWithArray:[[clusteredArray objectAtIndex:k] mediaDictArray]];
                            NSLog(@"results:%@", [clusterMediaDictArray description]);
                            [clusterTitle addObjectsFromArray: clusterMediaDictArray];
                            //compare the distance from central and find the most nearest pin from central
                            if (k>0) {
                                CLLocation *instantLocForComparing = [[CLLocation alloc] initWithLatitude:[[clusteredArray objectAtIndex:k] coordinate].latitude longitude:[[clusteredArray objectAtIndex:k] coordinate].longitude];
                                if ([centralLoc distanceFromLocation:instantLocForComparing] < minimumDist) {
                                    minimumDist = [instantLoc distanceFromLocation:instantLocForComparing];
                                    clusterPosID = k;
                                }
                            }
                            
                        }
                        //draw pin on the central of the grid                
                        SimpleAnnotation *newCluterAnnotation = [[SimpleAnnotation alloc]
                                                                 initWithLocationCoordinate:CLLocationCoordinate2DMake([[clusteredArray objectAtIndex:clusterPosID] coordinate].latitude, [[clusteredArray objectAtIndex:clusterPosID] coordinate].longitude)
                                                                 title:[NSString stringWithFormat:@"%i music", clusterTitle.count]
                                                                 subtitle:nil];
                        NSLog(@"clusterTitle Desc:%@ Count:%i",[clusterTitle description], [clusterTitle count]);
                        newCluterAnnotation.mediaDictArray = [NSArray arrayWithArray: clusterTitle];
                        [myMapView addAnnotation:newCluterAnnotation];
                        [myMapView setDelegate:self];
                        NSLog(@"cluster gathered! pos Lat:%f Lon:%f", CLLocationCoordinate2DMake([mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.latitude, [mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.longitude).latitude, CLLocationCoordinate2DMake([mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.latitude, [mapView convertRect:[mapView convertRegion:MKCoordinateRegionForMapRect(MKMapRectMake(clusterX, clusterY, clusterStepWidth, clusterStepHeight)) toRectToView:myMapView] toRegionFromView:myMapView].center.longitude).longitude);
                        NSLog(@"Finished Clustering-zoom out version---------------------------------------------------------------------------------------");
                    }
                }
            }
        }
    }
    latitudeDeltaOld = mapView.region.span.latitudeDelta;
    longitudeDeltaOld = mapView.region.span.longitudeDelta;
    NSLog(@"END OF regionDidChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    NSLog(@"REGION WILL CHANGE");
    
}


-(IBAction)micSwitch{
    if(isMicPlaying){
        [self micStop];
        buttonMicWhite.hidden = false;
        buttonMicBlue.hidden = true;
    }else {
        [self micPlay];
        buttonMicBlue.hidden = false;
        buttonMicWhite.hidden = true;
    } 
}

-(IBAction)showSettingView{
    // the detail view does not want a toolbar so hide it
    [self.navigationController setToolbarHidden:YES animated:NO];
    SettingViewController *mySettingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    [[self navigationController] pushViewController:mySettingViewController animated:YES];
}

#pragma mark -
#pragma mark Unload
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (pikcerDone) {
        //add pin
        [self updateView];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}
@end
