//
//  LoginViewController.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/9.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var viewSocialBtns: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassw: UITextField!
    @IBOutlet weak var imageViewUserPhoto: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    var buttonSelected: OSSocialButton?
    
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
        imageViewUserPhoto.layer.borderColor = UIColor.white.cgColor
        imageViewUserPhoto.layer.borderWidth = 2
        imageViewUserPhoto.layer.cornerRadius = imageViewUserPhoto.bounds.size.height / 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buttonLogin.animationCircular(directionShow: true)
        viewSocialBtns.animationMoveUp(false, andHide: true)
    }
    
    //MARK: - IBActions
    
    func endEditing() {
        if (buttonSelected != nil) {
            expandSocialButton(buttonSelected!)
            buttonSelected = nil
        } else {
            buttonLogin.animationCircular(directionShow: false)
            viewSocialBtns.animationMoveUp(false, andHide: false)
            self.view.endEditing(true)
        }
    }
    
    @IBAction func useSocial(_ sender: OSSocialButton) {
        if sender.expanded {
            //Do Sign In
            switch sender.tag {
            case 101:
                print("fb")
            case 102:
                print("tw")
            case 103:
                print("q+")
            default:
                print("setup tags in Social buttons")
            }
        }else{
            //expand
            buttonSelected = sender
            expandSocialButton(sender)
        }
    }
    
    //MARK: - Animation logic
    
    func expandSocialButton(_ button: OSSocialButton) {
        let willBeginExpanding = !button.expanded
        button.expand()
        
        //animated hide/show other social btns
        var btnsWillBeHidden = Set(button.superview!.subviews)
        btnsWillBeHidden.remove(button)
        for  btn in btnsWillBeHidden{
            btn.animationFade(directionFade: willBeginExpanding)
        }
        
        //animated move and hide/show textFields
        for  textField in [textFieldEmail, textFieldPassw]{
            textField?.animationMoveUp(true, andHide: willBeginExpanding)
        }
        
        //animated show/hide user profile info
        imageViewUserPhoto.animationCircular(directionShow: willBeginExpanding, startTop: false)
        labelUserName.animationCircular(directionShow: willBeginExpanding, startTop: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
