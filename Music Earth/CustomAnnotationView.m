//
//  CustomAnnotationView.m
//  Music Earth
//
//  Created by  on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView
-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.image = [UIImage imageNamed:@"pinGreen.png"];//32x39
    self.canShowCallout  = YES;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(revealDetail:) forControlEvents:UIControlEventTouchUpInside];
    self.rightCalloutAccessoryView = button;
    return self;
}
-(void)revealDetail: (id)sender{
    NSURL *url = [[NSURL alloc] initWithString:[(SimpleAnnotation*) self.annotation url]];
    [[UIApplication sharedApplication] openURL:url];
}
@end
