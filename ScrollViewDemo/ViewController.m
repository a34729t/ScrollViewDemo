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

@property(nonatomic)CGRect  onScreenFrame;  //track frame of content that is on screen

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


// some of things work if put in VWA but not in VDL
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.scrollView.minimumZoomScale = [self.scrollView xMinScaleToFit:self.imageView];
    self.scrollView.maximumZoomScale = 2.0f;
    

    // start with entire image on screen
    self.scrollView.zoomScale=self.scrollView.minimumZoomScale;
    self.onScreenFrame=[self.scrollView xOnScreenFrame];
    
    
    NSLog(@"imageView.center: %@", NSStringFromCGPoint(self.imageView.center));
    NSLog(@"scrollView.center: %@", NSStringFromCGPoint(self.scrollView.center));
    NSLog(@"imageview.width: %.0f", self.imageView.bounds.size.width);
    NSLog(@"scrollview.width: %.0f", self.scrollView.bounds.size.width);
    
    CGPoint imageCenter = CGPointMake(self.scrollView.bounds.size.width, 0); // it's about 300
    [self.scrollView setContentOffset:imageCenter animated:YES];
    
    
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
//    [self updateOnScreenFrame];
    self.onScreenFrame=[self.scrollView xOnScreenFrame];


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
    [self.scrollView xCenterSmallView:self.imageView];
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    
    self.onScreenFrame=[self.scrollView xOnScreenFrame];
    [self.scrollView xCenterSmallView:self.imageView];
    
    [self listCoordinates];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    self.onScreenFrame=[self.scrollView xOnScreenFrame];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self.scrollView xDisplayContentInFrame:self.onScreenFrame];
    [self.scrollView xCenterSmallView:self.imageView];
}


//for debugging
-(NSString*)listCoordinates{
    CGPoint centerInScroll=[self.imageView convertPoint:self.imageView.center toView:self.scrollView];
    
    NSString *returnString= [NSString stringWithFormat:@" SV [%.0f,%.0f,%.0f,%.0f]c(%.0f,%.0f) IV [%.0f,%.0f, %.0f,%.0f] c(%.0f,%.0f) IVinSV [%.0f,%.0f,%.0f,%.0f]c(%.0f,%.0f) ZSc %.2f",
                             self.scrollView.frame.origin.x,self.scrollView.frame.origin.y,
                             self.scrollView.frame.size.width,self.scrollView.frame.size.height,
                             self.scrollView.center.x,self.scrollView.center.y,
                             
                             self.imageView.bounds.origin.x,self.imageView.bounds.origin.y,
                             self.imageView.bounds.size.width,self.imageView.bounds.size.height,
                             self.imageView.center.x, self.imageView.center.y,
                             
                             self.imageView.frame.origin.x,self.imageView.frame.origin.y,
                             self.imageView.frame.size.width,self.imageView.frame.size.height,
                             
                             centerInScroll.x,centerInScroll.y, self.scrollView.zoomScale];
    
    return returnString;
}

// create minimum zoom so that entire photo can be seen
//CGRect scrollViewFrame = self.scrollView.frame;
//CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
//CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
//CGFloat minScale = MIN(scaleWidth, scaleHeight);
//NSLog(@"minScale old %.2f, new %.2f",minScale,[self.scrollView xMinScaleToFit:self.imageView]);
//self.scrollView.minimumZoomScale = minScale;





////zoom adjustment to fit entire image on screen in new orientation
//-(void)zoomToFit{
//    CGSize scrollViewSize = self.scrollView.bounds.size;
//    CGRect contentsFrame = self.imageView.frame;
//    
//    double widthRatio=contentsFrame.size.width / scrollViewSize.width;
//    double heightRatio= contentsFrame.size.height/scrollViewSize.height;
//    NSLog(@"zoomToFit widthRatio: %.3f, heightRatio: %.3f",widthRatio,heightRatio);
//    double presentZoom=self.scrollView.zoomScale;
//    
//    //both are too small
//    if (widthRatio<1 && heightRatio<1) {
//        // width is smallest
//        if (widthRatio<heightRatio) {
//            self.scrollView.zoomScale= presentZoom * (1/widthRatio);
//            NSLog(@"zoomToFit TOO SMALL widthRatio smaller zoomScale=%.3f",self.scrollView.zoomScale);
//            
//            //height is smallest
//        }else{
//            self.scrollView.zoomScale=presentZoom *(1/heightRatio);
//            NSLog(@"zoomToFit TOO SMALL widthRatio bigger zoomScale=%.3f",self.scrollView.zoomScale);
//            
//        }
//        //both are too big
//    }else if (widthRatio>1 || heightRatio>1){
//        //width bigger
//        if (widthRatio>heightRatio ){
//            self.scrollView.zoomScale=presentZoom *(1/widthRatio);
//            NSLog(@"zoomToFit TOO BIG widthRatio bigger zoomScale=%.3f",self.scrollView.zoomScale);
//            
//            //height bigger
//        }else{
//            self.scrollView.zoomScale=presentZoom *(1/heightRatio);
//            NSLog(@"zoomToFit TOO BIG widthRatio smaller zoomScale=%.3f",self.scrollView.zoomScale);
//            
//        }
//    }
//    //    [self updateOnScreenFrame];
//    self.onScreenFrame=[self.scrollView xOnScreenFrame];
//    
//    
//}


