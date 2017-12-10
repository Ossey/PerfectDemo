//
//  LoginViewController.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/9.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit

enum LoginViewControllerPageType {
    case Login
    case Register
    
    public func description() -> String {
        switch self {
        case .Login:
            return "登录"
        case .Register:
            return "注册"
        }
    }
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var viewSocialBtns: UIView!
    @IBOutlet weak var accountNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    
    // 记录选中的按钮
    var buttonSelected: OSSocialButton?
    var pageType: LoginViewControllerPageType = .Login
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        var nibName = String?("LoginViewController")
        
        if Bundle.main.path(forResource: nibName, ofType: "storyboard") == nil {
            nibName = nil
        }
        self.init(nibName: nibName, bundle: Bundle.main)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() -> Void {
        userIconView.layer.borderColor = UIColor.white.cgColor
        userIconView.layer.borderWidth = 2
        userIconView.layer.cornerRadius = userIconView.bounds.size.height / 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        
        buttonLogin .setTitle(pageType.description(), for: .normal)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buttonLogin.animationCircular(directionShow: true)
        viewSocialBtns.animationMoveUp(false, andHide: true)
    }
    
    //MARK: - IBActions
    
    @objc func endEditing() {
        if (buttonSelected != nil) {
            expandSocialButton(buttonSelected!)
            buttonSelected = nil
        } else {
            buttonLogin.animationCircular(directionShow: false)
            viewSocialBtns.animationMoveUp(false, andHide: false)
            self.view.endEditing(true)
        }
    }
    
    @IBAction func doAuthorizedLogin(_ sender: OSSocialButton) {
        if sender.expanded {
            // 执行授权登录
            switch sender.tag {
            case 101:
                print("momo")
            case 102:
                print("momo1")
            case 103:
                print("wchat")
            default:
                print("未设置tag")
            }
        }else{
            //expand
            buttonSelected = sender
            expandSocialButton(sender)
        }
    }
   
    @IBAction func doLoginOrRegister(_ sender: UIButton) {
        switch pageType {
        case .Login:
            doLogin()
        case .Register:
            doRegister()
        }
    }
    
    func doLogin() -> Void {
        print("登录")
        UserInfoAPI.shared.requestUserInfo(accountName: "k8882") { (user, error) in
            print(error)
        }
    }
    
    func doRegister() -> Void {
        print("注册")
    }
    
    
    //MARK: - 处理动画的逻辑
    
    func expandSocialButton(_ button: OSSocialButton) {
        let willBeginExpanding = !button.expanded
        button.expand()
        
        //animated hide/show other social btns
        var btnsWillBeHidden = Set(button.superview!.subviews)
        btnsWillBeHidden.remove(button)
        for  btn in btnsWillBeHidden{
            btn.animationFade(directionFade: willBeginExpanding)
        }
        
        // 动画移动和隐藏/显示文本框
        for  textField in [accountNameTF, passwordTF]{
            textField?.animationMoveUp(true, andHide: willBeginExpanding)
        }
        
        //动画显示/隐藏用户信息
        userIconView.animationCircular(directionShow: willBeginExpanding, startTop: false)
        labelUserName.animationCircular(directionShow: willBeginExpanding, startTop: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
