//
//  DetailViewController.m
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import "DetailViewController.h"
#import "Media.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView.image = _media.image;
    _captionLabel.text = _media.caption;
    [_captionLabel setNumberOfLines:0];
    [_captionLabel sizeToFit];
    
    [_media fetchImage:@"standard_resolution" successBlock:^(UIImage *image) {
        _imageView.image = image;
        NSLog(@"Big loaded..");
    } failureBlock:^(NSError *err) {
        NSLog(@"%@",  err);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
