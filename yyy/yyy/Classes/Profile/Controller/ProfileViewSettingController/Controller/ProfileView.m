//
//  ProfileView.m
//  yyy
//
//  Created by TangXing on 15/11/12.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "ProfileView.h"
#import "UserInfoCell.h"
#import "UserInfoTool.h"
#import "UserNameEdit.h"
#import "BirthEdit.h"
#import "PasswordEdit.h"
#import "PhotoKitController.h"
#import "AJPhotoPickerViewController.h"
#import "UIImagePickerController+YYYImagePicker.h"
#import "YYYHttpTool.h"

@interface ProfileView ()<AJPhotoPickerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoKitDelegate,UserNameEditDelegate,BirthdayDelegate>

@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSMutableArray *photos;
@property (strong,nonatomic) UIImageView *imageView;
@property (copy,nonatomic)   NSString *editStr;

@end

@implementation ProfileView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadUserInfo];
    self.view.backgroundColor = YYYBackGroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    _dataSource = @[@"昵称",@"性别",@"出生年月"];
}

- (void)loadUserInfo
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfoTool userInfo].userId,@"userId",nil];
    [YYYHttpTool post:YYYUserInfoGetURL params:params success:^(id json) {
        
        _userInfo = json[@"userInfoValue"];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        TSLog(@"UserInfoGetERROR%@",error);
        
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数
    return 4;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _dataSource.count;
    }
    return 1;
}

//每个分组上边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//每个分组下边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 40;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"ProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    UINib *userInfoNib = [UINib nibWithNibName:@"UserInfoCell" bundle:nil];
    [tableView registerNib:userInfoNib forCellReuseIdentifier:@"infoCell"];
    UserInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"头像";
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 110, 5, 70, 70)];
        if (!_imageView) {
            img.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_userInfo[@"userPhoto"]]]];
        } else {
            img.image = _imageView.image;
            img.frame = CGRectMake(kScreenWidth - 110, 5, 70, 70);
        }
    
        [cell addSubview:img];
    }
    
    if (indexPath.section == 1 && _userInfo) {
        
        infoCell.infoTitle.text = _dataSource[indexPath.row];
        
        if (indexPath.row == 0) {
            infoCell.infoText.text = _userInfo[@"userName"];
        } else if (indexPath.row == 1) {
            
            NSString *gender = _userInfo[@"gender"];
            
            if ([gender isEqualToString:GENDER_MALE]) {
                infoCell.infoText.text = @"男";
            } else if ([gender isEqualToString:GENDER_FEMALE]) {
                infoCell.infoText.text = @"女";
            } else {
                infoCell.infoText.text = @"不明";
            }
            
        } else if (indexPath.row == 2) {
            infoCell.infoText.text = _userInfo[@"birthday"];
        }
                
        return infoCell;
    }
    
    if (indexPath.section == 2) {
        cell.textLabel.text = @"密码修改";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    if (indexPath.section == 3) {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = YES;
        picker.delegate = self;
        
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return YES;
        }];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UserNameEdit *userNameEditView = [[UserNameEdit alloc] init];
            userNameEditView.name = _userInfo[@"userName"];
            userNameEditView.delegate = self;
            [self.navigationController pushViewController:userNameEditView animated:YES];
        }
        if (indexPath.row == 1) {
            [self chooseGender];
        }
        if (indexPath.row == 2) {
            BirthEdit *birthdayEditView = [[BirthEdit alloc] init];
            birthdayEditView.birthday = _userInfo[@"birthday"];
            birthdayEditView.delegate = self;
            [self.navigationController pushViewController:birthdayEditView animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
        PasswordEdit *psdEditView = [[PasswordEdit alloc] init];
        [self.navigationController pushViewController:psdEditView animated:YES];
    }
    
    //退出登录提示alert
    if (indexPath.section == 3) {
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"真的要注销吗?\n_(:з)∠)_" delegate:self cancelButtonTitle:@"手滑了" otherButtonTitles:@"注销", nil];
        [logoutAlert show];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets
{
    [self.photos addObjectsFromArray:assets];
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    ALAsset *asset = assets[0];
    UIImage *imageOriginal = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    PhotoKitController *photoVC = [PhotoKitController new];
    [photoVC setDelegate:self];
    [photoVC setImageOriginal:imageOriginal];
    [photoVC setSizeClip:CGSizeMake(180, 180)];
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (void)photoKitController:(PhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    self.imageView.image = resultImage;
    
    NSDictionary *params = @{@"userPhoto":[self imageTodata:resultImage]};
    [self postWithUrl:YYYUserPhotoEditURL params:params jsonKey:@"userPhoto" save:YES];
}

- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker
{
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = self;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController: cameraUI animated: YES completion:nil];
    }];
}

