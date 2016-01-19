//
//  ListItem.m
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (instancetype)initWithTitle:(NSString*)title ShortDescription:(NSString*)shortDesc AndURL:(NSString*)url {
   
    self = [super init];
    
    if (self) {
        self.title = title;
        self.shortDescription = shortDesc;
        self.url = url;
    }
    
    return self;
}


- (id)copyWithZone:(NSZone *)zone {

    ListItem *copy = [self initWithTitle:self.title ShortDescription:self.shortDescription AndURL:self.url];
    return copy;
    
}

@end
