
//
//  ChatMacros.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#ifndef ChatMacros_h
#define ChatMacros_h

//chatCell内部视图间距
#define KTopMargin 10
#define KLeftMargin 12


//BubbleImageView

#define KTopBubbleImageMargin 3.5

//由于图片左右拉伸导致图片左右间隙需要调整
#define KReceiverLeftBubbleImageMargin 9
#define KReceiverRightBubbleImageMargin 4

#define KSenderLeftBubbleImageMargin 4
#define KSenderRightBubbleImageMargin 9
#define KBubbleImageMaxWidth 145
#define KBubbleImageMaxHeight 145


//bubbleView最大宽度
#define KMaxWidth SCREEN_WIDTH*3/5


//BubbleVoiceRecoderView
#define KBubbleVoiceMaxWidth SCREEN_WIDTH*3/5

#define kVoiceRecorderTotalTime 120.0
// 发送

#define KSendVoiceImageDefault @"SenderVoiceNodePlaying@2x"      // 小喇叭默认图片
#define KSendVoiceAnimationArray    @[                                   \
@"SenderVoiceNodePlaying000@2x",  \
@"SenderVoiceNodePlaying001@2x",  \
@"SenderVoiceNodePlaying002@2x",  \
@"SenderVoiceNodePlaying003@2x"   \
]



// 接收
#define KReceiveVoiceImageDefault @"ReceiverVoiceNodePlaying@2x"    // 小喇叭默认图片

#define KReceiveVoiceAnimationArray  @[                                    \
@"ReceiverVoiceNodePlaying000@2x",  \
@"ReceiverVoiceNodePlaying001@2x",  \
@"ReceiverVoiceNodePlaying002@2x",  \
@"ReceiverVoiceNodePlaying003@2x"   \
]


#define      KRandomColour                        [UIColor colorWithRed:0.1*(arc4random()%10) green:0.1*(arc4random()%10)  blue:0.1*(arc4random()%10)  alpha:1]

//BubbleLocationView
#define KBubbleLocationImageDefault @"chat_location_preview@2x"


//AlertView
#define AlertShow(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

//时间格式
#define KDateFormate @"YYYY/MM/dd hh:mm:ss"

//发送消息的通知名
#define SendMsgName @"sendMessage"
//删除好友时发出的通知名
#define DeleteFriend @"deleteFriend"

//时间戳出现时间间隔
#define kTimeInterval 60

#endif /* ChatMacros_h */
