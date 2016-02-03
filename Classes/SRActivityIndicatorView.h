//
//  SRActivityIndicatorView.h
//  SRActivityIndicatorView
//
//  Created by iSerg on 3/30/15.
//  Copyright (c) 2015 iSerg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRActivityIndicatorViewDelegate;

@interface SRActivityIndicatorView : UIView
@property(assign) __unsafe_unretained id <SRActivityIndicatorViewDelegate> delegate;

-(int)getNumberOfCircles;

-(void)setNumberOfCircles:(int)value;

/// Default color of each circle
-(UIColor*)getDefaultColor;
-(void)setDefaultColor:(UIColor*)value;
/// Total animation duration
-(double)getAnimationDuration;

-(void)setAnimationDuration:(double)value;
/// The maximum radius of each circle.
-(CGFloat)getMaxRadius;

-(void)setMaxRadius:(CGFloat)value;
-(CGFloat)getInternalSpacing;
-(void)setInternalSpacing:(CGFloat)value;



-(void)startAnimating;
-(void)stopAnimating;
@end




































@protocol SRActivityIndicatorViewDelegate <NSObject>
-(UIColor*)activityIndicatorView:(SRActivityIndicatorView*)activityIndicatorView circleBackgroundColorAtIndex:(int)index;

@end