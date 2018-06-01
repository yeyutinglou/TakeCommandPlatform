//
//  MessageListViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/25.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageCell.h"
#import "ContactCell.h"
#import "ChatViewController.h"

@interface MessageListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet UITableView *contactTabelView;

/** x信息数据 */
@property (nonatomic, strong) NSArray *messageArray;

/** 联系人数据 */
@property (nonatomic, strong) NSArray *contactArray;



@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息";
    
    [self setupSegmentedControl];
   
    
}

- (void)setupSegmentedControl
{
    NSArray *arr = @[@"消息", @"通讯录"];
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles: arr];
    segmentedControl1.backgroundColor = RGB(235, 236, 237);
    segmentedControl1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.selectionIndicatorColor = RGB(0, 101, 162);
    segmentedControl1.selectionIndicatorHeight = 2.0f;
    segmentedControl1.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : [UIColor blackColor]};
    //    segmentedControl1.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : RGB(0, 184, 43) };
    segmentedControl1.verticalDividerWidth = 1.0f;
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl1];
    [self segmentedControlChangedValue:segmentedControl1];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            _contactTabelView.hidden = !_messageTableView.hidden;
        }
            break;
        case 1:
        {
            _messageTableView.hidden = !_contactTabelView.hidden;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark — UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_messageTableView == tableView) {
        return _messageArray.count;
    } else {
        return _contactArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_messageTableView == tableView) {
        MessageCell *cell = [MessageCell cellWithTableView:tableView indentifier:@"messageCell"];
        return cell;
    } else {
        ContactCell *cell = [ContactCell cellWithTableView:tableView indentifier:@"contactCell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chat = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chat animated:YES];
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
