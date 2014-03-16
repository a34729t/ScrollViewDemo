//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by Nicolas Flacco on 3/9/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ext.h"

@interface ViewController()
// for recentering with zoom or orientation change- not really working yet
@property(nonatomic)CGPoint centerPoint;
@property(nonatomic) double zoomScale;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.scrollView created in IB, with constraints tying it to 4 sides of superview
    // scrollView.delegate also set in IB
    UIImage *image = [UIImage imageNamed:@"matterhorn.png"];
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.imageView sizeToFit];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = image.size;
    
    // to zoom in. double works in simulator
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // create minimum zoom so that entire photo can be seen
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 2.0f;
    
    // start with entire image on screen
    self.scrollView.zoomScale = minScale;
//    [self centerScrollViewContents];     //delegate will call [self centerScrollViewContents]
//    self.scrollView.zoomScale=self.scrollView.zoomScale*2;
    NSLog(@"post VWA:    %@",[self listCoordinates]);
}

//position content in center of scrollView rather than upper left, IF content is smaller than scroll
- (void)centerScrollViewContents {
    
    NSLog(@"preCenter:   %@",[self listCoordinates]);
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    //if content width smaller than scroll width, move x origin half of difference
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    //if content height smaller than scroll height, move y origin half of difference
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
    
    NSLog(@"postCenter:  %@",[self listCoordinates]);
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // point tapped in imageView's coordinates
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    //zoom but not past max
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // adjust bounds to compensate for zoom, create new frame
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    
    NSLog(@"doubleTap:  %@",[self listCoordinates]);
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self centerScrollViewContents];
    //below line doesn't work if zoomScale!=1
//    [self.scrollView zoomToPoint:self.centerPoint withScale:self.scrollView.zoomScale animated:YES];
    
}


//Under Construction- to fix max rather than min to scrollView
-(void)expandToFit{
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MAX(scaleWidth, scaleHeight);
    
    self.scrollView.zoomScale=minScale;
}



