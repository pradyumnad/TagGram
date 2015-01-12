//
//  Media.h
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^MediaSuccessBlock)(UIImage *image);
typedef void (^MediaFailureBlock)(NSError *err);

@interface Media : NSObject

@property (strong) NSString *caption;
//Image URLs
@property (nonatomic, strong) NSString *lowResolutionURL;
@property (nonatomic, strong) NSString *thumbNailURL;
@property (nonatomic, strong) NSString *standardResolutionURL;

//For temporary viewing
@property (nonatomic ,strong) UIImage *image;

- (id)initWithJSON:(NSDictionary *)object;

- (void)fetchImage:(NSString *)type successBlock:(MediaSuccessBlock)success
      failureBlock:(MediaFailureBlock)fail;
@end
