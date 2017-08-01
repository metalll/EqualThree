//
//  NSDGameItemView.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameItemView.h"
#import "NSDGameItemType.h"
@implementation NSDGameItemView





-(void)drawRect:(CGRect)rect{
    
    
    CALayer *layer = self.layer;
    self.contentMode= UIViewContentModeScaleToFill;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10.0;
    layer.borderWidth = 2.0;
    layer.borderColor = [[UIColor clearColor] CGColor];
    [self setBackgroundColor:[UIColor clearColor]];
    
}


- (void) setImagesForType:(NSUInteger)type{
    
   UIImage * resultImage = nil;
    UIImage * resultHighlightedImage = nil;
    switch (type) {
            
            
            
//            Croissant = 1,
//            Cupcake,
//            Danish,
//            Donut,
//            Macaroon,
//            SugarCookie

        case Croissant:
            resultImage = [UIImage imageNamed:@"Croissant"];
            resultHighlightedImage = [UIImage imageNamed:@"Croissant-H"];
            
            break;
        case Cupcake:
            resultImage = [UIImage imageNamed:@"Cupcake"];
            resultHighlightedImage = [UIImage imageNamed:@"Cupcake-H"];
            
            break;
        case Danish:
            resultImage = [UIImage imageNamed:@"Danish"];
            resultHighlightedImage = [UIImage imageNamed:@"Danish-H"];
            break;
        case Donut:
            resultImage = [UIImage imageNamed:@"Donut"];
            resultHighlightedImage = [UIImage imageNamed:@"Donut-H"];
            
            break;
        case Macaroon:
            resultImage = [UIImage imageNamed:@"Macaroon"];
            resultHighlightedImage = [UIImage imageNamed:@"Macaroon-H"];
            
            break;
    
        case SugarCookie:
            resultImage = [UIImage imageNamed:@"SugarCookie"];
            resultHighlightedImage = [UIImage imageNamed:@"SugarCookie-H"];
            
            break;
        
            
            
            
            
            
    }
    
    
    
    [self setImage:resultImage];
    [self setHighlightedImage:resultHighlightedImage];
    
    
    
    
    
}


-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
}


-(void)setType:(NSUInteger)type{
    
    if(_type!=type)
        _type = type;
    
    [self setImagesForType:_type];
}



@end



