//
//  NetworkTests.m
//  DemoProject
//
//  Created by Rich Long on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Network.h"
@interface NetworkTests : XCTestCase <SingleItemDelegate, PopularListDelegate>

@property (nonatomic, strong) Network *network;
@property (nonatomic, strong) XCTestExpectation *expectation;
@property (nonatomic, strong) NSData *xmlResponse;
@property (nonatomic, assign) BOOL delegateMethodCalled;

@end

@implementation NetworkTests

static NSString *popularListURL = @"http://goio.sky.com/vod/content/Home/Application_Navigation/Sky_Movies/Most_Popular/content/promoPage.do.xml";

- (void)setUp {
    [super setUp];
    self.network = [[Network alloc]initWithDelegate:self];
}

- (void)tearDown {
    self.network = nil;
    [super tearDown];
}

- (void)testObjectInit {
    self.network = [[Network alloc]initWithDelegate:self];
    XCTAssertNotNil(self.network);
}

- (void)testNetworkCanReachValidEndpoint {
    
    //Tests that network class can access endpoint correctly using getXMLFromURL
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing http get request"];

    __block long statusCodeValidation;
    __block NSData *xmlResponseValidation;

    [self.network getXMLFromURL:popularListURL WithCompletionHandler:^(long statusCode, NSData *xmlResponse) {
        statusCodeValidation = statusCode;
        xmlResponseValidation = xmlResponse;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error){
            XCTFail(@"Expectation Failed with error: %@", error);
        }

        XCTAssertNotNil(xmlResponseValidation);
        XCTAssert(statusCodeValidation == 200);

    }];

}

- (void)testNetworkwithInvalidEndpoint {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing http get request"];
    
    __block long statusCodeValidation;
    __block NSData *xmlResponseValidation;
    
    //Use invalid URL to test response
    [self.network getXMLFromURL:[NSString stringWithFormat:@"%@xxx",popularListURL] WithCompletionHandler:^(long statusCode, NSData *xmlResponse) {
        statusCodeValidation = statusCode;
        xmlResponseValidation = xmlResponse;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error){
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
        XCTAssertNotNil(xmlResponseValidation);
        XCTAssert(statusCodeValidation == 404);
        
    }];
    
}


- (void)testRecievePopularList {
    
    // Async testing using Network class to get data from endpoint
    // Testing delegate method is called
    
    self.expectation = [self expectationWithDescription:@"Testing http get request"];
    self.network = [[Network alloc] initWithDelegate:self];
    [self.network getPopularList];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        XCTAssert(self.delegateMethodCalled);
        XCTAssertNotNil(self.xmlResponse);
        
    }];
}
#pragma mark - Delegate methods
#pragma mark - Popular List

- (void)recievePopularList:(NSData *)xmlResponse {
    self.xmlResponse = xmlResponse;
    self.delegateMethodCalled = YES;
    [self.expectation fulfill];
}

- (void)recievePopularListError:(long)statusCode {
    
}

#pragma mark - Single item

- (void)recieveSingleItem:(NSData *)xmlResponse {
    
}

- (void)recieveSingleItemError:(long)statusCode {
    
}

- (void)recieveImage:(NSData *)dataResponse {
    
}

@end
