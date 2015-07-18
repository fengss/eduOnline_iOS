
//
//  AddMessageController.m
//  3G学院
//
//  Created by coderss on 15/5/9.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "AddMessageController.h"
#import "HeaderFile.h"
#import "TestCatModel.h"
#import "MyUtil.h"
#import "SearchLabelView.h"
@interface AddMessageController ()<SearchLabelViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *catArray;
@property(nonatomic,strong)UIScrollView *catSelectView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *selectCatArray;
@property(nonatomic,strong)SearchLabelView *searchLabelView;
@property(nonatomic,strong)UITextField *contentView;
@property(nonatomic,strong)UITextField *titleView;
@end

@implementation AddMessageController
-(NSMutableArray *)selectCatArray
{
    if (_selectCatArray == nil) {
        _selectCatArray = [[NSMutableArray alloc]init];
    }
    return _selectCatArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent=NO;
    [self createNavigationBtn];
    [self createSelectLabelView];
    [self createMessageTitle];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignEnding)];
    [self.view addGestureRecognizer:g];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    NSString *networkNetWork = @"addMessage";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:networkNetWork object:nil];
    CheckNetworkManager *netWorkManager = [CheckNetworkManager shareCheckNetworkManager];
    [netWorkManager checkNetWorkWithNotName:networkNetWork];
}
-(void)resignEnding{
    [self.view endEditing:YES];
}
-(void)keyboardWillHide:(NSNotification *)not
{
    NSDictionary *userInfo = not.userInfo;
    NSTimeInterval duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIView *maskView = [self.view viewWithTag:600];
        [maskView removeFromSuperview];
        
        UITextView *textView = (UITextView *) [self.view viewWithTag:601];
        [textView removeFromSuperview];
      
        UIButton *submitBtn = (UIButton *)[self.view viewWithTag:602];
        [submitBtn removeFromSuperview];
    }];
}
-(void)keyboardWillShow:(NSNotification *)not
{
    NSDictionary *userInfo = not.userInfo;
    //判断哪个是第一响应
    NSLog(@"%@",userInfo);
    NSInteger index = 0;
    for(UIView *view in self.view.subviews)
    {
        if([view isFirstResponder])
            
        {
          index = view.tag;
        }
    }
    if (index == 500) {
        NSTimeInterval duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            
            UIView *maskView = [[UIView alloc]initWithFrame:self.view.bounds];
            maskView.tag = 600;
            maskView.alpha = 0.3;
            maskView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:maskView];
            UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
            [maskView addGestureRecognizer:g];
            [self hideKeyboard:g];
        
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 300)];
            textView.tag = 601;
            textView.text = self.contentView.text;
          //  [textView becomeFirstResponder];
            
            [self.view addSubview:textView];
            
            UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            submitBtn.frame = CGRectMake(200,350,100, 20);
            submitBtn.backgroundColor = [UIColor yellowColor];
            [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
            submitBtn.tag = 602;
            [submitBtn addTarget:self action:@selector(contentSubmitClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:submitBtn];
        }];

    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger index = textField.tag;
    if (index == 500) {
        [UIView animateWithDuration:0.25 animations:^{
            
            UIView *maskView = [[UIView alloc]initWithFrame:self.view.bounds];
            maskView.tag = 600;
            maskView.alpha = 0.3;
            maskView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:maskView];
            UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
            [maskView addGestureRecognizer:g];
            
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 300)];
            textView.tag = 601;
            textView.text = self.contentView.text;
            [textView becomeFirstResponder];
            [self.view addSubview:textView];
            
            UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            submitBtn.frame = CGRectMake(200,350,100, 20);
            submitBtn.backgroundColor = [UIColor yellowColor];
            [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
            submitBtn.tag = 602;
            [submitBtn addTarget:self action:@selector(contentSubmitClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:submitBtn];
        }];
    }
}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSInteger index = textField.tag;
//    if (index == 501) {
//        UITextField  *textField1 = (UITextField *)[self.view viewWithTag:500];
//        if ([textField1 isFirstResponder]) {
//            [UIView animateWithDuration:0.25 animations:^{
//                [textField1 resignFirstResponder];
//                UIView *maskView = [[UIView alloc]initWithFrame:self.view.bounds];
//                maskView.tag = 600;
//                maskView.alpha = 0.3;
//                maskView.backgroundColor = [UIColor blackColor];
//                [self.view addSubview:maskView];
//                UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
//                [maskView addGestureRecognizer:g];
//                
//                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 335, 300)];
//                textView.tag = 601;
//                textView.text = self.contentView.text;
//                [textView becomeFirstResponder];
//                [self.view addSubview:textView];
//                
//                UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                submitBtn.frame = CGRectMake(275,350,100, 20);
//                submitBtn.backgroundColor = [UIColor yellowColor];
//                [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
//                submitBtn.tag = 602;
//                [submitBtn addTarget:self action:@selector(contentSubmitClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:submitBtn];
//            }];
//            
//   
//        }
//    }
//}
-(void)hideKeyboard:(UIGestureRecognizer *)g
{
    UITextView *textView = (UITextView *) [self.view viewWithTag:601];
    NSString *str = textView.text;
    self.contentView.text = str;
    [textView resignFirstResponder];
}
-(void)contentSubmitClick
{
    UITextView *textView = (UITextView *) [self.view viewWithTag:601];
    NSString *str = textView.text;
    self.contentView.text = str;
    
    UIView *view=[self.view viewWithTag:600];
    UITextField *text=[self.view viewWithTag:601];
    UIButton *btn=[self.view viewWithTag:602];
    
    [view removeFromSuperview];
    [text removeFromSuperview];
    [btn removeFromSuperview];
    
    [textView resignFirstResponder];
}
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict =not.userInfo;
    NSString *isConnected  = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [ProgressHUD showOnView:self.view];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"AddMessageData" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = TESTCATURL;
        [manager loadDataWithURL:url WithNotname:@"AddMessageData"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)loadData:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSArray *array = dict[@"items"];
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    self.titleArray = [[NSMutableArray alloc]init];
    for(NSDictionary *d in array)
    {
        TestCatModel *model = [[TestCatModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.titleArray  addObject:model.name];
        [itemArray addObject:model];
        NSArray *sub1 = d[@"subclass"];
        NSString *subJ = [NSString stringWithFormat:@"%@",sub1];
        if ([subJ isEqualToString:@"<null>"]) {
        }
        else
        {
            for(NSDictionary *sub in sub1)
            {
                TestCatModel * model  = [[TestCatModel alloc]init];
                [model setValuesForKeysWithDictionary:sub];
                [itemArray addObject:model];
                [self.titleArray  addObject:model.name];
            }
        }
    }
    self.catArray = itemArray;
    [self createCatSelectView];
    [ProgressHUD hideAfterSuccessOnView:self.view];
}
-(void)createSelectLabelView
{
    self.searchLabelView = [[SearchLabelView alloc]initWithFrame:CGRectMake(30, 65, 260, 40) sectionInsets:UIEdgeInsetsMake(5, 5, 5, 5) spaceX:5];
    self.searchLabelView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.searchLabelView];
     self.searchLabelView.delegate = self;
}
-(void)createCatSelectView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 110,260 ,30 )];
    label.text = @"请选择标签";
    [self.view addSubview:label];
    self.catSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 140, 260, 50)];
    for(int i = 0 ; i < self.catArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0+(80+2)*i, 0, 80, 50);
        TestCatModel *model = self.catArray[i];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.tag = 500+i;
        [btn addTarget:self action:@selector(catTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.catSelectView addSubview:btn];
        if (i % 2 == 0) {
            btn.backgroundColor = [UIColor yellowColor];
        }
        else
        {
            btn.backgroundColor = [UIColor grayColor];
        }
     }
    self.catSelectView.showsHorizontalScrollIndicator = NO;
    self.catSelectView.contentSize = CGSizeMake(50 * self.catArray.count, 50);
    [self.view addSubview:self.catSelectView];
}
-(void)createMessageTitle
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 195, 260, 20)];
    label.text = @"帖子标题";
    [self.view addSubview:label];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(30, 220, 260, 20)];
    textField.delegate = self;
    textField.backgroundColor =[UIColor yellowColor];
    [self.view addSubview:textField];
    self.titleView = textField;
    textField.tag = 501;
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 240, 260, 20)];
    label1.text = @"内容";
    [self.view addSubview:label1];
    
    UITextField *contentView = [[UITextField alloc]initWithFrame:CGRectMake(30, 275,260 , 40)];
    self.contentView = contentView;
    contentView.tag = 500;
    contentView.backgroundColor = [UIColor lightGrayColor];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(220,350,100, 20);
    submit.backgroundColor = [UIColor redColor];
    [submit setTitle:@"发帖" forState:UIControlStateNormal];
    submit.enabled = YES;
    submit.tag = 333;
    [self.view addSubview:submit];
    [submit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}
