//
//  NSDGameItemView.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDGameItemView : UIImageView

@property (nonatomic) NSUInteger type;

-(void)setHighlighted:(BOOL)highlighted;


@end
