//
//  UIImage+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JYD)


+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  图片由颜色值生成
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return image 一张新的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;



/**
 *  @brief 图片原比例缩放处理
 *
 *  @param image <#image description#>
 *  @param scale <#scale description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)thumbWithImage:(UIImage *)image
                          scale:(CGFloat)scale;


///得到视频的缩略图
+(UIImage *)videoThumbImage:(NSURL *)videoURL;

/**
 *  @brief KMargin参数很重要，不能乱调
 *
 *  @param void <#void description#>
 *
 *  @return <#return value description#>
 */
#define KMargin 5
#define KCornRadius 7
#define KTriangleWidth 10
#define KTriangleSpace 15
/**
 *  @brief 绘制聊天气泡：可绘制图片
 *
 *  @param image    <#image description#>
 *  @param rect     <#rect description#>
 *  @param isSender <#isSender description#>
 */
+ (void)drawImage:(UIImage *)image rect:(CGRect)rect isSender:(BOOL)isSender;


///添加水印
+ (UIImage *)addImage:(UIImage *)image addMsakImage:(UIImage *)maskImage maskRect:(CGRect)rect;



/**
 截图

 @param view view
 @return 图片
 */
+ (UIImage *)captureWithView:(UIView *)view;


//可定制截图区域
+ (UIImage *)getImageWithSize:(CGRect)myImageRect FromImage:(UIImage *)bigImage;

@end
