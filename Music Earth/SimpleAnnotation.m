//
//  SimpleAnnotation.m
//  Music Earth
//
//  Created by  on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleAnnotation.h"

@implementation SimpleAnnotation


@synthesize coordinate;
@synthesize rawCoodinateArray;
@synthesize annotationTitle;
@synthesize annotationSubtitle;
@synthesize url;
@synthesize mediaTitleArray;
@synthesize mediaArtist;


- (NSString *)title {  
	return annotationTitle;  
}  

- (NSString *)subtitle {  
	return annotationSubtitle;  
} 


- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord   
						   title:(NSString *)annTitle
                        subtitle:(NSString *)annSubtitle {  
	coordinate.latitude = coord.latitude;  
	coordinate.longitude = coord.longitude;  
	self.annotationTitle = annTitle;  
	self.annotationSubtitle = annSubtitle;  
	return self;  
}  


- (void) dealloc {  
	[annotationTitle release];  
	[annotationSubtitle release];  
	[url release];
    [mediaTitleArray release];
	[super dealloc];  
}  

@end