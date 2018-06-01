
#import "UILabel+JYDLabel.h"

@implementation UILabel (JYDLabel)

-(CGSize)sizeWidth{
    return [self sizeWidthFont:self.font];
}
-(CGSize)sizeWidthFont:(UIFont *)font{
    
    CGSize size;
 
    NSDictionary *attribute = @{NSFontAttributeName:font};
    size = [self.text boundingRectWithSize:CGSizeMake(0, self.frame.size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

-(CGSize)sizeHeight{
    return [self sizeHeightFont:self.font];
}
-(CGSize)sizeHeightFont:(UIFont *)font{
    CGSize size;
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    size = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return size;
}

-(void)lastCharacter{

}
-(void)lastCharacter:(UIFont *)font{

}



@end
