//
//  Music_EarthViewController.m
//  Music Earth
//
//  Created by  on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Music_EarthViewController.h"
#import "AlbumViewController.h"
@implementation Music_EarthViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    labelPastTime.text =[NSString stringWithFormat:@"%d", player.currentPlaybackTime];
    //player volume
    sliderVolume.value = player.volume;
    labelVolumeNum.text = [NSString stringWithFormat:@"%f", sliderVolume.value];
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
    
    //time
    timerClock=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
    
    //read user defaults
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
    NSArray *arrayOld=[defaults arrayForKey:@"userData"];
    NSLog(@"read pinNum: %d", arrayOld.count);
    
    NSMutableArray* array = [NSMutableArray array];
    //add old pins
    for (int i=0; i<arrayOld.count; i++) {
        [array addObject:[arrayOld objectAtIndex:i]];
    }
    //[array addObject:myArray];
    [defaults setObject:array forKey:@"userData"];
    
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
    airplayButton = [[MPVolumeView alloc] init];
    airplayButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
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
    
    //navigate
    
    // this line calls the viewDidLoad method of detailController


}

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
    NSMutableDictionary* pin = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                [curItem valueForProperty:MPMediaItemPropertyTitle], @"Title", 
                                [curItem valueForProperty:MPMediaItemPropertyArtist], @"Artist",
                                [curItem valueForProperty:MPMediaItemPropertyAlbumTitle], @"Album",
                                labelLatitude.text, @"Latitude",
                                labelLongitude.text, @"Longitude",
                                labelDate.text, @"Time",
                                labelVolumeNum.text, @"Volume",
                                sceneNSNum, @"Scene",
                                nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOld=[defaults arrayForKey:@"userData"];
    NSLog(@"arrayOldNum: %d", arrayOld.count);
    
    NSMutableArray* array = [NSMutableArray array];
    //add old pins
    for (int i=0; i<arrayOld.count; i++) {
        [array addObject:[arrayOld objectAtIndex:i]];
    }
    //add new pin
    [array addObject:pin];
    //[array addObject:myArray];
    [defaults setObject:array forKey:@"userData"];
    
    if ( ![defaults synchronize] ) {
        NSLog( @"failed ..." );
    }
    //NSDictionary* hoge = [userDefaults dictionaryForKey:@"userData"];
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
    
    SimpleAnnotation *test=[[SimpleAnnotation alloc] initWithLocationCoordinate:CLLocationCoordinate2DMake([labelLatitude.text floatValue],[labelLongitude.text floatValue]) title:@"music" subtitle:nil];
    [test setUrl:@"http://apple.com"];
    [myMapView addAnnotation:test];
    [myMapView setDelegate:self];
}


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
//map----------------------------------------------------
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    labelLatitude.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    labelLongitude.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    MKCoordinateRegion  region = myMapView.region;
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [myMapView setRegion:region animated:YES];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    compassImg.transform = CGAffineTransformMakeRotation(newHeading.magneticHeading * M_PI/180*-1);
}


//time------------------------------------------------------------------
-(void) updateClock:(NSTimer*) theTimer{
    NSDate* date = [NSDate date];
    NSDateFormatter* form = [[NSDateFormatter alloc] init];
    //date
    [form setDateStyle:NSDateFormatterFullStyle];
    [form setTimeStyle:NSDateFormatterNoStyle];
    labelDate.text = [form stringFromDate: date];
    //time
    [form setDateStyle:NSDateFormatterNoStyle];
    [form setTimeStyle:NSDateFormatterMediumStyle];
    labelTime.text = [form stringFromDate: date];
    
    //ipod progress bar
    if (player.playbackState == MPMusicPlaybackStatePlaying) {
        sliderPlayerPos.value = sliderPlayerPos.value+1;
        labelPastTime.text = [NSString stringWithFormat:@"%01i:%02i ", (int)sliderPlayerPos.value/60, (int)sliderPlayerPos.value%60];
        labelRestTime.text = [NSString stringWithFormat:@"-%01i:%02i ", ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)/60, ((int)sliderPlayerPos.maximumValue-(int)sliderPlayerPos.value)%60];        
    }
    
}

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
//ピンが落ちてくる処理。    [_mapView addAnnotation:annotation]が呼ばれると、このメソッドが自動的に呼ばれ、上からピンが落ちてくるアニメーションになる。
-(MKAnnotationView*)mapView:(MKMapView*) mapView viewForAnnotation:(id )annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }  
    
    MKPinAnnotationView *annotationView;  
    
    NSString* identifier = @"Pin"; 
    
    annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(nil == annotationView) {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
    } 
    
    annotationView.animatesDrop = YES; //このプロパティでアニメーションドロップを設定
    annotationView.canShowCallout = YES; //このプロパティを設定してコールアウト（文字を表示する吹出し）を表示
    annotationView.annotation = annotation; //このメソッドで設定したアノテーションをannotationViewに再追加してreturnで返す
    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = button;
    return annotationView;
} 



- (void)showDetails:(id)sender
{
    NSLog(@"Details comes");
    // the detail view does not want a toolbar so hide it
    [self.navigationController setToolbarHidden:YES animated:NO];
    AlbumViewController *albumViewControllerK= [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];

    [[self navigationController] pushViewController:albumViewControllerK animated:YES];

}






- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
