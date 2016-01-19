//
//  ViewController.m
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //TODO: add animation for loading
    
    //Set up network connection to end point
    self.network = [[Network alloc] initWithDelegate:self];
    
    //Hide UI until content loaded
    self.imageView.hidden = YES;
    self.itemTitle.hidden = YES;
    self.broadcastChannel.hidden = YES;
    self.synopsis.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        if (self.listItem) {
            [self.network getSingleItem:self.listItem.url];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates once complete
                [self recieveSingleItemError:500];
            });
        }
    });
}

#pragma mark - Single item delegate methods

- (void)recieveSingleItem:(NSData *)xmlResponse {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        self.singleItem = [[SingleItem alloc]initWithXML:xmlResponse];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates once complete
            [self setUIElementContent];
        });
    });
}

- (void)recieveSingleItemError:(long)statusCode {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:[NSString stringWithFormat:@"Error %ld\n Unable to load content", statusCode]
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)recieveImage:(NSData *)dataResponse {
    
    UIImage *downloadedImage = [UIImage imageWithData: dataResponse];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates once complete
        [self.imageView setImage:downloadedImage];
    });

    
}

- (void)setUIElementContent {
    
    self.itemTitle.text = self.singleItem.title;
    self.broadcastChannel.text = self.singleItem.broadcastChannel;
    self.synopsis.text = self.singleItem.synopsis;
    
    [self.network getImage:self.singleItem.image];
    
    self.imageView.hidden = NO;
    self.itemTitle.hidden = NO;
    self.broadcastChannel.hidden = NO;
    self.synopsis.hidden = NO;
}

@end
