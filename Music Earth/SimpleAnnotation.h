//
//  SimpleAnnotation.h
//  Music Earth
//
//  Created by  on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SimpleAnnotation : NSObject <MKAnnotation> {
 	CLLocationCoordinate2D coordinate;  
 	NSString *annotationTitle;  
 	NSString *annotationSubtitle;
    NSString *url;
    NSArray *mediaTitleArray;
}  

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;  
@property (nonatomic, readwrite) CLLocationCoordinate2D rawCoodinate;
@property (nonatomic, retain) NSMutableArray *rawCoodinateLatitudeArray;
@property (nonatomic, retain) NSMutableArray *rawCoodinateLongitudeArray;
@property (nonatomic, retain) NSString *annotationTitle;
@property (nonatomic, retain) NSString *annotationSubtitle;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSArray *mediaTitleArray;
@property (nonatomic, retain) NSString *mediaArtist;



- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord   
						   title:(NSString *)annTitle subtitle:(NSString *)annSubtitle;  
- (NSString *)title;  
- (NSString *)subtitle;
- (int) getCount;
@end
