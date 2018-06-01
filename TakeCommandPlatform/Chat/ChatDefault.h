//
//  ChatDefault.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/30.
//  Copyright © 2018年 jyd. All rights reserved.
//

#ifndef ChatDefault_h
#define ChatDefault_h

typedef NS_ENUM(NSUInteger, MoreViewType) {
    MoreViewTypePhotoAblums,
    MoreViewTypePhotoLocation,
    MoreViewTypeTakePicture,
    MoreViewTypePhoneCall,
    MoreViewTypeVideoCall
};

typedef NS_ENUM(NSUInteger, KeyBoardType) {
    KeyBoardTypeVoiceRecoder,   //录音
    KeyBoardTypeEmoij,          //emoij
    KeyBoardTypeMore,           //更多
    KeyBoardTypeSystem          //系统键盘
};



/**
 Emotion面板表情类型
 */
typedef enum  {
    EmotionTypeEmoij,           //emoij
    EmotionTypeGif,             //gif
    EmotionTypePhoto,           //静态
}  EmotionType;




#define      SCREEN_WIDTH                     [UIScreen mainScreen].bounds.size.width
#define      SCREEN_HEIGHT                    [UIScreen mainScreen].bounds.size.height




#define KeyToolBarHeight 44

#define KTextViewHeightChangeNotification  @"textViewHeightChangeNotification"




#define kHorizontalPadding 8
#define kVerticalPadding 5



#define KTextHeight 33
#define  KMaxInputViewHeight 140


#define kMaxVoiceRecorderTime 120.0


#define  ChatBundleName @"chat"
#define kChatImage(name) [NSBundle imageWithBundle:ChatBundleName imageName:name]
#import "HPGrowingTextView.h"
#endif /* ChatDefault_h */
