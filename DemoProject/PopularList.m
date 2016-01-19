//
//  PopularList.m
//  test
//
//  Created by Rich Long on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import "PopularList.h"

#pragma mark - List Nodes

static NSString * const kPromoItems = @"PromoItems";
static NSString * const kItem = @"item";
static NSString * const kUrl = @"url";
static NSString * const kShortDesc = @"ShortDescription";
static NSString * const kTitle = @"title";

@implementation PopularList

- (instancetype)initWithXML:(NSData*)xml
{
    self = [super init];
    if (self) {
        
        self.listOfPopularItems = [NSMutableArray new];

        self.parser = [[NSXMLParser alloc] initWithData:xml];
        self.parser.delegate = self;
        [self.parser parse];
        
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:kItem]) {
        self.currentItem = [[ListItem alloc] init];
        self.currentItem.url = [attributeDict objectForKey:kUrl];
    }
    if ([elementName isEqualToString:kTitle]) {
        self.isTitle = YES;
        self.tempTitle = [NSMutableString new];
    }
    else if ([elementName isEqualToString:kShortDesc]) {
        self.isShortDesc = YES;
        self.tempShortDesc = [NSMutableString new];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (self.currentItem) {
    
        if (self.isTitle) {
            [self.tempTitle appendString:string];

        }
        else if (self.isShortDesc) {
            [self.tempShortDesc appendString:string];
        }

    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    //Exit if parse ended
    if ([elementName isEqualToString:kPromoItems]) {
        return;
    }
    
    if ([elementName isEqualToString:kTitle]) {
        self.currentItem.title = self.tempTitle;
        self.isTitle = NO;
        self.tempTitle = nil;
    }
    else if ([elementName isEqualToString:kShortDesc]) {
        self.currentItem.shortDescription = [self.tempShortDesc copy];
        self.isShortDesc = NO;
        self.tempShortDesc = nil;
    }
    else if ([elementName isEqualToString:kItem]) {
        
        [self.listOfPopularItems addObject:[self.currentItem copy]];
        self.currentItem = nil;
    }
}

@end
