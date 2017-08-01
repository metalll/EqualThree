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
    layer.borderColor = [[UIColor whiteColor] CGColor];
    
}


- (UIImage *) imageForType:(NSUInteger)type{
    
   UIImage * resultImage = nil;
    
    switch (type) {
            
            
            
//            Croissant = 1,
//            Cupcake,
//            Danish,
//            Donut,
//            Macaroon,
//            SugarCookie

        case Croissant:
            resultImage = [UIImage imageNamed:@"Croissant"];
            break;
        case Cupcake:
            resultImage = [UIImage imageNamed:@"Cupcake"];
            break;
        case Danish:
            resultImage = [UIImage imageNamed:@"Danish"];
            break;
        case Donut:
            resultImage = [UIImage imageNamed:@"Donut"];
            break;
        case Macaroon:
            resultImage = [UIImage imageNamed:@"Macaroon"];
            break;
    
        case SugarCookie:
            resultImage = [UIImage imageNamed:@"SugarCookie"];
            break;
        
            
            
            
            
            
    }
    
    
    
    
    
    
    
    
    return resultImage;
    
}



-(void)setType:(NSUInteger)type{
    
    if(_type!=type)
        _type = type;
    
    
    [self setImage:[self imageForType:_type]];
    
}



@end



