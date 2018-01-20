//
//  JYForgetPasswdViewController.swift
//  alliance
//
//  Created by jackyshan on 2017/12/26.
//  Copyright © 2017年 GCI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class JYForgetPasswdViewController: JYBaseViewController {

    // MARK: - 1、属性
    @IBOutlet weak var phoneFd: UITextField!
    @IBOutlet weak var verifyFd: UITextField!
    @IBOutlet weak var passwdFd: UITextField!
    @IBOutlet weak var passwdAgainFd: UITextField!

    @IBOutlet weak var verifyBtn: VerifyCodeBtn!
    @IBOutlet weak var forgetBtn: UIButton!

    // MARK: - 2、生命周期
    init() {
        super.init(nibName: "JYForgetPasswdViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initLinstener()
        initData()
    }
    
    // MARK: 初始化ui
    func initUI() {
        showLeftButton()
        self.view.backgroundColor = AppConfig.XXT_LightGray
        self.title = "忘记密码"
        
    }
    
    // MARK: 初始化linstener
    let disposeBag = DisposeBag()
    func initLinstener() {
        let phoneValid = phoneFd.rx.text.orEmpty.distinctUntilChanged().asObservable().map({$0.count == 11})
        let veryCodeValid = verifyFd.rx.text.orEmpty.distinctUntilChanged().asObservable().map({$0.count > 0})
        let passwdValid = passwdFd.rx.text.orEmpty.distinctUntilChanged().asObservable().map({$0.count >= 6 && $0.count <= 14})
        let confirmPasswdValid = passwdAgainFd.rx.text.orEmpty.distinctUntilChanged().asObservable().map({$0.count >= 6 && $0.count <= 14})
        let passwdEqualValid = Observable.combineLatest(passwdFd.rx.text.orEmpty.distinctUntilChanged().asObservable(), passwdAgainFd.rx.text.orEmpty.distinctUntilChanged()).map({$0 == $1})
        
        phoneValid.bind(to: verifyBtn.rx.isEnabled).addDisposableTo(disposeBag)
        
        Observable.combineLatest(phoneValid, veryCodeValid, passwdValid, confirmPasswdValid, passwdEqualValid).map({$0 && $1 && $2 && $3 && $4}).bind(to: forgetBtn.rx.isEnabled).addDisposableTo(disposeBag)
        
    }
    
    // MARK: 初始化data
    func initData() {
    }
    
    // MARK: 设置frame
    override func didSystemAutoLayoutComplete() {
    }
    
    // MARK: - 3、代理
    
    // MARK: - 4、业务
    @IBAction func clickVerifyAction() {
        verifyBtn.startTimer()
        getAuthCodeData()
    }
    
    @IBAction func clickForgetAction() {
        forgetPasswdData()
    }

    // MARK: - 5、网络
    func getAuthCodeData() {
        let send = JYUserAuthCodeSendModel()
        send.mobile = phoneFd.text!
        send.type = 2
        
        JYUserNetwork.This.doTask(JYUserNetwork.CMD_authCode, data: send, controller: nil, success: { _ in
        }, error: nil, com: nil, showWait: false)
    }
    
    func forgetPasswdData() {
        let send = JYUserModifyPasswdSendModel()
        send.mobile = phoneFd.text!
        send.authCode = verifyFd.text!
        let passwd = DES3Util.encryptUseDES(passwdFd.text!, key: AppConfig.desKey)
        send.pwd = passwd!
        
        JYUserNetwork.This.doTask(JYUserNetwork.CMD_edit_pwd, data: send, controller: nil, success: { [weak self] (response: JYUserResponseModel?) in
            self?.navigationController?.popViewController(animated: true)
            }, error: { [weak self] (_, errMsg) in
                self?.noticeAutoError(errMsg)
            }, com: nil, showWait: false)
        
    }

    // MARK: - 6、其他
    

}
