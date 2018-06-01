//
//  DHVideoWnd.m
//
//  Created by Flying on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DHVideoWnd.h"
#import <QuartzCore/QuartzCore.h>

@implementation DHVideoWnd


+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    }
    return self;
}


- (id)initWithCoder:(NSCoder*)coder
{
	if((self = [super initWithCoder:coder]))
	{
		
	}
	
	return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


/*- (void)dealloc {
    [super dealloc];
}*/

@end