static int i = 0 ;
static  int j = 0 ;
-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger index = textView.tag;
    if (![textView.text isEqualToString:@""]) {
        if (index == 501) {
            i = 1;
        }
        if (index == 500) {
            j = 1;
        }
    }
    else
    {
        if (index == 501) {
            i = 0;
        }
        if (index == 500) {
            j = 0;
        }
    }
    if (i == 1 && j == 1) {
        UIButton *submitBtn = (UIButton *)[self.view viewWithTag:333];
        submitBtn.enabled = YES;
    }
    else
    {
        UIButton *submitBtn = (UIButton *)[self.view viewWithTag:333];
        submitBtn.enabled = NO;

    }
}
-(void)submitClick
{

    NSString *content = self.contentView.text;
    NSString *title = self.titleView.text;
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
//    NSString *userid = [udf objectForKey:@"userid"];

    //测试userid
    NSString *userid=@"97";
    
    //如果没有登录直接不允许发帖
    if (userid==nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"请登录后发帖" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *labelid = @"";
    for(int i = 0 ; i < self.selectCatArray.count;i++)
    {
        TestCatModel *model = self.selectCatArray[i];
        if (i== 0) {
            labelid = [labelid stringByAppendingFormat:@"%@",model.id];
        }
        else
        {
            labelid = [labelid stringByAppendingFormat:@",%@",model.id];        }
    }
    NSDictionary *dict = @{@"uid":userid,@"content":content,@"title":title,@"keyword":labelid};
    NSLog(@"%@",dict);
    //发送网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager POST:ADDMESSAGEURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];    
}
-(void)catTypeSelect:(UIButton *)btn
{
    NSInteger index = btn.tag - 500;
    TestCatModel *model = self.catArray[index];
    //判断是否存在在数组中
    for(int i = 0 ; i < self.selectCatArray.count;i++)
    {
        TestCatModel *model1 = self.selectCatArray[i];
        if ([model.name isEqualToString:model1.name]) {
            return;
        }
    }
    [self.selectCatArray addObject:model];
    if (self.selectCatArray.count > 3) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多三个标签" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    [self.searchLabelView refreshData];
}
-(void)createNavigationBtn
{
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn  setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    arrowBtn.frame = CGRectMake(10, 10, 40, 20);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text= @"发帖";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blueColor];
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithCustomView:arrowBtn];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:label];

    self.navigationItem.rightBarButtonItems=@[item1,item2];

    [arrowBtn addTarget:self action:@selector(navBackBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)navBackBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -SearchLabelView代理方法
-(NSInteger) numberOfCellInSearchLableView:(SearchLabelView *)searchLabelView{
    return self.selectCatArray.count;
}
-(void)configCell:(SearchLableCell *)cell atIndex:(NSInteger)index inSearchView:(SearchLabelView *)searchLableView
{
    TestCatModel *model = self.selectCatArray[index];
    [cell config:model.name];
}
-(void)deleteCellAtIndex:(NSInteger)index inGridView:(SearchLabelView *)searchLabelView
{
    [self.selectCatArray removeObjectAtIndex:index];
    [self.searchLabelView refreshData];
}
@end
