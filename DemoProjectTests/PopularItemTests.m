//
//  PopularItemTests.m
//  DemoProject
//
//  Created by Internet Dev on 20/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PopularList.h"
#import "Network.h"
#import "ListItem.h"

@interface PopularItemTests : XCTestCase <PopularListDelegate>

@property (nonatomic, strong) PopularList *popularList;
@property (nonatomic, strong) Network *network;
@property (nonatomic, strong) XCTestExpectation *expectation;
@end

@implementation PopularItemTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    self.popularList = nil;
    self.network = nil;
    
    [super tearDown];
}

- (void)testObjectInit {
    self.popularList = [[PopularList alloc] initWithXML:nil];
    XCTAssertNotNil(self.popularList);
}

- (void)testPopularListGetsPopulatedWithValidXML {
    
    // Async testing using Network class to get data from endpoint - should be mocked.
    
    self.expectation = [self expectationWithDescription:@"Testing http get request"];
    self.network = [[Network alloc] initWithDelegate:self];
    [self.network getPopularList];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }

        XCTAssertNotNil(self.popularList);
        XCTAssert([self.popularList listOfPopularItems].count > 0);
        
        ListItem *listItem = [[self.popularList listOfPopularItems] objectAtIndex:0];
        
        //Brittle test as item likely to change, should store local copy of valid XML
        XCTAssert([listItem.title isEqualToString:@"American Sniper"]);

    }];
}

#pragma mark - Delegate methods
#pragma mark - Popular List

- (void)recievePopularList:(NSData *)xmlResponse {

    self.popularList = [[PopularList alloc] initWithXML:xmlResponse];
    [self.expectation fulfill];
}

- (void)recievePopularListError:(long)statusCode {
    
    // Not used
}
@end
