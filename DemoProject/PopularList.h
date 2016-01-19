//
//  PopularList.h
//  test
//
//  Created by Rich Long on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"
#import "ListItem.h"

/*
 Class that uses NSXMLParser and it's delegate methods to parse
 XML from web service. Puts each item using ListItem class into an array
 */

@interface PopularList : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong)NSXMLParser *parser;
@property (nonatomic, strong)ListItem *currentItem;
@property (nonatomic, strong)NSMutableArray *listOfPopularItems;
@property (nonatomic, assign)BOOL isShortDesc;
@property (nonatomic, assign)BOOL isTitle;
@property (nonatomic, strong)NSMutableString *tempShortDesc;
@property (nonatomic, strong)NSMutableString *tempTitle;

- (instancetype)initWithXML:(NSData*)xml;

@end
