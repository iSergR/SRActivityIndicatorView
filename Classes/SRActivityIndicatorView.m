//
//  SRActivityIndicatorView.m
//  SRActivityIndicatorView
//
//  Created by iSerg on 3/30/15.
//  Copyright (c) 2015 iSerg. All rights reserved.
//

#import "SRActivityIndicatorView.h"

@interface SRActivityIndicatorView (){
    int _numberOfCircles;
    float delay;
    float duration;
    double _animationDuration;
    CGFloat _internalSpacing;
    CGFloat _maxRadius;
    CGFloat minRadius;
    UIColor *_defaultColor;
    BOOL isAnimating;
}
@end



@implementation SRActivityIndicatorView
@synthesize delegate;

#pragma mark - Private properties

-(void)setupDefaults{
    _numberOfCircles = 5;
    
    /// The base animation delay of each circle.
    delay = 0.2;
    
    /// The base animation duration of each circle
    duration = 0.8;
    
    /// Total animation duration
    _animationDuration = 2;
    
    /// The spacing between circles.
    _internalSpacing = 5;
    
    /// The maximum radius of each circle.
    _maxRadius = 10;
    
    // The minimum radius of each circle
    minRadius = 2;
    
    /// Default color of each circle
    _defaultColor = [UIColor lightGrayColor];
    
    /// An indicator whether the activity indicator view is animating or not.
    isAnimating = false;
}



#pragma mark - Public computed properties

/// The number of circle indicators.
-(int)getNumberOfCircles{
    return _numberOfCircles;
}

-(void)setNumberOfCircles:(int)value{
    _numberOfCircles = value;
    delay = 2*duration/_numberOfCircles;
    [self updateCircles];
}


/// Default color of each circle
-(UIColor*)getDefaultColor{
    return _defaultColor;
}

-(void)setDefaultColor:(UIColor*)value{
    _defaultColor = value;
    [self updateCircles];
}

/// Total animation duration
-(double)getAnimationDuration{
    return _animationDuration;
}

-(void)setAnimationDuration:(double)value{
    _animationDuration  = value;
    duration            = _animationDuration/2;
    delay               = 2*duration/_numberOfCircles;
    [self updateCirclesanimations];
}


/// The maximum radius of each circle.
-(CGFloat)getMaxRadius{
    return _maxRadius;
}

-(void)setMaxRadius:(CGFloat)value{
    _maxRadius  = value;
    
    if (_maxRadius < minRadius){
        _maxRadius = minRadius;
    }
    [self updateCircles];
}

/// The spacing between circles.

-(CGFloat)getInternalSpacing{
    return _internalSpacing;
}

-(void)setInternalSpacing:(CGFloat)value{
    _internalSpacing  = value;
    
    if (_internalSpacing * (_numberOfCircles-1) >  CGRectGetWidth(self.frame)) {
        _internalSpacing = (CGRectGetWidth(self.frame) - _numberOfCircles * minRadius) / (_numberOfCircles-1);
    }
    [self updateCircles];
}



#pragma mark - override

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self setupDefaults];
    }
    return self;
}

- (BOOL)translatesAutoresizingMaskIntoConstraints{
    return NO;
}



#pragma mark - private methods

/// Creates the circle view.
///
/// :param: radius The radius of the circle.
/// :param: color The background color of the circle.
/// :param: positionX The x-position of the circle in the contentView.
/// :param: posX The x-position of the circle in the contentView.
/// :param: posY The y-position of the circle in the contentView.
///
/// :returns: The circle view
-(UIView*)createCircleWithRadius:(CGFloat)radius
                           color:(UIColor*)color
                            posX:(CGFloat)posX
                            posY:(CGFloat)posY{
    
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, radius*2, radius*2)];
    circle.backgroundColor = color;
    circle.layer.cornerRadius = radius;
    [circle setTranslatesAutoresizingMaskIntoConstraints:NO];
    return circle;
}


/// Creates the animation of the circle.
///
/// :param: duration The duration of the animation.
/// :param: delay The delay of the animation
///
/// :returns: The animation of the circle.

-(CABasicAnimation*)createAnimationWithDuration:(double)duration_
                                         delay:(double)delay_{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.delegate = (id)self;
    animation.fromValue             = 0;
    animation.toValue               = @1;
    animation.autoreverses          = true;
    animation.duration              = duration_;
    animation.removedOnCompletion   = false;
    animation.beginTime             = CACurrentMediaTime() + delay_;
    animation.repeatCount           = MAXFLOAT;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

/// Add the circles
-(void)addCircles{
    UIColor *color = _defaultColor;
    float radiusForCircle = (CGRectGetWidth(self.frame) - (_numberOfCircles-1)*_internalSpacing)/(2*_numberOfCircles);
    if (radiusForCircle > CGRectGetHeight(self.frame)/2) {
        radiusForCircle = CGRectGetHeight(self.frame)/2;
    }
    
    if (radiusForCircle > _maxRadius) {
        radiusForCircle = _maxRadius;
    }
    
    float widthUsed = 2*radiusForCircle * _numberOfCircles + (_numberOfCircles-1)*_internalSpacing;
    if (widthUsed > CGRectGetWidth(self.frame)) {
        widthUsed = CGRectGetWidth(self.frame);
    }
    
    float offsetX = (CGRectGetWidth(self.frame) - widthUsed)/2;
    float posY = (CGRectGetHeight(self.frame) - 2*radiusForCircle)/2;
    
    
    for (int i = 0; i < _numberOfCircles; i++) {
        if ([self.delegate respondsToSelector:@selector(activityIndicatorView:circleBackgroundColorAtIndex:)]) {
            color = [self.delegate activityIndicatorView:self circleBackgroundColorAtIndex:i];
        }
        
        float posX = offsetX + i * ((2*radiusForCircle) + _internalSpacing);
        UIView *circle = [self createCircleWithRadius:radiusForCircle color:color posX:posX posY:posY];
        circle.transform = CGAffineTransformMakeScale(0, 0);
        [self addSubview:circle];
    }
    
    [self updateCirclesanimations];
}

// Update the animation for the circles

-(void)updateCirclesanimations{
    int index = 0;
    for (UIView*subview in [self subviews]) {
        [subview.layer removeAnimationForKey:@"scale"];
        [subview.layer addAnimation:[self createAnimationWithDuration:duration delay:delay*index] forKey:@"scale"];
        index++;
    }
}

/// Remove the circles
-(void)removeCircles{
    for (UIView*subview in [self subviews]) {
        [subview removeFromSuperview];
    }
}

// Update the circles when a property is changed
-(void)updateCircles{
    [self removeCircles];
    if (isAnimating) {
        [self addCircles];
    }
}

#pragma mark - public methods


-(void)startAnimating{
    if (!isAnimating) {
        [self addCircles];
        self.hidden = false;
        isAnimating = true;
    }
}


-(void)stopAnimating{
    if (isAnimating) {
        [self removeCircles];
        self.hidden = true;
        isAnimating = false;
    }
}



@end
