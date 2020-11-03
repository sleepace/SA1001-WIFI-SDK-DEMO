//
//  MusicListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "MusicListViewController.h"

#import "SelectItemCell.h"
#import "MusicInfo.h"
#import <SLPTCP/SLPLTcpCommon.h>

@interface MusicListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"music_list");
    
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
    
    if (self.mode == FromMode_Alarm) {
        self.saveBtn.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectItemCell *cell = (SelectItemCell *)[SLPUtils tableView:tableView cellNibName:@"SelectItemCell"];
    MusicInfo *musicInfo = [self.musicList objectAtIndex:indexPath.row];
    cell.titleLabel.text = musicInfo.musicName;
    if (musicInfo.musicID == self.musicID) {
        cell.selectIcon.hidden = NO;
    }else{
        cell.selectIcon.hidden = YES;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicInfo *musicInfo = [self.musicList objectAtIndex:indexPath.row];
    self.musicID = musicInfo.musicID;
    
    [self playMusic:self.musicID];
    
    [self.tableView reloadData];
}

- (void)playMusic:(NSInteger)musicID
{
    if (![SLPLTcpCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    if (self.mode == FromMode_Alarm) {
        [SLPSharedLTcpManager salTurnOnMusic:musicID volume:12 playMode:2 deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }else{
                if (weakSelf.musicBlock) {
                    weakSelf.musicBlock(weakSelf.musicID);
                }
            }
        }];
    }
}

- (IBAction)saveAction:(id)sender {
    
    if (self.mode == FromMode_SleepAid) {
        if (self.musicBlock) {
            self.musicBlock(self.musicID);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)stopMusic
{
    __weak typeof(self) weakSelf = self;
    if (self.mode == FromMode_Alarm) {
        if (![SLPLTcpCommon isReachableViaWiFi]) {
            [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
            return;
        }
        [SLPSharedLTcpManager salTurnOffMusicDeviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }else{
                if (weakSelf.musicBlock) {
                    weakSelf.musicBlock(weakSelf.musicID);
                }
            }
        }];
    }
}

-(void)back
{
    if (self.mode == FromMode_Alarm) {
        [self stopMusic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
