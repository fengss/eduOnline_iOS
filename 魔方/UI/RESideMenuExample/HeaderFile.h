//
//  HeaderFile.h
//  RESideMenuExample
//
//  Created by coderss on 15/5/11.
//  Copyright (c) 2015年 Roman Efimov. All rights reserved.
//

#ifndef _G___HeaderFile_h
#define _G___HeaderFile_h
#import "AFNetworking.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "CheckNetworkManager.h"
#import "LoadDataManager.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//笔记的点赞
/**
 *  UID 用户id
 *  id  笔记id
 */
#define NOTEFAVO @"http://edu.coderss.cn/index.php?m=Note&a=favo"

//笔记的收藏
#define NOTESC @"http://edu.coderss.cn/index.php?m=Note&a=collect"

/**
 *  考试中心
 */
#define TESTURL @"http://edu.coderss.cn/index.php/Test/detailForios/id/"
#define TESTCATURL @"http://edu.coderss.cn/index.php/Test/getCatForios"
#define TESTSCORE1 @"http://edu.coderss.cn/index.php/Test/scoreForIos"
#define TESTPAPER @"http://edu.coderss.cn/index.php/Test/getQuestionForIos/id/"
#define TESTANSWER @"http://edu.coderss.cn/index.php/Test/answerForIos/tid/"
//#define USERINSERTURL @"http://edu.coderss.cn/index.php/User/"
//加载考试成绩
#define TESTSCORE @"http://edu.coderss.cn/index.php?m=Test&a=myscoreForIos&uid=%@"

//拿取分类
#define VIDEOITEMURL @"http://edu.coderss.cn/index.php?m=Video&a=getCatForIos"
//播放视频
#define VIDEOPLAYURL @"http://edu.coderss.cn/Public/Uploads/library_swf/"
//视频点赞或者收藏
#define VIDEOFAVO @"http://edu.coderss.cn/index.php?m=Video&a=favoForIos"
#define VIDEOCOLL @"http://edu.coderss.cn/index.php?m=Video&a=collectForIos"
//视图的缩略图
#define VIDEOPIC @"http://edu.coderss.cn/Public/Uploads/videopic/%@"

#define VIDEOIMAGE @"http://edu.coderss.cn/Pulic/Uploads/videopic"
//#define VIDEOPICTURE @"http://edu.coderss.cn/Uploads/"
#define VIDEOCATPICURL @"http://edu.coderss.cn/Public/Uploads/"
#define VIDEOREPLY @"http://edu.coderss.cn/index.php?m=Videocom&a=getReplyForIos&id="
#define USERLOGINURL @"http://edu.coderss.cn/index.php?m=Users&a=dologinForIos"
#define USERICONURL @"http://edu.coderss.cn/Public/Uploads/users/fengss/"
#define USERICONURL1 @"http://edu.coderss.cn/Public/Uploads/users/0/0.jpg"


//用户头像
#define USERICO  @"http://edu.coderss.cn/Public/Uploads/users/%@/%@"
//用户头像上传以及资料修改
#define USERUPAVATOR  @"http://book.coderss.cn/index.php?m=Users&a=uploadpicForIos"
//保存用户头像信息
#define USERSAVEAVATOR @"http://book.coderss.cn/index.php?m=Users&a=updateForIos"

//用户注册
#define USERREGISTER @"http://edu.coderss.cn/index.php?m=Users&a=insertForIos"

//获得用户的地址
#define USERADDRESS @"http://edu.coderss.cn/index.php?m=Users&a=getUserAddress"

//视频的评论
#define VIDEOCOMMENT @"http://edu.coderss.cn/index.php?m=Videocom&a=addvideocomForIos"
//视频的详情
#define VIDEODETAILURL @"http://edu.coderss.cn/index.php?m=Video&a=getVideoForIos&tid=%@&uid=%@"
#define VIDEOONLYURL @"http://edu.coderss.cn/index.php/Video/getOnlyVideo"

//获取用户的详情
#define GETUSERDESC @"http://edu.coderss.cn/index.php?m=Users&a=getUserDesc"
//http://edu.coderss.cn/index.php?m=Video&a=getonlyVideo
//笔记(手记)
/**
 *  追加myuid可以判断出是否赞和收藏笔记
 */
#define NOTEALLURL @"http://edu.coderss.cn/index.php?m=Note&a=indexForIos"
/**
 *  我的笔记
 */
#define NOTEDETAILFORME @"http://edu.coderss.cn/index.php?m=Note&a=indexForIos&uid=%@"
//获取所有内容的分类
#define ALLTYPE @"http://edu.coderss.cn/index.php?m=Cat&a=typeSelectForIos"
/*发表笔记的评论
 uid 用户的id
 nid 笔记的id
 content 评论的内容  --post
 */
#define NOTECOMMENT @"http://edu.coderss.cn/index.php?m=Notecom&a=addCommentForIos"

/**
 *  笔记新增
 * vid 视频的id  uid 用户的id
 */
#define NOTEADD @"http://edu.coderss.cn/index.php?m=Note&a=insertForIos"

