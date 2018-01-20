//
//  JYUserSendModel.swift
//  alliance
//
//  Created by jackyshan on 2017/12/29.
//  Copyright © 2017年 GCI. All rights reserved.
//

import UIKit

class JYUserSendModel: BaseHandyJSON {
    var mobile: String = ""
}

class JYUserAuthCodeSendModel: JYUserSendModel {
    var type: Int = 0 //验证码用途 0-登录 1-注册 2-修改密码
}

class JYUserLoginSendModel: JYUserSendModel {
    var pwd: String = ""
    var authCode: String = ""
}

class JYUserModifyPasswdSendModel: JYUserLoginSendModel {
}

class JYUserRegisterSendModel: JYUserLoginSendModel {
    var cusType: Int = 1 //用户类型 1-注册用户 2-代理商
    var cusSource: Int = 3//用户来源 1-网站注册用户、2-微信公众号用户、3-App注册用户，4-小程序用户
}

class JYUserResponseModel: BaseHandyJSON {
    
    var id: String?
    
    var verifyMobile: String?
    
    var sex: Int = 0
    
    var totalPoints: Int = 0
    
    var cusLevel: Int = 0
    
    var createTime: CLongLong = 0
    
    var del: Bool = false
    
    var pwd: String?
    
    var cusStatus: Int = 0
    
    var cusType: Int = 0
    
    var cusSource: Int = 0
    
    var totalOrders: Int = 0
    
    var updateTime: CLongLong = 0
    
    var cusName: String?
}
