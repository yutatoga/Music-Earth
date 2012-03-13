//
//  AlbumViewController.m
//  Music Earth
//
//  Created by  on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumViewController.h"

@implementation AlbumViewController

@synthesize label;
@synthesize message;

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Album";
    label.text = message;
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    self.label = nil;
    self.message = nil;
    [super viewDidUnload];
}


@end