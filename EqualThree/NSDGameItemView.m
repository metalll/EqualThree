//
//  NSDGameItemView.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameItemView.h"
#import "NSDGameItemType.h"

@interface NSDGameItemView (){
    CAEmitterLayer *_emitter;
}

- (void)startAnimateDestroy;
- (void)endAnimateDestroy;
- (void)configureEmitter;

- (void)setIsEmitting:(BOOL)isEmitting;
- (void)setImagesForType:(NSUInteger)type;

@end

@implementation NSDGameItemView

#pragma mark - Life Cycle

- (void)drawRect:(CGRect)rect{
    CALayer *layer = self.layer;
    self.contentMode= UIViewContentModeScaleToFill;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10.0;
    layer.borderWidth = 2.0;
    
    layer.borderColor = [[UIColor clearColor] CGColor];
    [self setBackgroundColor:[UIColor clearColor]];
}

+ (Class)layerClass{
    
    return [CAEmitterLayer class];
}

#pragma mark - Public

- (void)animateDestroyWithDuration:(float)duration
                        completion:(void (^)(void))completion{
    
    _emitter.emitterPosition = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    _emitter.emitterSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
    
    [self startAnimateDestroy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endAnimateDestroy];
        if(completion){
            completion();
        }
    });
    
}

#pragma mark - Private


- (void)startAnimateDestroy{
    [self setIsEmitting:YES];
    
}

- (void)endAnimateDestroy{
    [self setIsEmitting:NO];
    
}


- (void)configureEmitter{
    
    [self setClipsToBounds:NO];
    
    _emitter = (CAEmitterLayer*)self.layer;
    _emitter.emitterPosition = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    _emitter.emitterSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
    
    CAEmitterCell* particles = [CAEmitterCell emitterCell];
    particles.birthRate = 0;
    particles.lifetime = 0.15f;
    
    particles.contents = (id)[self.image CGImage];
    [particles setName:@"particles"];
    particles.zAcceleration = 20.0f;
    particles.velocity = 196;
    
    particles.emissionRange = M_PI;
    
    particles.magnificationFilter = kCAFilterTrilinear;
    particles.minificationFilter = kCAFilterLinear;
    
    particles.scale = -0.15;
    
    particles.scaleSpeed = 2.0f;
    particles.spin = 1;
    particles.spinRange = 20;
    _emitter.emitterCells = [NSArray arrayWithObject:particles];
    
}

#pragma mark - Private Setter

- (void)setIsEmitting:(BOOL)isEmitting{
    
    [_emitter setValue:[NSNumber numberWithInt:isEmitting?6000:0] forKeyPath:@"emitterCells.particles.birthRate"];
}


- (void)setImagesForType:(NSUInteger)type{
    
    UIImage *resultImage = nil;
    UIImage *resultHighlightedImage = nil;
    
    switch (type) {
            
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
    
    [self configureEmitter];
}


#pragma mark - Public Setter

- (void)setType:(NSUInteger)type{
    
    if(_type!=type)
        _type = type;
    
    [self setImagesForType:_type];
}

@end
