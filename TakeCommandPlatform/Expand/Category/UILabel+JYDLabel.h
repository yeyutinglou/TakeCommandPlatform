
#import <UIKit/UIKit.h>

@interface UILabel (JYDLabel)

/**
 *  计算宽度
 */
-(CGSize)sizeWidth;
-(CGSize)sizeWidthFont:(UIFont *)font;

/**
 *  计算高度
 */
-(CGSize)sizeHeight;
-(CGSize)sizeHeightFont:(UIFont *)font;

/**
 *  计算最后一个字符的位置
 */
-(void)lastCharacter;
-(void)lastCharacter:(UIFont *)font;


@end
