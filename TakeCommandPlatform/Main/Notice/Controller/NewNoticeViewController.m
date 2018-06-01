//
//  NewNoticeViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/27.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NewNoticeViewController.h"
#import "ReceiverView.h"
#import "ReceiverModel.h"
#import "AssetManager.h"
#import "ImagePickerController.h"
#import "ImageDeleteController.h"

@interface NewNoticeViewController () <UITextFieldDelegate, UITextViewDelegate, ImagePickerControllerDelegate, ImageDeleteDelegate>
@property (weak, nonatomic) IBOutlet UITextField *topic;

@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextView *content;

/** 接收用户界面 */
@property (nonatomic, strong) ReceiverView *reciverView;

/** 接收者 */
@property (nonatomic, strong) NSArray *receiverArray;

/** 接收者id */
@property (nonatomic, strong) NSMutableString *reuserids;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *assetArray;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *arrayImages;


@end

@implementation NewNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新建通知";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"完成" target:self action:@selector(sendNewNotice)];
    _assetArray = [[NSMutableArray alloc] init];
    _arrayImages = [[NSMutableArray alloc] init];
    _topic.layer.borderColor = RGB(73, 130, 186).CGColor;
    _topic.layer.borderWidth = 1.0f;
    _receiver.layer.borderColor = RGB(73, 130, 186).CGColor;
    _receiver.layer.borderWidth = 1.0f;
    _content.layer.borderColor = RGB(73, 130, 186).CGColor;
    _content.layer.borderWidth = 1.0f;
    [self setupReceiverView];
}

- (void)setupReceiverView
{
    ReceiverView *receiver = [[ReceiverView alloc] init];
    [self.view addSubview:receiver];
    [receiver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.right.bottom.equalTo(self.view);
    }];
    receiver.hidden = YES;
    _reciverView = receiver;
    [_reciverView getReciverData];
    
    WeakSelf
    _reciverView.block = ^(NSArray *arr) {
        weakSelf.reciverView.hidden = YES;
        weakSelf.receiverArray = [NSArray arrayWithArray:arr];
        NSMutableString *str = [[NSMutableString alloc] init];
        _reuserids = [[NSMutableString alloc] init];
        for (ReceiverModel *model in weakSelf.receiverArray) {
            [str appendString:model.username];
            [weakSelf.reuserids appendString:model.receiverId];
            if (![model isEqual: [weakSelf.receiverArray lastObject]]) {
                [str appendString:@","];
                [weakSelf.reuserids appendString:@","];
            }
        }
        weakSelf.receiver.text = str;
    };
}


- (IBAction)addAttachmentBtnClick:(UIButton *)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertVc animated:YES completion:nil];
    
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理拍照的代码
        [self takePhoto];
    }];
    
    UIAlertAction *actionLibrary = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理相册的代码
        
        WeakSelf;
        
        CheckAuthorizationCompletionBlock block = ^(AuthorizationType type) {
            if (!weakSelf)return;
            
            switch (type) {
                case kAuthorizationTypeDenied:
                case kAuthorizationTypeRestricted:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相册”选项中，允许本应用程序访问你的相机。" delegate:self cancelButtonTitle:@"好，我知道了" otherButtonTitles:nil];
                    [alert show];
                }
                    break;
                default:
                {
                    ImagePickerController *vc = [[ImagePickerController alloc] init];
                    vc.pickerDelegate = self;
                    vc.selectedNum =  _arrayImages.count ;
                    [self.navigationController presentViewController:vc animated:YES completion:nil];
                }
                    break;
            }
        };
        
        [[AssetManager sharedAssetManager] chechAuthorizationStatus:block];
        
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVc addAction:actionCamera];
    [alertVc addAction:actionLibrary];
    [alertVc addAction:actionCancel];
}

// 开始拍照
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //先检查相机可用是否
        BOOL cameraIsAvailable = [self checkCamera];
        if (YES == cameraIsAvailable) {
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许本应用程序访问你的相机。" delegate:self cancelButtonTitle:@"好，我知道了" otherButtonTitles:nil];
            [alert show];
        }
        
    }
}


//检查相机是否可用
- (BOOL)checkCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(AVAuthorizationStatusRestricted == authStatus ||
       AVAuthorizationStatusDenied == authStatus)
    {
        //相机不可用
        return NO;
    }
    //相机可用
    return YES;
}



///发送新建通知
- (void)sendNewNotice
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    NSString *url = [NSString stringWithFormat:@"%@%@?userid=%@&sessionid=%@&title=%@&content=%@&createtime=%@&reuserids=%@",kServiceAdress, REQUEST_URL_SENDNEWNOTICE, kUserId, kUserSessionid, _topic.text, _content.text, date, _reuserids];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"sender_id"] = kUserId;
    param[@"sessionid"] = kUserSessionid;
    param[@"title"] = _topic.text;
    param[@"content"] = _content.text;
    param[@"send_time"] = date;
    param[@"receiver"] = _reuserids;
  
    [NetworkManager setRequestSerializer:YWRequestSerializerHTTP];
    [NetworkManager setResponseSerializer:YWResponseSerializerHTTP];
//     [NetworkManager setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [NetworkManager setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString * urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(300, 300)];
   
    [NetworkManager uploadWithURL: urlStr parameters:nil images: _arrayImages name:@"uploadfile" fileName:@"image" mimeType:nil progress:^(NSProgress *progress) {

    } success:^(id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"发送失败"];

    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _receiver) {
        [self.view endEditing:YES];
        _reciverView.hidden = NO;
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        NSString *key = nil;
        
        if (imagePickerController.allowsEditing)
        {
            key = UIImagePickerControllerEditedImage;
        }
        else
        {
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage *image = [info objectForKey:key];
        [_arrayImages addObject:image];
//        [self showImage];
        
        [imagePickerController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    
    
}



- (void)imagePickerController:(ImagePickerController *)picker
       didFinishPickingImages:(NSArray<AssetModel *> *)assets
                    withError:(NSError *)error {
    if (error || assets.count == 0) return;
    
    _assetArray = (NSMutableArray*)assets;
    [self getPhotoImage];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    
    
}
- (void)getPhotoImage {
    
    
    for (int i = 0; i < _assetArray.count; i++) {
        AssetModel *model = _assetArray[i];
        //获取原型
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat imageHeight = floor((SCREEN_WIDTH/model.asset_PH.pixelWidth) * model.asset_PH.pixelHeight);
        CGSize pixSize = CGSizeMake(SCREEN_HEIGHT * scale, imageHeight * scale);
        [model fetchThumbnailWithPointSize:pixSize completion:^(UIImage * _Nullable image, AssetModel * _Nonnull assetModel) {
            if (assetModel == model) {
                [_arrayImages addObject:image];
//                [self showImage];
            }
        }];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
