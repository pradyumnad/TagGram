//
//  MediaCollectionViewCell.m
//  TagGram
//
//  Created by Pradyumna Doddala on 11/01/15.
//
//

#import "MediaCollectionViewCell.h"
#import "CustomCellBackground.h"

@implementation MediaCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        CustomCellBackground *backgroundView = [[CustomCellBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
    }
    return self;
}
@end