#pragma mark - UIImagePickerDelegate
- (void)checkCameraAvailability:(void (^)(BOOL auth))block
{
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}

#pragma mark POST
- (void)postWithUrl:(NSString *)url params:(NSDictionary *)params jsonKey:(NSString *)key save:(BOOL)save
{
    [YYYHttpTool post:url params:params success:^(id json) {
        
        if (save) {
            _editStr = json[@"userInfoValue"][key];
            [self saveUserInfoWithKey:key editItem:_editStr];
        } else {
            [self loadUserInfo];
        }
        
    } failure:^(NSError *error) {
        TSLog(@"ProfileERROR %@",error);
    }];
}

#pragma mark saveUserInfo
- (void)saveUserInfoWithKey:(NSString *)key editItem:(NSString *)editItem
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:userInfo.userId,@"userId",userInfo.userName,@"userName",userInfo.userPhoto,@"userPhoto",userInfo.cookiePassword,@"cookiePassword",nil];
    
    [dict setObject:editItem forKey:key];
    
    userInfo = [UserInfo userInfoWithDict:dict];
    [UserInfoTool saveUserInfo:userInfo];
    
    [self.tableView reloadData];
}

#pragma mark genderChoose
- (void)chooseGender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *unknow = [UIAlertAction actionWithTitle:@"不明" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action)
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:GENDER_UNKNOW,@"gender",nil];
        [self postWithUrl:YYYUserGenderEditURL params:params jsonKey:@"gender" save:NO];
    }];
    
    UIAlertAction *male = [UIAlertAction actionWithTitle:@"男" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action)
    {
       NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:GENDER_MALE,@"gender",nil];
       [self postWithUrl:YYYUserGenderEditURL params:params jsonKey:@"gender" save:NO];
    }];
    
    UIAlertAction *female = [UIAlertAction actionWithTitle:@"女" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action)
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:GENDER_FEMALE,@"gender",nil];
        [self postWithUrl:YYYUserGenderEditURL params:params jsonKey:@"gender" save:NO];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action)
    {
        
    }];
    
    [alertController addAction:unknow];
    [alertController addAction:male];
    [alertController addAction:female];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark UserNameEditDelegate
- (void)UserNameEditSuccess:(NSString *)userName
{
    NSDictionary *params = @{@"userName":userName};
    [self postWithUrl:YYYUserNameEditURL params:params jsonKey:@"userName" save:NO];
}

#pragma mark BirthEditDelegate
- (void)dateChange:(id)sender
{
    NSDictionary *params = @{@"birthday":sender};
    [self postWithUrl:YYYUserBirthdayURL params:params jsonKey:@"birthday" save:NO];
}

- (NSString *)imageTodata:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

#pragma mark -AlertView监听方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSString *fileName = @"userInfo.archive";
        
        //文件名
        NSString *uniquePath=[DocumentsDirectory stringByAppendingPathComponent:fileName];
        NSFileManager* fileManager=[NSFileManager defaultManager];
        [fileManager removeItemAtPath:uniquePath error:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
