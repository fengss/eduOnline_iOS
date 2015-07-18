
//
//  AskQuestionViewController.m
//  3G学院
//
//  Created by coderss on 15/5/9.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "HeaderFile.h"
#import "TestCatModel.h"
#import "MyUtil.h"
#import "SearchLabelView.h"
#import "Teacher.h"
@interface AskQuestionViewController ()<SearchLabelViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *catArray;
@property(nonatomic,strong)UIScrollView *catSelectView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *selectCatArray;
@property(nonatomic,strong)SearchLabelView *searchLabelView;
@property(nonatomic,strong)UITextField *contentView;
@property(nonatomic,strong)UITextField *titleView;
@property(nonatomic,strong)UITextField *teacherFiled;
@property(nonatomic,strong)NSArray *teahcer;
@property(nonatomic,strong)NSMutableArray *teacherArray;
@property(nonatomic,strong)UIButton *submitBtn;
@end

@implementation AskQuestionViewController
-(NSMutableArray *)selectCatArray
{
    if (_selectCatArray == nil) {
        _selectCatArray = [[NSMutableArray alloc]init];
    }
    return _selectCatArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSelectLabelView];
    [self createMessageTitle];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text= @"我要提问";
    label.textColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
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
    UIView *view = (UIView *)[self.view viewWithTag:400];
    if (view != nil) {
        [view removeFromSuperview];
    }
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
            
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 335, 300)];
            textView.tag = 601;
            textView.text = self.contentView.text;
            //  [textView becomeFirstResponder];
            
            [self.view addSubview:textView];
            
            UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            submitBtn.frame = CGRectMake(275,355,100, 30);
            CALayer *submitBtnLayer = submitBtn.layer;
            submitBtnLayer.borderWidth = 1.0;
            submitBtnLayer.borderColor = [UIColor blueColor].CGColor;
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
            maskView.alpha = 0.5;
            maskView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:maskView];
            UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
            [maskView addGestureRecognizer:g];
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 270, 300)];
            textView.tag = 601;
            textView.text = self.contentView.text;
            [textView becomeFirstResponder];
            [self.view addSubview:textView];
            
            UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            submitBtn.frame = CGRectMake(210,355,80, 30);
            
            CALayer *submitBtnLayer = submitBtn.layer;
            submitBtnLayer.borderWidth = 1.0;
            submitBtnLayer.borderColor = [UIColor blueColor].CGColor;
            [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
            submitBtn.tag = 602;
            [submitBtn addTarget:self action:@selector(contentSubmitClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:submitBtn];
        }];
    }
}
-(void)hideKeyboard:(UIGestureRecognizer *)g
{
    UITextView *textView = (UITextView *) [self.view viewWithTag:601];
    NSString *str = textView.text;
    self.contentView.text = str;
}
-(void)contentSubmitClick
{
    UITextView *textView = (UITextView *) [self.view viewWithTag:601];
    NSString *str = textView.text;
    self.contentView.text = str;
    [textView resignFirstResponder];
    UIView *view = (UIView *)[self.view viewWithTag:600];
    [view removeFromSuperview];
    UITextView *view1 = (UITextView *)[self.view viewWithTag:601];
    [view1 removeFromSuperview];
    UIButton *view2 = (UIButton*)[self.view viewWithTag:602];
    [view2  removeFromSuperview];
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
        
       //查出老师姓名
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadTeacherName:) name:@"AddTeacherData" object:nil];
        NSString *url1 = INSERTQUESTIONURL;
        [manager loadDataWithURL:url1 WithNotname:@"AddTeacherData"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)loadTeacherName:(NSNotification * )not
{
    NSDictionary *dict = not.userInfo;
    self.teacherArray = [[NSMutableArray alloc]init];
    for(NSString *keyString in [dict allKeys])
    {
        Teacher *model = [[Teacher alloc]init];
        NSLog(@"关键值%@",keyString);
        model.teancherId  = keyString;
        model.name  = [dict objectForKey:keyString];
        [self.teacherArray addObject:model];
    }
    NSLog(@"%@",self.teacherArray);
    self.teahcer = [[NSArray alloc]initWithArray:[dict allValues]];
    NSLog(@"******%@",self.teahcer);
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
    self.searchLabelView = [[SearchLabelView alloc]initWithFrame:CGRectMake(20, 5, 260, 40) sectionInsets:UIEdgeInsetsMake(5, 5, 5, 5) spaceX:5];
    self.searchLabelView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = self.searchLabelView.layer;
    layer.borderColor = [UIColor blueColor].CGColor;
    layer.borderWidth = 1.5;
    [self.view addSubview:self.searchLabelView];
    self.searchLabelView.delegate = self;
}
-(void)createCatSelectView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50,260 ,30 )];
    label.text = @"请选择标签";
    label.font =[UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    self.catSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 80, 260, 50)];
    CALayer *layerCat = self.catSelectView.layer;
    layerCat.borderColor = [UIColor blueColor].CGColor;
    layerCat.borderWidth = 1.2;
    for(int i = 0 ; i < self.catArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0+(80+2)*i, 10, 80,30 );
        TestCatModel *model = self.catArray[i];
        CALayer *layer = btn.layer;
        layer.borderWidth = 1;
        layer.borderColor =[UIColor blueColor].CGColor;
        layer.cornerRadius = 10.0;
        
        
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        btn.tag = 500+i;
        [btn addTarget:self action:@selector(catTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.catSelectView addSubview:btn];
        btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.jpg"]];
    }
    self.catSelectView.showsHorizontalScrollIndicator = NO;
    self.catSelectView.contentSize = CGSizeMake(50 * self.catArray.count, 50);
    [self.view addSubview:self.catSelectView];
}
-(void)btnClick
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(80, 155,80, 20 *self.teahcer.count)];
    [self.view addSubview:view];
    
    view.tag = 400;
    for(int i = 0 ; i < self.teahcer.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 20 * i,80 ,20);
        [btn setTitle:self.teahcer[i] forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.jpg"]];
        CALayer *layer = btn.layer;
        layer.borderColor = [UIColor blueColor].CGColor;
        layer.borderWidth = 1.0;
        btn.tag = 300 + i;
        [btn addTarget:self action:@selector(teacherName:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)teacherName:(UIButton *)btn
{
    UITextField *textFiled = (UITextField *)[self.view viewWithTag:200];
    textFiled.textAlignment = NSTextAlignmentCenter;
    textFiled.text = btn.titleLabel.text;
    
    UIView *view = (UIView *)[self.view viewWithTag:400];
    [view removeFromSuperview];
}
-(void)createMessageTitle
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 135, 80, 20)];
    label.text = @"选择教师";
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    UITextField *teacherField = [[UITextField alloc]initWithFrame:CGRectMake(90, 135, 80,20)];
    teacherField.userInteractionEnabled = NO;
    teacherField.tag = 200;
    self.teacherFiled = teacherField;
    teacherField.font = [UIFont systemFontOfSize:12];
    CALayer *nameLayer = teacherField.layer;
    nameLayer.borderColor = [UIColor blueColor].CGColor;
    nameLayer.borderWidth = 1.0;
    
    [self.view addSubview:teacherField];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(label.frame.origin.x+80-10 ,label.frame.origin.y-5, 200, 30);
    [btn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 260, 20)];
    label1.text = @"内容";
    label1.font = [UIFont systemFontOfSize:12];
    UITextField *contentView = [[UITextField alloc]initWithFrame:CGRectMake(20, 185,260 , 40)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    view.backgroundColor = [UIColor clearColor];
    [contentView addSubview:view];
    self.contentView = contentView;
    contentView.tag = 500;
    contentView.backgroundColor = [UIColor lightGrayColor];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    CALayer *layer = contentView.layer;
    layer.borderColor = [UIColor blueColor].CGColor;
    layer.borderWidth = 1.0;
    [self.view addSubview:label1];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(220,290,100, 20);
    submit.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.jpg"]];
    CALayer *layerSubmit = submit.layer;
    layerSubmit.borderWidth = 1.0;
    layerSubmit.borderColor = [UIColor blueColor].CGColor;
    layerSubmit.cornerRadius = 10;
    [submit setTitle:@"提问" forState:UIControlStateNormal];
    submit.enabled = YES;
    submit.tag = 333;
    self.submitBtn = submit;
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
    [ProgressHUD showOnView:self.view];
    self.submitBtn.enabled = NO;
    NSString *content = self.contentView.text;
    NSString *userid = @"99";
    NSString *labelid = @"";
    NSString *teacherId = self.teacherFiled.text;
    for(int i = 0 ; i < self.teacherArray.count;i++)
    {
        Teacher *model = self.teacherArray[i];
        if ([teacherId isEqualToString:model.name]) {
            teacherId = model.teancherId;
        }
    }
    
    for(int i = 0 ; i < self.selectCatArray.count;i++)
    {
        TestCatModel *model = self.selectCatArray[i];
        if (i== 0) {
            labelid = [labelid stringByAppendingFormat:@"%@",model.id];
        }
        else
        {
            labelid = [labelid stringByAppendingFormat:@",%@",model.id];
        }
    }
#warning 提交问题url有误
    
    NSDictionary *dict = @{@"uid":userid,@"content":content,@"keyword":labelid,@"tid":teacherId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager POST:QUESTIONINSERTURL  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.submitBtn.enabled = YES;
        [ProgressHUD hideAfterSuccessOnView:self.view];
        //成功后跳转到详情页   详情页要判断 是否是本人发的
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD hideAfterFailOnView:self.view];
    }];
   
}
-(void)catTypeSelect:(UIButton *)btn
{
    NSInteger index = btn.tag - 500;
    TestCatModel *model = self.catArray[index];
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

#pragma mark -SearchLabelView代理方法
-(NSInteger)numberOfCellInSearchLableView:(SearchLabelView *)searchLabelView{
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
