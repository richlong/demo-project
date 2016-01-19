//
//  SingleItem.h
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleItem : NSObject <NSXMLParserDelegate>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *synopsis;
@property (nonatomic,strong)NSMutableString *tempSynopsis;
@property (nonatomic,copy) NSString *broadcastChannel;

@property (nonatomic, strong)NSXMLParser *parser;
@property (nonatomic, assign)BOOL isTitle;
@property (nonatomic, assign)BOOL isSynopsis;
@property (nonatomic, assign)BOOL isImage;
@property (nonatomic, assign)BOOL isBroadcastChannel;

- (instancetype)initWithXML:(NSData*)xml;

@end
