//
//  ListItem.h
//  test
//
//  Created by Rich Long on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject <NSCopying>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *shortDescription;

- (instancetype)initWithTitle:(NSString*)title ShortDescription:(NSString*)shortDesc AndURL:(NSString*)url;

@end
