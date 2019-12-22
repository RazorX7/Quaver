//
//  SignUpViewController.swift
//  Quaver
//
//  Created by apple on 2019/12/11.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


//注册本地用户界面
class SignUpViewController: UIViewController {
    
//标志是否注册s成功
   var signUpFlag = false
    
    //关联注册用户名的textView
    @IBOutlet weak var textName: UITextView!
    
    //关联注册登录密码的textView
    @IBOutlet weak var textPassword: UITextView!
    
    //关联注册登录确认密码的textView
    @IBOutlet weak var textConfirmPW: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //关联确认按钮
    @IBAction func signUP(_ sender: Any) {
        if let name = textName.text{
            if name != ""{
            //当输入用户名不为空时
                if UserDefaults.standard.getCustomObject(forKey: name) != nil{
                    //从本地判断是否有以该用户名为节点的存储信息
                    //当存在时，弹窗提醒
                    print("name is already exit.")
                    let alertController = UIAlertController(title: "提示", message: "名字已存在",preferredStyle: .alert)
                    let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                    alertController.addAction(cancelAction1)
                    self.present(alertController, animated: true, completion: nil)
                    signUpFlag = false
                }else{
                    if let passWord = textPassword.text{
                        if passWord != ""{
                            if let confirmPW = textConfirmPW.text{
                                if confirmPW != ""{
                                    if passWord == confirmPW{
                                        //密码，用户名都没有问题
                                        //注册成功
                                        print("sign up successfully")
                                        let user = UserInfo(name: name, password: passWord)
                                        //
                                    UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                                        UserDefaults.standard.synchronize()
                                        
                                        signUpFlag = true
                                    }else{
                                        //两次输入密码不一致，弹窗提醒
                                        signUpFlag = false
                                        print("密码不一致")
                                        let alertController = UIAlertController(title: "提示", message: "密码不一致",preferredStyle: .alert)
                                        let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                                        alertController.addAction(cancelAction1)
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                }else{
                                    //确认密码为空，弹窗提醒
                                    signUpFlag = false
                                    print("确认密码为空")
                                    let alertController = UIAlertController(title: "提示", message: "确认密码为空！",preferredStyle: .alert)
                                    let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                                    alertController.addAction(cancelAction1)
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                }
                            }
                        }else{
                            
                            //密码栏为空，弹窗提醒
                            signUpFlag = false
                            print("密码为空")
                            let alertController = UIAlertController(title: "提示", message: "密码为空！",preferredStyle: .alert)
                            let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                            alertController.addAction(cancelAction1)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    }
                }
            }else{
                //用户名输入框为空
                //弹窗用户名为空的提醒
                signUpFlag = false
                print("name为空")
                let alertController = UIAlertController(title: "提示", message: "用户名为空！",preferredStyle: .alert)
                let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
                alertController.addAction(cancelAction1)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        //注册不成功
        if signUpFlag == false{
            return
        }
        
        //页面跳转，注册成功
        self.performSegue(withIdentifier: "signUpSuccessfully", sender: self)
        let alertController = UIAlertController(title: "提示", message: "创建成功",preferredStyle: .alert)
        let cancelAction1 = UIAlertAction(title: "确定", style: .destructive, handler: nil)
        alertController.addAction(cancelAction1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //该函数的作用是：输入栏 键盘的取消
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        textName.resignFirstResponder()
        textPassword.resignFirstResponder()
        textConfirmPW.resignFirstResponder()
    }
    
    
    //取消回到菜单界面
    @IBAction func signUpCancel(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSuccessfully", sender: self)
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


