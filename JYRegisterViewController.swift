//
//  JYRegisterViewController.swift
//  alliance
//
//  Created by jackyshan on 2017/12/26.
//  Copyright © 2017年 GCI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class JYRegisterViewController: JYBaseViewController {

    // MARK: - 1、属性
    @IBOutlet weak var phoneFd: UITextField!
    @IBOutlet weak var verifyFd: UITextField!
    @IBOutlet weak var passwdFd: UITextField!

    @IBOutlet weak var verifyBtn: VerifyCodeBtn!
    @IBOutlet weak var registerBtn: UIButton!

    // MARK: - 2、生命周期
    init() {
        super.init(nibName: "JYRegisterViewController", bundle: nil)
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
        self.title = "注册"
        
    }
    
    // MARK: 初始化linstener
    let disposeBag = DisposeBag()
    func initLinstener() {
        Observable.combineLatest(phoneFd.rx.text.orEmpty.asObservable(), verifyFd.rx.text.orEmpty.asObservable(), passwdFd.rx.text.orEmpty.asObservable()){ $0.count == 11 && $1.count > 0 && ($2.count >= 6 && $2.count <= 14) }.bind(to: registerBtn.rx.isEnabled).addDisposableTo(disposeBag)
        
        phoneFd.rx.text.orEmpty.asObservable().distinctUntilChanged().map({ $0.count == 11 }).bind(to: verifyBtn.rx.isEnabled).addDisposableTo(disposeBag)

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
    
    @IBAction func clickRegisterAction() {
        registerData()
    }
    
    @IBAction func clickAgreementAction() {
        let vc = JYWebViewController()
        vc.localUrl = "agreement"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 5、网络
    func getAuthCodeData() {
        let send = JYUserAuthCodeSendModel()
        send.mobile = phoneFd.text!
        send.type = 1
        
        JYUserNetwork.This.doTask(JYUserNetwork.CMD_authCode, data: send, controller: nil, success: { _ in
        }, error: nil, com: nil, showWait: false)
    }
    
    func registerData() {
        let send = JYUserRegisterSendModel()
        send.mobile = phoneFd.text!
        send.authCode = verifyFd.text!
        let passwd = DES3Util.encryptUseDES(passwdFd.text!, key: AppConfig.desKey)
        send.pwd = passwd!
        
        JYUserNetwork.This.doTask(JYUserNetwork.CMD_register, data: send, controller: nil, success: { [weak self] (response: JYUserResponseModel?) in
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
