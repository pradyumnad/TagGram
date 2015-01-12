//
//  InstagramService.h
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id results);
typedef void (^FailureBlock)(NSError *err);

@interface InstagramService : NSObject

@property (readonly) NSString *nextURL;

@property (assign) BOOL isLoading;

+ (id)sharedService;

- (void)fetchTaggedMediaWithSuccessBlock:(SuccessBlock)successBlock
                         andFailureBlock:(FailureBlock)failureBlock;
- (void)fetchNextTaggedMediaWithSuccessBlock:(SuccessBlock)successBlock
                             andFailureBlock:(FailureBlock)failureBlock;
@end