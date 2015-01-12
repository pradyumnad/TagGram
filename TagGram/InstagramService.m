//
//  InstagramService.m
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import "InstagramService.h"

#define tag @"cats"

NSString *const kClientId = @"";    // Instagram client id
NSString *const kTagsMediaURL = @"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@";

NSString *const kNextURLKey = @"next_url";
NSString *const kPaginationKey = @"pagination";
NSString *const kDataKey = @"data";

@implementation InstagramService

+ (id)sharedService {
    static InstagramService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (id)init {
    if (self == [super init]) {
        _isLoading = NO;
        _nextURL = @"";
        return self;
    }
    return nil;
}

- (void)fetchTaggedMediaWithSuccessBlock:(SuccessBlock)successBlock
                         andFailureBlock:(FailureBlock)failureBlock
{
    NSString *urlAsString = [[NSString stringWithFormat:kTagsMediaURL, tag, kClientId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    _isLoading = YES;
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSLog(@"%@", response);
                               if (error) {
                                   failureBlock(error);
                               } else {
                                   NSError *jsonError = nil;
                                   NSDictionary *json = [NSJSONSerialization
                                                         JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                         error:&jsonError];
                                   _isLoading = NO;
                                   if (jsonError) {
                                       failureBlock(error);
                                   } else {
                                       //Store the next URL
                                       _nextURL = [[json objectForKey:kPaginationKey] objectForKey:kNextURLKey];
                                       
                                       successBlock([json objectForKey:kDataKey]);
                                   }
                               }
                           }
     ];
}

- (void)fetchNextTaggedMediaWithSuccessBlock:(SuccessBlock)successBlock
                         andFailureBlock:(FailureBlock)failureBlock
{
    
    NSString *urlAsString = self.nextURL;
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    _isLoading = YES;
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSLog(@"%@", response);
                               if (error) {
                                   failureBlock(error);
                               } else {
                                   NSError *jsonError = nil;
                                   NSDictionary *json = [NSJSONSerialization
                                                         JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                         error:&jsonError];
                                   
                                   _isLoading = NO;
                                   
                                   if (jsonError) {
                                       failureBlock(error);
                                   } else {
                                       //Store the next URL
                                       _nextURL = [[json objectForKey:kPaginationKey] objectForKey:kNextURLKey];
                                       successBlock([json objectForKey:kDataKey]);
                                   }
                               }
                           }
     ];
}

@end
