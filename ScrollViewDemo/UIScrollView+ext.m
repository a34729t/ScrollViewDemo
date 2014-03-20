//
//  UIScrollView+ext.m
//  ScrollViewWend
//
//  Created by Michael on 3/15/14.
//  Copyright (c) 2014 Flacco. All rights reserved.
//

#import "UIScrollView+ext.h"

@implementation UIScrollView (ext)


// returns the frame of ContentView currently on screen, in scrollView frame of reference
-(CGRect)xGetOnScreenFrame{
    //doesn't work when imageView is smaller than scrollView
    CGRect newFrame=CGRectMake(self.contentOffset.x,
                               self.contentOffset.y,
                               self.frame.size.width,
                               self.frame.size.height);
    
    NSLog(@"updateOnScreenFrame [%.0f,%.0f,%.0f,%.0f]c(%.0f,%.0f)",newFrame.origin.x,newFrame.origin.y,
          newFrame.size.width,newFrame.size.height,
          newFrame.origin.x +(newFrame.size.width/2),
          newFrame.origin.y +(newFrame.size.height/2));
        return newFrame;
}

// displays the segment of contentView at current zoomScale, with previous center pointcentered in scrollView
-(void)xDisplayContentInFrame:(CGRect)contentFrame{
    
    float xOffsetDiff= (contentFrame.size.width-self.frame.size.width)/2;
    float yOffsetDiff= (contentFrame.size.height-self.frame.size.height)/2;
    
    float newOffsetX =  contentFrame.origin.x + xOffsetDiff;
    float newOffsetY =  contentFrame.origin.y + yOffsetDiff;
    
    
    
    // for debugging purposes only
    float oldCenterX=contentFrame.origin.x + contentFrame.size.width/2;
    float oldCenterY=contentFrame.origin.y + contentFrame.size.height/2;
    
    float newCenterX =  newOffsetX+self.frame.size.width/2;
    float newCenterY =  newOffsetY+self.frame.size.height/2;
    
    CGRect newFrame=CGRectMake(newOffsetX,newOffsetY,self.frame.size.width,self.frame.size.height);
    
    NSLog(@"xDC oldO[%.0f,%.0f] oldC[%.0f,%.0f] offset[%.0f,%.0f] newO[%.0f,%.0f] newC[%.0f,%.0f]",
                contentFrame.origin.x,contentFrame.origin.y,
                oldCenterX,oldCenterY,
                xOffsetDiff,yOffsetDiff,
                newOffsetX,newOffsetY,
                newCenterX,newCenterY);
    
    [self scrollRectToVisible:newFrame animated:YES];
    if (newFrame.size.width<self.frame.size.width && newFrame.size.height<self.frame.size.height) {
        //zoomToFill
    }

}





-(void)xZoomViewToFill:(UIView*)contentView{
    
    CGSize scrollViewSize = self.bounds.size;
    
    double widthRatio=contentView.frame.size.width / scrollViewSize.width;
    double heightRatio= contentView.frame.size.height/scrollViewSize.height;
    
    NSLog(@"zoomToFit widthRatio: %.3f, heightRatio: %.3f",widthRatio,heightRatio);
    double presentZoom=self.zoomScale;
    
    //both are too small
    if (widthRatio<1 && heightRatio<1) {
        // width is smallest
        if (widthRatio<heightRatio) {
            self.zoomScale= presentZoom * (1/widthRatio);
            NSLog(@"zoomToFit TOO SMALL widthRatio smaller zoomScale=%.3f",self.zoomScale);
            
            //height is smallest
        }else{
            self.zoomScale=presentZoom *(1/heightRatio);
            NSLog(@"zoomToFit TOO SMALL widthRatio bigger zoomScale=%.3f",self.zoomScale);
            
        }
        //both are too big
    }else if (widthRatio>1 || heightRatio>1){
        //width bigger
        if (widthRatio>heightRatio ){
            self.zoomScale=presentZoom *(1/widthRatio);
            NSLog(@"zoomToFit TOO BIG widthRatio bigger zoomScale=%.3f",self.zoomScale);
            
            //height bigger
        }else{
            self.zoomScale=presentZoom *(1/heightRatio);
            NSLog(@"zoomToFit TOO BIG widthRatio smaller zoomScale=%.3f",self.zoomScale);
            
        }
    }
}



-(void)zoomToPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated
{
    //Normalize current content size back to content scale of 1.0f
    CGSize contentSize;
    contentSize.width = (self.contentSize.width / self.zoomScale);
    contentSize.height = (self.contentSize.height / self.zoomScale);
    
    //translate the zoom point to relative to the content rect
    zoomPoint.x = (zoomPoint.x / self.bounds.size.width) * contentSize.width;
    zoomPoint.y = (zoomPoint.y / self.bounds.size.height) * contentSize.height;
    
    //derive the size of the region to zoom to
    CGSize zoomSize;
    zoomSize.width = self.bounds.size.width / scale;
    zoomSize.height = self.bounds.size.height / scale;
    
    //offset the zoom rect so the actual zoom point is in the middle of the rectangle
    CGRect zoomRect;
    zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0f;
    zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0f;
    zoomRect.size.width = zoomSize.width;
    zoomRect.size.height = zoomSize.height;
    
    //apply the resize
    [self zoomToRect: zoomRect animated: animated];
}



@end
