//
//  NoteModel.h
//  魔方
//
//  Created by coderss on 15/5/12.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject
@property(nonatomic,strong)NSString *addtime;
@property(nonatomic,strong)NSString *clicknum;
@property(nonatomic,strong)NSString *collnum;
@property(nonatomic,strong)NSString *commnum;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *picname;
@property(nonatomic,strong)NSString *picture;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *vid;
@property(nonatomic,strong)NSString *videoname;
@property(nonatomic,copy) NSString  * zanNum;
@property(nonatomic,copy) NSString *isZan;
@property(nonatomic,copy) NSString *isColl;
@property(nonatomic,strong) NSString  * maxNum;
@end
