//
//  JYLoginViewController.swift
//  alliance
//
//  Created by jackyshan on 2017/12/26.
//  Copyright © 2017年 GCI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class JYLoginViewController: JYBaseViewController {

    // MARK: - 1、属性
    @IBOutlet weak var phoneFd: UITextField!
    @IBOutlet weak var verifyPasswdFd: UITextField!
    @IBOutlet weak var verifyBtn: VerifyCodeBtn!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetPasswdBtn: UIButton!
    @IBOutlet weak var verifyPasswdImgV: UIImageView!
    @IBOutlet weak var jySegmentDayNightView: JYSegmentDayNightView!
    
    let isPasswdLoginSeg: Variable<Bool> = Variable(true)
    
    // MARK: - 2、生命周期
    init() {
        super.init(nibName: "JYLoginViewController", bundle: nil)
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
        self.view.backgroundColor = AppConfig.XXT_LightGray
        self.title = "登录"
        showRightButton("注册")
        showLeftButton()
    }
    
    // MARK: 初始化linstener
    let disposeBag = DisposeBag()
    func initLinstener() {
        Observable.combineLatest(phoneFd.rx.text.orEmpty.asObservable(), verifyPasswdFd.rx.text.orEmpty.asObservable()){ $0.count == 11 && $1.count > 0 }.bind(to: loginBtn.rx.isEnabled).addDisposableTo(disposeBag)
        
        phoneFd.rx.text.orEmpty.asObservable().distinctUntilChanged().map({ $0.count == 11 }).bind(to: verifyBtn.rx.isEnabled).addDisposableTo(disposeBag)
        isPasswdLoginSeg.asObservable().bind(to: verifyBtn.rx.isHidden).addDisposableTo(disposeBag)
        isPasswdLoginSeg.asObservable().map({!$0}).bind(to: forgetPasswdBtn.rx.isHidden).addDisposableTo(disposeBag)
        
        isPasswdLoginSeg.asObservable().subscribe(onNext: { [weak self] (isPasswd) in
            self?.verifyPasswdImgV.image = isPasswd ? #imageLiteral(resourceName: "passwd_login") : #imageLiteral(resourceName: "verifycode_login")
            self?.verifyPasswdFd.placeholder = isPasswd ? "请输入密码" : "请输入验证码"
            self?.verifyPasswdFd.keyboardType = isPasswd ? .default : .numberPad
            self?.verifyPasswdFd.isSecureTextEntry = isPasswd
        }).addDisposableTo(disposeBag)
        
        jySegmentDayNightView.clickDayNightBlock = { [weak self] idx in
            self?.verifyPasswdFd.text = ""
            self?.verifyPasswdFd.sendActions(for: .valueChanged)
            self?.isPasswdLoginSeg.value = idx == 0
            self?.verifyPasswdFd.resignFirstResponder()
        }
        
    }
    
    // MARK: 初始化data
    func initData() {
    }
    
    // MARK: 设置frame
    override func didSystemAutoLayoutComplete() {
    }
    
    // MARK: - 3、代理
    
    // MARK: - 4、业务
    override func clickLeftAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func clickRightAction() {
        let vc = JYRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickForgetPasswdAction() {
        let vc = JYForgetPasswdViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickVerifyAction() {
        verifyBtn.startTimer()
        getAuthCodeData()
    }
    
    @IBAction func clickLoginAction() {
        loginReqData(isPasswdLoginSeg.value)
    }

    // MARK: - 5、网络
    func getAuthCodeData() {
        let send = JYUserAuthCodeSendModel()
        send.mobile = phoneFd.text!
        send.type = 0
        
        JYUserNetwork.This.doTask(JYUserNetwork.CMD_authCode, data: send, controller: nil, success: { _ in
        }, error: nil, com: nil, showWait: false)
    }

    func loginReqData(_ isByPasswd: Bool) {
        let send = JYUserLoginSendModel()
        send.mobile = phoneFd.text!
        let passwd = DES3Util.encryptUseDES(verifyPasswdFd.text!, key: AppConfig.desKey)
        isByPasswd ? (send.pwd = passwd!) : (send.authCode = verifyPasswdFd.text!)
        
        JYUserNetwork.This.doTask(JYUserNetwork.CMD_login, data: send, controller: nil, success: { [weak self] (response: JYUserResponseModel?) in
            guard let data = response else {return}
            guard let djson = data.toJSON() else {return}
            
            AuthManager.shared.sendLogin(djson)
            self?.dismiss(animated: true, completion: nil)
            }, error: { [weak self] (_, errMsg) in
                self?.noticeAutoError(errMsg)
            }, com: nil, showWait: false)
        
    }

    // MARK: - 6、其他
    

}
