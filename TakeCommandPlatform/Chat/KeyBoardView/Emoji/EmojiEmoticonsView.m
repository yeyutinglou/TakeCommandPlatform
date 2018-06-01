//
//  EmojiEmoticonsView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/7.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "EmojiEmoticonsView.h"
#import "Emoji.h"


#define  KMargin 4

//emoij表情排布
#define  KColumNum 7
#define  KRowNum 3



//其他表情排布
#define  KOtherColumNum 5
#define  KOtherRowNum 2


@interface EmojiEmoticonsView () <UIScrollViewDelegate, EmojiEmoticonsViewDelegate>

/** emoji数组 */
@property (nonatomic, strong) NSMutableArray *allEmojis;

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation EmojiEmoticonsView

+ (instancetype)emojiEmoticonsView:(NSInteger)emojiEmoticonsViewNum scrollView:(UIScrollView *)scrollView frame:(CGRect)frame
{
    EmojiEmoticonsView *emojiView = [[self alloc] initWithFrame:frame];
    emojiView.emojiEmoticonsViewNum = emojiEmoticonsViewNum;
    emojiView.scrollView = scrollView;
    [emojiView setupUI];
    return emojiView;
}

- (void)setupUI
{
    
}

- (void)getEmojiWithFileArray:(NSArray *)fileArray
{
    NSString *gifName = nil;
    switch (self.emojiEmoticonsViewNum) {
        case 0:
            {
                self.emotionType = EmotionTypeEmoij;
                self.allEmojis = [NSMutableArray arrayWithArray:[Emoji allEmoji]];
                
            }
            break;
        case 1:
        {
            self.emotionType = EmotionTypeGif;
             gifName = @"emotion";
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutEmojiView
{
    NSInteger columNum;
    NSInteger rowNum;
    
    if (self.emotionType == EmotionTypeEmoij) {
        columNum = KColumNum;
        rowNum  = KRowNum;
    }else{
        columNum = KOtherColumNum;
        rowNum  = KOtherRowNum;
    }
    
    CGFloat width = (self.width - KMargin*(columNum+1))/columNum;
    CGFloat height = width;
    
    BOOL isDelete = NO;
    
    for (int i = 0; i < self.allEmojis.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        NSInteger page = i/(rowNum*columNum);
        btn.frame = [self getFrameWithColumesOfPerRow:columNum rowsOfPerColumn:rowNum itemWidth:width itemHeight:height marginX:KMargin maginY:KMargin atIndex:i atPage:page scrollView:self.scrollView];
        if (self.emotionType == EmotionTypeEmoij) {
            if ((i+1) % (columNum*rowNum) == 0  &&  i > 0)
            {
                isDelete = YES;
                [btn setImage:kChatImage(@"faceDelete@2x") forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(emoijClickAction:) forControlEvents:UIControlEventTouchUpInside];
                //标记删除键
                btn.tag = -1;
            } else {
                if (isDelete) {
                    i--;
                }
                [btn setTitle: self.allEmojis[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [btn addTarget:self action:@selector(emoijClickAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = i;
                
                isDelete = NO;
            }
            [self addSubview:btn];
        } else if (self.emotionType == EmotionTypeGif) {
            NSString *imageName = [[[NSString stringWithFormat:@"section%ld_",self.emojiEmoticonsViewNum-1]stringByAppendingString:self.allEmojis[i]]stringByAppendingString:@"@2x"];
            
            [btn setImage:kChatImage(imageName) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(emotionImageClickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self addSubview:btn];
        } else if (self.emotionType == EmotionTypePhoto) {
            NSString *localPath = [[NSBundle bundle:ChatBundleName]pathForResource:self.allEmojis[i] ofType:@"jpg"];
            
            [btn setImage:[UIImage imageWithContentsOfFile:localPath] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(emotionImageClickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self addSubview:btn];
        }
    }
    
     self.page =  self.allEmojis.count/(columNum*rowNum)+1;
}


//@"/gifFace/gifType1/emotion0",
//@"/gifFace/gifType1/emotion1"

- (NSString *)locationGifPathWithPosition:(NSInteger)position
                                  gifName:(NSString *)gifName
                                 faceType:(NSInteger)faceType
{
    NSString *path = [@"gifFace" stringByAppendingPathComponent:[NSString stringWithFormat:@"gifType%ld",faceType]];
    
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld",gifName,position]];
    
    
    return path;
}


//gif表情点击：发消息
- (void)emotionImageClickAction:(UIButton *)btn
{
    
    NSString *localPath = nil;
    
    if (self.emotionType == EmotionTypePhoto)
    {
        localPath  = [[NSBundle bundle:ChatBundleName]pathForResource:self.allEmojis[btn.tag] ofType:@"jpg"];
    }
    
    else if (self.emotionType == EmotionTypeGif)
    {
        
//        FLAnimatedImageView *imageV = (FLAnimatedImageView *)[(UIGestureRecognizer * )btn view];
//        localPath  = [[NSBundle bundle:BundleName]pathForResource:self.allEmoijs[imageV.tag] ofType:@"gif"];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendEmotionImage:emotionType:)])
    {
        
        [_delegate sendEmotionImage:localPath emotionType:self.emotionType];
        
    }
}



//emoij表情点击：加内容
- (void)emoijClickAction:(UIButton *)btn
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(addEmoij:isDeleteLastEmoij:)]) {
        
        btn.tag == -1 ? [_delegate addEmoij:btn.titleLabel.text isDeleteLastEmoij:YES] : [_delegate addEmoij:btn.titleLabel.text isDeleteLastEmoij:NO];
    }
    
    
}

/**
*  @brief 格式布局
*
*  @param columesOfPerRow 多少列
*  @param rowsOfPerColumn 多少行
*  @param itemWidth       格宽
*  @param itemHeight      格高
*  @param marginX         格子间左右间隙
*  @param marginY         格子间上下间隙
*  @param index           格子所在索引
*  @param page            格子所在页码
*  @param scrollView      格子所在scrollview
*
*  @return <#return value description#>
*/
- (CGRect)getFrameWithColumesOfPerRow:(NSInteger)columesOfPerRow
                      rowsOfPerColumn:(NSInteger)rowsOfPerColumn
                            itemWidth:(CGFloat)itemWidth
                           itemHeight:(NSInteger)itemHeight
                              marginX:(CGFloat)marginX
                               maginY:(CGFloat)marginY
                              atIndex:(NSInteger)index
                               atPage:(NSInteger)page
                           scrollView:(UIScrollView *)scrollView
{
    CGRect itemFrame = CGRectMake((index % columesOfPerRow) * (itemWidth + marginX) + marginX + (page * CGRectGetWidth(scrollView.bounds)), ((index / columesOfPerRow) - rowsOfPerColumn * page) * (itemHeight + marginY) + marginY, itemWidth, itemHeight);
    return itemFrame;
}

@end
