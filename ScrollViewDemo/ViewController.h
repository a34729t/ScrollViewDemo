//
//  ViewController.h
//  ScrollViewDemo
//
//  Created by Nicolas Flacco on 3/9/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController :  UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

-(void)updateViewConstraints;

@end
