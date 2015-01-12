//
//  ViewController.m
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import "ViewController.h"
#import "InstagramService.h"
#import "Media.h"
#import "MediaCollectionViewCell.h"
#import "DetailViewController.h"

NSString *kCellID = @"kMediaCollectionViewCellId";// UICollectionViewCell storyboard id

@interface ViewController ()

@property (strong) NSMutableArray *mediaItems;
@end

@implementation ViewController

//https://github.com/lukescott/DraggableCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mediaItems = [[NSMutableArray alloc] init];
    
    InstagramService *service = [InstagramService sharedService];
    [service fetchTaggedMediaWithSuccessBlock:^(id results) {
        [self addMediaItemsAndReLoadCollectionView:results];
    } andFailureBlock:^(NSError *err) {
        NSLog(@"%@",  err);
        [self showErrorAlert:err];
    }];
}

- (void)showErrorAlert:(NSError *)err {
    dispatch_async(dispatch_get_main_queue(), ^ {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[[err userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    });
}

- (void)addMediaItemsAndReLoadCollectionView:(NSArray *)results {
    for (NSDictionary *item in results) {
        Media *media = [[Media alloc] initWithJSON:item];
        [_mediaItems addObject:media];
    }
    
    dispatch_async(dispatch_get_main_queue(),
                   ^ {
                       [self.collectionView reloadData];
                   });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.mediaItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    MediaCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    Media *media = [self.mediaItems objectAtIndex:indexPath.row];
    cell.label.text = media.caption;
    
    cell.image.image = [UIImage imageNamed:@"camera.png"];
    
    if (media.image) {
        cell.image.image = media.image;
    } else {
        [media fetchImage:@"thumbnail" successBlock:^(UIImage *image) {
            media.image = image;
            [cv reloadItemsAtIndexPaths:@[indexPath]];
        } failureBlock:^(NSError *err) {
            NSLog(@"%@", err);
        }];
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
        NSLog(@"Footer visible");
        [self fetchNewMedia];
    }
    
    return reusableview;
}

- (void)fetchNewMedia {
    InstagramService *service = [InstagramService sharedService];
    if (!service.isLoading) {
        [service fetchNextTaggedMediaWithSuccessBlock:^(id results) {
            [self addMediaItemsAndReLoadCollectionView:results];
        } andFailureBlock:^(NSError *err) {
            NSLog(@"%@",  err);
            [self showErrorAlert:err];
        }];
    }
}


// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        Media *media = [self.mediaItems objectAtIndex:selectedIndexPath.row];
        
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.media = media;
    }
}

@end
