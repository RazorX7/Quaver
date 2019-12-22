//
//  SignInViewController.swift
//  Quaver
//
//  Created by naive on 2019/12/11.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    //标志是否登录成功
    var signInFlag = false
    
    //关联登录用户名的textView
    @IBOutlet weak var signInName: UITextView!
    
    //关联登录密码的textView
    @IBOutlet weak var signInPassword: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //关联确认按钮
    @IBAction func signInConfirm(_ sender: Any) {
        // Do any additional setup after loading the view.
        if let name = signInName.text{
            if name != ""{
                //当输入用户名不为空时
                if let user = UserDefaults.standard.getCustomObject(forKey: name) as? UserInfo{
                    //从本地判断是否有以该用户名为节点的存储信息
                    //当存在时，需要判断密码是否正确
                    print("name is exit.")
                    if let passWord = signInPassword.text{
                        if passWord != ""{
                            if passWord == user.password{
                                //密码匹配上了
                                signInFlag = true
                                print("sign in successfully！")
                                print("登录成功！")
                                //全局变量设置：
                                //非游客登录
                                isVisitor = false
                                //玩家用户设置
                                userGaming = user
                                //8个关卡flag设置
                                soundstage_flagone = user.soundStage1!
                                soundstage_flagtwo = user.soundStage2!
                                soundstage_flagthree = user.soundStage3!
                                soundstage_flagfour = user.soundStage4!
                                touchstage_flagone = user.touchStage1!
                                touchstage_flagtwo = user.touchStage2!
                                touchstage_flagthree = user.touchStage3!
                                touchstage_flagfour = user.touchStage4!
                                
                            }else{
                                //密码不匹配，弹窗密码不正确
                                signInFlag = false
                                print("密码不正确")
                                let alertController = UIAlertController(title: "提示", message: "密码不正确！",preferredStyle: .alert)
                                let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                                alertController.addAction(cancelAction1)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }else{
                            signInFlag = false
                            print("密码为空")
                            //密码栏为空，弹窗提醒
                            let alertController = UIAlertController(title: "提示", message: "密码为空！",preferredStyle: .alert)
                            let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                            alertController.addAction(cancelAction1)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    }
                    
                }else{
                    //本地匹配失败，不存在那样的节点
                    //弹窗名字不存在
                    signInFlag = false
                    print("名字不存在")
                    let alertController = UIAlertController(title: "提示", message: "名字不存在",preferredStyle: .alert)
                    let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                    alertController.addAction(cancelAction1)
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                //用户名输入框为空
                //弹窗用户名为空的提醒
                print("name为空")
                signInFlag = false
                let alertController = UIAlertController(title: "提示", message: "用户名为空！",preferredStyle: .alert)
                let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                alertController.addAction(cancelAction1)
                self.present(alertController, animated: true, completion: nil)
            }
        }else{
            signInFlag = false
        }
        
        //登录失败
        if signInFlag == false {
            return
        }
        
        print("sdasdas")
        //页面跳转，登录成功
        self.performSegue(withIdentifier: "signInSuccessfully", sender: self)
        
        let alertController = UIAlertController(title: "提示", message: "登录成功！",preferredStyle: .alert)
        let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
        alertController.addAction(cancelAction1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //该函数的作用是：输入栏 键盘的取消
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        signInName.resignFirstResponder()
        signInPassword.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
