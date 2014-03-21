//
//  UIScrollView+ext.h
//  ScrollViewWend
//
//  Created by Michael on 3/15/14.
//  Copyright (c) 2014 Flacco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ext)

-(CGFloat)xMinScaleToFit:(UIView*)viewToFit;

-(CGRect)xOnScreenFrame;        //returns the frame of content currently on Screen in SV

-(void)xDisplayContentInFrame:(CGRect)contentFrame; //centers the frame of content in SV

-(void)xZoomViewToFill:(UIView*)contentView;

//- (CGRect)xCenterSmallView:(UIView*)cView;
- (void)xCenterSmallView:(UIView*)cView;


//- (void)zoomToPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated;

@end