//获取笔记的评论
//nid就是笔记的id
#define NOTEMYCOMMENT @"http://edu.coderss.cn/index.php?m=Notecom&a=getCommentForIos&nid=%@"

//http://edu.coderss.cn/index.php?m=Notecom&a=addCommentForIos
/*
 get传递
 资料库的主页
 num 获取的数量
 page 获取第几页
 q 资料的名称
 pid 根据资料的分类id获取
 uid 根据用户的id获取
 */
#define LIBRARYURL @"http://edu.coderss.cn/index.php?m=Library&a=indexForIos"

/*
 list 是普通的资料数据列表
 newlist 是最新的资料数据列表
 */

/*
 资料库的获取详细信息
 get传递
 id 资料的id
 tuilist是猜你喜欢的数据
 */
#define LIBRARYDETAILURL @"http://edu.coderss.cn/index.php?m=Library&a=detailForIos"


/**
 *  利用webview的嵌入
 *
 */
#define LIBDETAILWEB @"http://edu.coderss.cn/index.php/Library/detail/id/%@"

/*资料库收藏
 post 收藏
 id 资料的id
 如果返回yes则成功
 */
#define LIBRARYCOLLECTURL @"http://edu.coderss.cn/index.php/Library/collect"

/*
 资料库的点赞
 post 传递
 id  资料的id
 如果返回yes成功
 */

#define LIBRARAYDETAIL @"http://edu.coderss.cn/Public/Uploads/library/%@"

#define LIBRARYFAVOURL @"http://edu.coderss.cn/index.php/Library/favo"
/*
 资料库的评论
 //post 传递
 "uid":uid ,用户id
 "lid":lid,资料库的id
 "content":content 评论 内容
 如果返回ERROR为失败
 */
#define LIBRARYCOMMENTULR @"http://edu.coderss.cn/index.php/Libcom/addcCommentForIos"
/*
 资料库的资料
 get 传递
 id 资料库的id
 */
#define LIBRARYFORTYPE @"http://edu.coderss.cn/index.php?m=Library&a=dwload&id="

/*
 在资料库上传pdf或者其他的资料
 首先获取类别
 */
#define LIBRARYUPLODETYPE @"http://edu.coderss.cn/index.php?m=Cat&typeSelectFoeIos"

/*
 afnetwork的data附带设置 enctype="multipart/fform-data"
 post传递
 uid 用户的id
 title 资源的名称
 tid类别的id
 lib 文件上传的标志
 如果返回NO为失败
 YES为成功
 */
#define LIBRARYINSERTFORIOS @"http://edu.coderss.cn/index.php/Library/insertForIos"

/*
 获取贴吧首页内容 get或post //num数量 page页码
 pid 类别的id*/
#define MesssageFIRSTURL @"http://edu.coderss.cn/index.php/Message/indexForIos"

//搜索帖子的路径
#define SEARCHMEASSAGEURL @"http://edu.coderss.cn/index.php/Message/index2ForIos"
/*查看大家都在看
 */
#define ALLSEEMESSAGEURL @"http://edu.coderss.cn/index.php/Message/hotForIos"
/*
 增加贴吧的数据
 post传递
 uid用户的id
 content 贴吧的内容
 title 贴吧标题
 keyword 标签就是用分类的id 用逗号隔开
 返回yes为成功 no为失败
 */
#define ADDMESSAGEURL @"http://edu.coderss.cn/index.php/Message/insertForIos"

/*
 贴吧的详情
 这里要用afnetwokrking的session
 manager
 get传递
 //id 帖子的id
 */
#define MESSAGEDETAIL @"http://edu.coderss.cn/index.php/Message/show/id/12"
/*
 贴吧的收藏功能
 添加收藏
 post传递
 vv:n
 mid:帖子id
 ui的用户的id
 如果返回yes为成功 否则no为失败
 */
#define  MESSAGELIKEURL @"http://edu.coderss.cn/index.php/Message/likeForIos"

/*
 取消收藏
 post 传递
 vv:y
 mid:你的帖子
 */

/*
 问吧
 get传递
 num 数量
 page 页码
 */
#define QUESTIONBARFIRSTURL @"http://edu.coderss.cn/index.php/Question/indexForIos"

/*
 问吧搜索
 pid 分类的类别id
 num 数量
 page 页码
 */
#define SEARCHQUESTIONURL @"http://edu.coderss.cn/index.php/Question/index2ForIos"
/*
 问吧添加问题
 获取 老师
 */
#define INSERTQUESTIONURL @"http://edu.coderss.cn/index.php/Question/addForIos"
/*
 填充数据提交
 post传递
 tid 教师的id
 keyworf 分类的id 逗号隔开
 */
#define QUESTIONINSERTURL @"http://edu.coderss.cn/index.php/Question/insert"


/*
 问吧收藏功能
 post传递
 vv:n
 mid:你的帖子
 uid 用户的id
 如果返回yes为成功否则no为失败
 如果返回yes为成功 否则no
 */
#define QUESTIONLIKEURL @"http://edu.coderss.cn/index.php/Question/likeForIos"
#endif