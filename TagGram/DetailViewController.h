//
//  DetailViewController.h
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import <UIKit/UIKit.h>

@class Media;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Media *media;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;

@end
