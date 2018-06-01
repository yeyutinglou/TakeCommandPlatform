//
//  ChatMessageCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"
#import "MLEmojiLabel.h"
@protocol ChatMessageCellDelegate <NSObject>

//bubble点击

/**
 *  @brief 点击音频bubble
 *
 *  @param message   <#message description#>
 */
- (void)audioRecoderBubbleDidSelectedOnMessage:(ChatMessageModel *)message;

/**
 *  @brief 点击视频bubble
 *
 *  @param message   <#message description#>
 */
- (void)videoBubbleDidSelectedOnMessage:(ChatMessageModel *)message;

/**
 *  @brief 双击纯文本Bubble
 *
 *  @param message   <#message description#>
 */
- (void)textBubbleDidSelectedOnMessage:(ChatMessageModel *)message;


/**
 *  @brief 点击位置bubble
 *
 *  @param message   <#message description#>
 */
- (void)locationBubbleDidSelectedOnMessage:(ChatMessageModel *)message;

/**
 *  @brief 点击图片bubble
 *
 *  @param message   <#message description#>
 */
- (void)photoBubbleDidSelectedOnMessage:(ChatMessageModel *)message photo:(UIImageView *)photo;




//other点击

/**
 *  @brief 头像点击
 *
 *  @param message   <#message description#>
 */
- (void)avaterDidSelectedOnMessage:(ChatMessageModel *)message;


/**
 *  @brief 消息发送失败后重新发送消息
 *
 *  @param message   <#message description#>
 */
- (void)resendMessage:(ChatMessageModel *)message;



/**
 *  @brief 富文本消息，点击链接
 *
 *  @param link <#link description#>
 *  @param type 连接类型
 */
- (void)didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type;



@end

@interface ChatMessageCell : UITableViewCell

/** messageModel */
@property (nonatomic, strong) ChatMessageModel *message;

/** delegate */
@property (nonatomic, weak) id <ChatMessageCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;

+ (CGFloat)cellHeight:(ChatMessageModel *)message;


@end
