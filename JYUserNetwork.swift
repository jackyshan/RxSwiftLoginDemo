//
//  UserNetwork.swift
//  alliance
//
//  Created by jackyshan on 2017/12/29.
//  Copyright © 2017年 GCI. All rights reserved.
//

import UIKit

class JYUserNetwork: BaseNetwork {
    fileprivate static var my: JYUserNetwork!
    
    static var This: JYUserNetwork {
        if my == nil {
            my = JYUserNetwork(mould: "")
        }
        
        return my
    }
    
    /** 注册用户 */
    static let CMD_register = "api/register"
    
    /** 获取验证码 */
    static let CMD_authCode = "authCode/get"
    
    /** 用户登录 */
    static let CMD_login = "api/login"
    
    /** 用户修改密码 */
    static let CMD_edit_pwd = "edit/pwd"

}
