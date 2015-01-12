//
//  ViewController.h
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

