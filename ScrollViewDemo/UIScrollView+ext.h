//
//  UIScrollView+ext.h
//  ScrollViewWend
//
//  Created by Michael on 3/15/14.
//  Copyright (c) 2014 Flacco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ext)
- (void)zoomToPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated;

@end