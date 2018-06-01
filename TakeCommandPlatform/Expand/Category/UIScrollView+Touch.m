//
//  UIScrollView+Touch.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/8.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "UIScrollView+Touch.h"

@implementation UIScrollView (Touch)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //if(!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    
    [super touchesBegan:touches withEvent:event];
}


//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //if(!self.dragging)
//    {
//        [[self nextResponder] touchesMoved:touches withEvent:event];
//    }
//    [super touchesMoved:touches withEvent:event];
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //if(!self.dragging)
//    {
//        [[self nextResponder] touchesEnded:touches withEvent:event];
//    }
//    [super touchesEnded:touches withEvent:event];


@end
