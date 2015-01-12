//
//  Media.m
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

/**
 {
 attribution: null,
 tags: [
 "capture",
 "vscocam"
 ],
 location: {
 latitude: 53.51519539,
 longitude: -113.267585592
 },
 comments: {
 count: 0,
 data: [ ]
 },
 filter: "Normal",
 created_time: "1421010035",
 link: "http://instagram.com/p/xulyVZjNp5/",
 likes: {
 count: 2,
 data: [
 {
 username: "nicolearmour",
 profile_picture: "https://instagramimages-a.akamaihd.net/profiles/profile_36816663_75sq_1363773245.jpg",
 id: "36816663",
 full_name: "nicole armour |"
 },
 {
 username: "redmoustache",
 profile_picture: "https://igcdn-photos-f-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-19/10914127_1567564296790037_1148407700_a.jpg",
 id: "273638319",
 full_name: "Dávid Tóth"
 }
 ]
 },
 images: {
 low_resolution: {
 url: "http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/10932343_744010169010849_560502193_a.jpg",
 width: 306,
 height: 306
 },
 thumbnail: {
 url: "http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/10932343_744010169010849_560502193_s.jpg",
 width: 150,
 height: 150
 },
 standard_resolution: {
 url: "http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/10932343_744010169010849_560502193_n.jpg",
 width: 640,
 height: 640
 }
 },
 users_in_photo: [ ],
 caption: {
 created_time: "1421010035",
 text: "Frosty 🌲 • #tree #snow #contrast #nature #capture #perspective #vsco #vscocam #vscogram #canon #canoneos #l4l #f4f",
 from: {
 username: "mik_b_vander",
 profile_picture: "https://igcdn-photos-h-a.akamaihd.net/hphotos-ak-xfp1/t51.2885-19/10632123_682592235162295_301091659_a.jpg",
 id: "206870821",
 full_name: "m i k a y l a"
 },
 id: "895819563110554449"
 },
 type: "image",
 id: "895819562565294713_206870821",
 user: {
 username: "mik_b_vander",
 website: "",
 profile_picture: "https://igcdn-photos-h-a.akamaihd.net/hphotos-ak-xfp1/t51.2885-19/10632123_682592235162295_301091659_a.jpg",
 full_name: "m i k a y l a",
 bio: "",
 id: "206870821"
 }
 }
 */
#import "Media.h"

NSString *const kImagesKey = @"images";
NSString *const kCaption = @"caption";
NSString *const kLowResolutionKey = @"low_resolution";
NSString *const kThumbnailKey = @"thumbnail";
NSString *const kStandardResolutionKey = @"standard_resolution";

@implementation Media

- (id)initWithJSON:(NSDictionary *)object {
    if (self == [super init]) {
        
        _caption = [object objectForKey:kCaption] == [NSNull null] ?
        @"" : [[object objectForKey:kCaption] objectForKey:@"text"];
        NSDictionary *images = [object objectForKey:kImagesKey];
        _lowResolutionURL = [[images objectForKey:kLowResolutionKey] objectForKey:@"url"];
        _thumbNailURL = [[images objectForKey:kThumbnailKey] objectForKey:@"url"];
        _standardResolutionURL = [[images objectForKey:kStandardResolutionKey] objectForKey:@"url"];
        return self;
    }
    return nil;
}

- (void)fetchImage:(NSString *)type successBlock:(MediaSuccessBlock)success
      failureBlock:(MediaFailureBlock)fail {

    NSString *url = @"";
    if ([type isEqualToString:kThumbnailKey]) {
        url = _thumbNailURL;
    } else if ([type isEqualToString:kStandardResolutionKey]) {
        url = _standardResolutionURL;
    } else {
        url = _lowResolutionURL;
    }
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    myQueue.name = @"Image Download Queue";
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest queue:myQueue
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError == nil) {
             dispatch_async(dispatch_get_main_queue(),^ {
                 UIImage *image = [[UIImage alloc] initWithData:data];
                 success(image);
             });
         } else {
             fail(connectionError);
         }
     }];
}

@end
