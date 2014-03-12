//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by Nicolas Flacco on 3/9/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    // Set background to not annoy the hell out of us
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create the scroll view and the image view.
    self.scrollView  = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.imageView = [[UIImageView alloc] init];
    
    // Add an image to the image view.
    [self.imageView setImage:[UIImage imageNamed:@"matterhorn"]];

    // Add the scroll view to our view.
    [self.view addSubview:self.scrollView];
    
    // Add the image view to the scroll view.
    [self.scrollView addSubview:self.imageView];
    
    // Sizing
    [self.imageView sizeToFit]; //resize imageView to full size of image
    self.scrollView.contentSize = self.image.size;
    
    // Set the translatesAutoresizingMaskIntoConstraints to NO so that the views autoresizing mask is not translated into auto layout constraints.
    self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set the constraints for the scroll view and the image view.
    NSDictionary *viewsDictionary = @{ @"scrollView": self.scrollView, @"imageView": self.imageView };
    [self.self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics: 0 views:viewsDictionary]];
    
    // if you set zoom you must implement delegate method viewForZoomingInScrollView
    self.scrollView.bouncesZoom = NO; // Enabling this allows us to go beyond bounds (bad)
    self.scrollView.bounces = NO; // Enabling this allows us to go beyond bounds (bad)
    
    // Show horrible apple scroll indicators
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateScrollSize];
    [self updateViewPort];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // We update the scroll factor
    [self updateScrollSize];
//    [self updateViewPort]; // This centers things somewhat, but also wipes out our old zoom.
}

#pragma mark - view zooming and calculation

- (void)updateViewPort
{
    CGFloat x, y, height, width;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        x = (self.imageView.bounds.size.width/2) - (self.view.bounds.size.width/2); // center the image horizontally in scrollview
        y = 0;
        height = self.view.bounds.size.width;
        width = self.imageView.bounds.size.width;
    }
    else // Portrait mode
    {
        x = (self.imageView.bounds.size.width/2) - (self.view.bounds.size.width/2); // center the image horizontally in scrollview
        y = 0;
        height = self.view.bounds.size.height;
        width = self.imageView.bounds.size.height;
    }
    
    [self.scrollView zoomToRect:CGRectMake(x, y, height, width) animated:YES];
}

- (void)updateScrollSize
{
    // This handles the scrolled out to the max being the height of the screen
    CGFloat scrollFactor = (float)self.view.bounds.size.height / (float)self.imageView.bounds.size.height;
    self.scrollView.maximumZoomScale = scrollFactor * 3;
    self.scrollView.minimumZoomScale = scrollFactor;
}

#pragma mark - stuff that doesn't matter

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