////Under Construction- doesn't do what I want
//-(void)expandToFit{
//    CGRect scrollViewFrame = self.scrollView.frame;
//    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
//    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
//    CGFloat minScale = MIN(scaleWidth, scaleHeight);
//    
//    self.scrollView.zoomScale=minScale;
//}







////position content in center of scrollView rather than upper left, IF content is smaller than scroll
////probably not needed once zoomToFit works, but still useful
//- (void)centerScrollViewContents {
//
////    NSLog(@"preCenter:   %@",[self listCoordinates]);
//
//    CGSize scrollViewSize = self.scrollView.bounds.size;
//    CGRect contentsFrame = self.imageView.frame;
//
//    //if content width smaller than scroll width, move x origin half of difference
//    if (contentsFrame.size.width < scrollViewSize.width) {
//        contentsFrame.origin.x = (scrollViewSize.width - contentsFrame.size.width) / 2.0f;
////    }else if (contentsFrame.size.width > scrollViewSize.width){
////        contentsFrame.origin.x = (contentsFrame.size.width-scrollViewSize.width) / 2.0f;
//    }else{
//        contentsFrame.origin.x = 0.0f;
//    }
////    NSLog(@"centerScrollViewContents hContent: %.0f hScroll: %.0f",contentsFrame.size.height,scrollViewSize.height);
//    //if content height smaller than scroll height, move y origin half of difference
//    if (contentsFrame.size.height < scrollViewSize.height) {
//        contentsFrame.origin.y = (scrollViewSize.height - contentsFrame.size.height) / 2.0f;
////    }else if (contentsFrame.size.height > scrollViewSize.height){
////        contentsFrame.origin.y=(contentsFrame.size.height-scrollViewSize.height);
//    }else{
//        contentsFrame.origin.y = 0.0f;
//    }
//    self.imageView.frame=contentsFrame;
////    [self updateOnScreenFrame];
//    self.onScreenFrame=[self.scrollView xOnScreenFrame];
//
////    NSLog(@"postCenter:  %@",[self listCoordinates]);
//}
//
//
//-(CGRect)getFrameOfViewOnScreen{
//    CGRect frameOnScreen;
//    //the frame on screen in scrollView Frame of Reference
//    // x and y will have been set to the scrollView
//    double x = self.onScreenFrame.origin.x;
//    double y = self.onScreenFrame.origin.y;
//    double w =self.onScreenFrame.size.width;
//    double h =self.onScreenFrame.size.height;
//    double xC= (x +w/2)/w;
//    double yC = (y + h/2)/h;
//
//    frameOnScreen=CGRectMake(xC, yC, w, h);
//    NSLog(@"getFrameOfViewOnScreen [%.0f,%.0f,%.0f,%.0f]",xC,yC,w,h);
//    return frameOnScreen;
//}


//-(void)updateOnScreenFrame{
//    
//    //doesn't work when imageView is smaller than scrollView
//    CGRect newFrame=CGRectMake(self.scrollView.contentOffset.x,
//                               self.scrollView.contentOffset.y,
//                               self.scrollView.frame.size.width,
//                               self.scrollView.frame.size.height);
//    
//    self.onScreenFrame=newFrame;
//    NSLog(@"updateOnScreenFrame [%.0f,%.0f,%.0f,%.0f]c(%.0f,%.0f) CS[w: %.0f,h: %.0f] ZC %0.2f",
//          self.onScreenFrame.origin.x,self.onScreenFrame.origin.y,
//          self.onScreenFrame.size.width,self.onScreenFrame.size.height,
//          self.onScreenFrame.origin.x +(self.onScreenFrame.size.width/2),
//          self.onScreenFrame.origin.y +(self.onScreenFrame.size.height/2),
//          self.imageView.frame.size.width, self.imageView.frame.size.height,
//          self.scrollView.zoomScale);
//}




//[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(width)]" options:0 metrics:@{@"width":@(self.imageViewPointer.image.size.width)} views:viewsDictionary]];



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



@end
