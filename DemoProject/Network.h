//
//  Network.h
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PopularListDelegate <NSObject>

- (void)recievePopularList:(NSData*)xmlResponse;
- (void)recievePopularListError:(long)statusCode;
@end

@protocol SingleItemDelegate <NSObject>

- (void)recieveSingleItem:(NSData*)xmlResponse;
- (void)recieveSingleItemError:(long)statusCode;

@end

@interface Network : NSObject

@property (nonatomic,weak) id delegate;

- (instancetype)initWithDelegate:(id)delegate;

- (void)getXMLFromURL:(NSString*)url WithCompletionHandler:(void(^)(long statusCode, NSData *xmlResponse))completionHandler;

- (void)getPopularList;
- (void)getSingleItem:(NSString*)url;

@end
