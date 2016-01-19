//
//  Network.m
//  test
//
//  Created by Rich Long on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import "Network.h"

@implementation Network

static NSString *baseURL = @"http://goio.sky.com";
static NSString *popularListURL = @"http://goio.sky.com/vod/content/Home/Application_Navigation/Sky_Movies/Most_Popular/content/promoPage.do.xml";

- (instancetype)initWithDelegate:(id)delegate {
    
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)getXMLFromURL:(NSString*)url WithCompletionHandler:(void(^)(long statusCode, NSData *xmlResponse))completionHandler{
    
    @try {
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:url]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                                                        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                                        long responseStatusCode = [httpResponse statusCode];
                                                        completionHandler(responseStatusCode,data);
                                                        
                                                        if (error) {
                                                            NSLog(@"error %@",error);
                                                        }
                                                        
                                                    }] resume];
    }
    @catch (NSException *exception) {
        NSLog(@"error %@",exception);
        completionHandler(500,nil);
    }
}

- (void)getFileFromURL:(NSString*)url WithCompletionHandler:(void(^)(long statusCode, NSData *dataResponse))completionHandler{
    
    @try {
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session  downloadTaskWithURL:[NSURL URLWithString:url]
                     completionHandler:^(NSURL * _Nullable location,
                                         NSURLResponse * _Nullable response,
                                         NSError * _Nullable error) {

                         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                         long responseStatusCode = [httpResponse statusCode];
                         completionHandler(responseStatusCode,[NSData dataWithContentsOfURL:location]);
                         
                         if (error) {
                             NSLog(@"error %@",error);
                         }

                     }] resume];

    }
    @catch (NSException *exception) {
        NSLog(@"error %@",exception);
        completionHandler(500,nil);
    }
}


#pragma mark - Convenience methods

- (void)getPopularList {
    
    [self getXMLFromURL:popularListURL WithCompletionHandler:^(long statusCode, NSData *xmlResponse) {
        
        if (statusCode == 200) {
            [self.delegate recievePopularList:xmlResponse];
        }
        else {
            [self.delegate recievePopularListError:statusCode];
        }
    }];
}

- (void)getSingleItem:(NSString*)url {
    
    NSString *fullURL = [[NSMutableString alloc] initWithFormat:@"%@%@",baseURL,url];
    
    [self getXMLFromURL:fullURL WithCompletionHandler:^(long statusCode, NSData *xmlResponse) {
        
        if (statusCode == 200) {
            [self.delegate recieveSingleItem:xmlResponse];
        }
        else {
            [self.delegate recieveSingleItemError:statusCode];
        }
    }];
}

- (void)getImage:(NSString*)url {
 
    [self getFileFromURL:url WithCompletionHandler:^(long statusCode, NSData *dataResponse) {
        
        if (statusCode == 200) {
            [self.delegate recieveImage:dataResponse];
        }
        
    }];
}

@end