//- (void)viewDidLoad{
//    [super viewDidLoad];
//    
//    // Set background to not annoy the hell out of us
//    self.view.backgroundColor = [UIColor blackColor];
//    
//    // Create the scroll view and the image view.
//    self.scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    // Add the scroll view to our view.
//    [self.view addSubview:self.scrollView];
//    self.scrollView.delegate = self;
//    self.imageView = [[UIImageView alloc] init];
//    
//    // Add an image to the image view.
//    [self.imageView setImage:[UIImage imageNamed:@"matterhorn"]];
//
//   
//    
//    // Add the image view to the scroll view.
//    [self.scrollView addSubview:self.imageView];
//    
//    // Sizing   //Don't need to set contentSize if using pure autolayout??
//    [self.imageView sizeToFit]; //resize imageView to full size of image
//    self.scrollView.contentSize = self.image.size;
//    
//    // Set the translatesAutoresizingMaskIntoConstraints to NO so that the views autoresizing mask is not translated into auto layout constraints.
//    self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
//    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    // Set the constraints for the scroll view and the image view.
//    NSDictionary *viewsDictionary = @{ @"scrollView": self.scrollView, @"imageView": self.imageView };
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
//    
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics: 0 views:viewsDictionary]];
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics: 0 views:viewsDictionary]];
//    
////    [self.scrollView addConstraints:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
////    
////    [self.scrollView addConstraints:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
////   
//    
//    // if you set zoom you must implement delegate method viewForZoomingInScrollView
//    self.scrollView.bouncesZoom = NO; // Enabling this allows us to go beyond bounds (bad)
//    self.scrollView.bounces = NO; // Enabling this allows us to go beyond bounds (bad)
//    
//    // Show horrible apple scroll indicators
//    self.scrollView.showsHorizontalScrollIndicator = YES;
//    self.scrollView.showsVerticalScrollIndicator = YES;
//    
//    self.scrollView.maximumZoomScale = 3;
//    self.scrollView.minimumZoomScale = .1;
//    
//    NSLog(@"VDL preCenter:   %@",[self listCoordinates]);
//    
//    
//    
////    self.imageView.center=self.scrollView.center;
////    NSLog(@"VDL postCenter:  %@",[self listCoordinates]);
////
////    self.scrollView.contentOffset=CGPointMake(-1920, -1200);
////    NSLog(@"VDL postOffset:  %@",[self listCoordinates]);
////
////    
////    [self.scrollView zoomToRect:self.imageView.bounds animated:YES];
//    
////    CGFloat x=(self.imageView.bounds.size.width/2)-(self.scrollView.bounds.size.width/2);
////    CGFloat y=(self.imageView.bounds.size.height /2)-(self.scrollView.bounds.size.height/2);
////    [self.scrollView zoomToRect:CGRectInset(self.imageView.frame, x, y) animated:YES];
//    
////    [self.scrollView zoomToRect:[self rectToDisplay] animated:YES];
//    NSLog(@"VDL postZoomCtr: %@",[self listCoordinates]);
////
////    self.scrollView.zoomScale=.5;
////    NSLog(@"VDL postScale.5: %@",[self listCoordinates]);
//}
//
//
//
//CGFloat centerX = 0;
//CGFloat centerY = 0;
//
////- (void)viewDidAppear:(BOOL)animated
////{
////    [self updateScrollSize];
////    [self updateViewPort];
////}
//
//
//
//-(CGRect)rectToDisplay{
//    
//    CGFloat x=(self.imageView.bounds.size.width/2)-(self.scrollView.bounds.size.width/2);
//    CGFloat y=(self.imageView.bounds.size.height /2)-(self.scrollView.bounds.size.height/2);
//    CGFloat w=self.scrollView.bounds.size.width;
//    CGFloat h=self.scrollView.bounds.size.height;
//    
//    CGRect returnRect=CGRectMake(x, y, w, h);
//    
//    return returnRect;
//    
//}
//
////-(void)scrollViewDidScroll:(UIScrollView *)scrollView{   
////    
////}
//
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    self.centerPoint=self.imageView.center;
//    NSLog(@"svdES Content offset [%.0f,%.0f] IVCenter [%.0f,%.0f]",scrollView.contentOffset.x,scrollView.contentOffset.y,self.centerPoint.x,self.centerPoint.y);
//}
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    self.centerPoint=self.imageView.center;
//    NSLog(@"svdED Content offset [%.0f,%.0f] IVCenter [%.0f,%.0f]",scrollView.contentOffset.x,scrollView.contentOffset.y,self.centerPoint.x,self.centerPoint.y);
//}
//
//
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    NSLog(@"svdED Content offset [%.0f,%.0f] IVCenter [%.0f,%.0f]",scrollView.contentOffset.x,scrollView.contentOffset.y,self.centerPoint.x,self.centerPoint.y);
//    NSLog(@"VDL postZoomCtr: %@",[self listCoordinates]);
//}
//
//-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    self.zoomScale=scale;
//    NSLog(@"zoomScale=%.2f",self.zoomScale);
//    
//}
//
//
//-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    // We update the scroll factor
////    [self updateScrollSize];
////    [self.scrollView setCenter:CGPointMake(CGFloat x, <#CGFloat y#>)] // Attempt 2: We could just update the center of the image and adjust zoom?
////    [self updateViewPort]; // Attempt 1: This centers things somewhat, but also wipes out our old zoom.
//    
//    // Trigger a new centering (center will change the content offset)
//    
//    
////    self.scrollView.contentInset = UIEdgeInsetsZero;
//    
////    [self.scrollView zoomToRect:self.imageView.bounds animated:YES];
////    [self centerViewInScrollView];
//    
//    NSLog(@"willAnimateRot:  %@",[self listCoordinates]);
//}
//
//
//
//
//
//-(void)centerViewInScrollView{
//
//    CGFloat newContentOffsetX = (self.scrollView.contentSize.width - self.scrollView.frame.size.width) / 2;
//    CGFloat newContentOffsetY = (self.scrollView.contentSize.height - self.scrollView.frame.size.height) / 2;
//    
//    self.scrollView.contentOffset = CGPointMake(newContentOffsetX, newContentOffsetY);
//
//}
//
//
//
//
//
//
//#pragma mark - view zooming and calculation
//
//- (void)updateViewPort
//{
//    CGFloat x, y, height, width;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
//    {
//        x = (self.imageView.bounds.size.width/2) - (self.view.bounds.size.width/2); // center the image horizontally in scrollview
//        y = 0;
//        height = self.view.bounds.size.width;
//        width = self.imageView.bounds.size.width;
//    }
//    else // Portrait mode
//    {
//        x = (self.imageView.bounds.size.width/2) - (self.view.bounds.size.width/2); // center the image horizontally in scrollview
//        y = 0;
//        height = self.view.bounds.size.height;
//        width = self.imageView.bounds.size.height;
//    }
//    
//    [self.scrollView zoomToRect:CGRectMake(x, y, height, width) animated:YES];
//}
//
//- (void)updateScrollSize
//{
//    // This handles the scrolled out to the max being the height of the screen
//    CGFloat scrollFactor = (float)self.view.bounds.size.height / (float)self.imageView.bounds.size.height;
//    self.scrollView.maximumZoomScale = scrollFactor * 3;
//    self.scrollView.minimumZoomScale = scrollFactor;
//}
//
//#pragma mark - stuff that doesn't matter
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - UIScrollViewDelegate methods
//
////lazy instantiation
//-(UIImageView*)imageView{
////    NSLog(@"imageView");
//    if (!_imageView) _imageView = [[UIImageView alloc]init];
//    return _imageView;
//}
//
//-(void)setScrollView:(UIScrollView *)scrollView{
//    _scrollView=scrollView;
//    //just in case image is nil
////    self.scrollView.contentSize=self.image ? self.image.size : CGSizeZero;
//}
//
//// returns the view that is going to get zoomed
//-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.imageView;
//}

-(NSString*)listCoordinates{
CGPoint centerInScroll=[self.imageView convertPoint:self.imageView.center toView:self.scrollView];
CGPoint originInScroll=[self.imageView convertPoint:self.imageView.bounds.origin toView:self.scrollView];
    
NSString *returnString= [NSString stringWithFormat:@" SV [(%.0f,%.0f) (%.0f,%.0f) %.0f,%.0f] IV [(%.0f,%.0f) (%.0f,%.0f) %.0f,%.0f] IVCenterInSV [(%.0f,%.0f),(%.0f,%.0f)]",
            self.scrollView.frame.origin.x,self.scrollView.frame.origin.y,
            self.scrollView.center.x,self.scrollView.center.y,
            self.scrollView.frame.size.width,self.scrollView.frame.size.height,
                         
            self.imageView.bounds.origin.x,self.imageView.bounds.origin.y,
            self.imageView.center.x, self.imageView.center.y,
            self.imageView.bounds.size.width,self.imageView.bounds.size.height,
                         
            originInScroll.x,originInScroll.y,
            centerInScroll.x,centerInScroll.y];
    
    return returnString;
}

@end
