//
//  SingleItem.m
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import "SingleItem.h"

@implementation SingleItem

static NSString * const kVideoDetails = @"sp:VideoDetails";
static NSString * const kImage = @"Image";
static NSString * const kSynopsis = @"Synopsis";
static NSString * const kBroadcastChannel = @"Name";
static NSString * const kTitle = @"Title";

- (instancetype)initWithXML:(NSData*)xml
{
    self = [super init];
    if (self) {
        
        self.parser = [[NSXMLParser alloc] initWithData:xml];
        self.parser.delegate = self;
        [self.parser parse];
        
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:kTitle]) {
        self.isTitle = YES;
    }
    else if ([elementName isEqualToString:kImage]) {
        self.isImage = YES;
    }
    else if ([elementName isEqualToString:kBroadcastChannel]) {
        self.isBroadcastChannel = YES;
    }
    else if ([elementName isEqualToString:kSynopsis]) {
        self.tempSynopsis = [NSMutableString new];
        self.isSynopsis = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
        if (self.isTitle) {
            self.title = string;
        }
        else if (self.isImage) {
            self.image = string;
        }
        else if (self.isBroadcastChannel) {
            self.broadcastChannel = string;
        }
        else if (self.isSynopsis) {
            [self.tempSynopsis appendString:string];
        }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    //Exit if parse ended
    if ([elementName isEqualToString:kVideoDetails]) {
        return;
    }

    if ([elementName isEqualToString:kTitle]) {
        self.isTitle = NO;
    }
    else if ([elementName isEqualToString:kImage]) {
        self.isImage = NO;
    }
    else if ([elementName isEqualToString:kBroadcastChannel]) {
        self.isBroadcastChannel = NO;
    }
    else if ([elementName isEqualToString:kSynopsis]) {
        self.synopsis = [self.tempSynopsis copy];
        self.isSynopsis = NO;
    }
}

@end
