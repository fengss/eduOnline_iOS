//
//  UpdataDoc.m
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "UpdataDoc.h"

@interface UpdataDoc()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    //文件的data
    NSData *imageData;
    //图片路径
    NSString* filePath;
    //图片在服务器上的路径
    NSString *serverPath;
}
@property(nonatomic,strong) UIPickerView  * picker;
@end

@implementation UpdataDoc

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)awakeFromNib{
    self.picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    self.picker.dataSource=self;
    self.picker.delegate=self;
    self.age.delegate=self;
    self.username.delegate=self;
    self.desc.delegate=self;
    self.desc.layer.borderColor=[UIColor blueColor].CGColor;
    self.desc.layer.borderWidth=0.4;
    self.desc.layer.masksToBounds=YES;
    self.desc.layer.cornerRadius=10.0f;
}

#pragma mark pickerView
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 200;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld",row+1];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.age.text=[NSString stringWithFormat:@"%ld",row+1];
}
#pragma mark textView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.frame;
        frame.origin.y-=200;
        self.frame=frame;
    }];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.frame;
        frame.origin.y+=200;
        self.frame=frame;
    }];
}


#pragma mark textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.age) {
        textField.inputView=self.picker;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}
- (IBAction)chose:(id)sender {
    [self endEditing:YES];
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"提 示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图库选择",@"拍张上传", nil];
    [action showInView:self];
}

- (IBAction)Up:(id)sender {
    //上传头像
    //上传请求POST
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    
    NSDictionary *dic=@{
                        //这里的pcfile指的是用户名
                        @"picfile":@"fengss"
                        };
    
    
    //开始等待
    [self createProgress];
    
    
    [app.manger POST:USERUPAVATOR parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.avatorImageView.image)
                                    name:@"uploadImg"
                                fileName:@"avatar.png"
                                mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        serverPath=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",serverPath);
//        app.manger POST:<#(NSString *)#> parameters:<#(id)#> success:<#^(NSURLSessionDataTask *task, id responseObject)success#> failure:<#^(NSURLSessionDataTask *task, NSError *error)failure#>
//        
        [self removeProgress];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    

}

#pragma mark action sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //打开相册
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.delegate=self;
        [self.mainVc presentViewController:pickerController animated:YES completion:nil];
    }
    else if (buttonIndex==1){
        //打开照相机
        UIImagePickerControllerSourceType imageType=UIImagePickerControllerSourceTypeCamera;
        //判断相机是否可活动
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //实例化
            UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
            pickerController.delegate=self;
            //被拍照后可编辑
            pickerController.allowsEditing=YES;
            pickerController.sourceType=imageType;
            [self.mainVc presentViewController:pickerController animated:YES completion:nil];
        }
    }
    else if (buttonIndex==2){
        [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    }
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        self.avatorImageView.image=[self scaleFromImage:image toSize:CGSizeMake(300, 400)];
        
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //放入变量NSData中
        imageData=data;
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        
    }
}

/**
 *  等比例缩放
 *
 *  @param targetSize 大小
 *
 *  @return
 */
// 改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  创建等待
 */
-(void)createProgress{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, SCREEN_HEIGHT-69)];
    view.backgroundColor=[UIColor whiteColor];
    view.tag=900;
    [self endEditing:YES];
    [ProgressHUD showOnView:view];
    [self addSubview:view];
}

/**
 *  移除等待
 */
-(void)removeProgress{
    UIView *view=[self viewWithTag:900];
    [ProgressHUD hideOnView:view];
    [view removeFromSuperview];
}

- (IBAction)save:(id)sender {
}
@end
