//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by Nicolas Flacco on 3/9/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create subviews
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.frame];
    self.image = [UIImage imageNamed:@"matterhorn"];
    self.imageView = [[UIImageView alloc] init];
    
    // Creat a UIImageVieew
    [self.imageView setImage:self.image];
    [self.imageView sizeToFit]; //resize imageView to full size of image
    
    // Config
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate=self;
    // if you set zoom you must implement delegate method viewForZoomingInScrollView
    self.scrollView.maximumZoomScale = (self.scrollView.frame.size.height / self.imageView.frame.size.height) * 4;
    self.scrollView.minimumZoomScale = self.scrollView.frame.size.height / self.imageView.frame.size.height;
    self.scrollView.bouncesZoom = NO; // Enabling this allows us to go beyond bounds (bad)
    self.scrollView.bounces = NO; // Enabling this allows us to go beyond bounds (bad)
    
    // Show horrible apple scroll indicators
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    

    self.scrollView.contentSize=self.image ? self.image.size: CGSizeZero;   //in case no image      //resize contentSize to imageSize
    NSLog(@"scrollView contentSize= %.0f x %.0f",self.scrollView.contentSize.height,self.scrollView.contentSize.width);
    //  fit whole picture on screen
    
    CGFloat imageViewHeight = self.imageView.bounds.size.height;
    CGFloat imageViewWidth = self.imageView.bounds.size.width;
    NSLog(@"imageView bounds:CGRect(%.0f, %.0f, %.0f x %.0f)", self.imageView.bounds.origin.x, self.imageView.bounds.origin.y, imageViewHeight, imageViewWidth);
    

    CGFloat x, y, height, width;
    
    if (YES)
    {
        x = (self.imageView.bounds.size.width/2) - (self.view.bounds.size.width/2); // center the image horizontally in scrollview
        y = 0;
        height = self.view.bounds.size.height;
        width = self.imageView.bounds.size.height;
    }
    else
    {
        // In theory, I would use this for auto-layout
    }
    [self.scrollView zoomToRect:CGRectMake(x, y, height, width) animated:YES];
    
    // And add the ScrollView to our view
    [self.view addSubview:self.scrollView];
}

-(void)updateViewConstraints {
        NSLog(@"updateViewConstraints");
    [super updateViewConstraints];
    if (self.view.bounds.size.height < self.view.bounds.size.width) {
//        self.heightCon.constant = self.view.bounds.size.height;
    }else{
//        self.heightCon.constant = 350;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate methods

//lazy instantiation
-(UIImageView*)imageView{
//    NSLog(@"imageView");
    if (!_imageView) _imageView = [[UIImageView alloc]init];
    return _imageView;
}

-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView=scrollView;
    //just in case image is nil
    self.scrollView.contentSize=self.image ? self.image.size : CGSizeZero;
}

// returns the view that is going to get zoomed
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
