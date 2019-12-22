//
//  UserInfo.swift
//  Quaver
//
//  Created by naive on 2019/12/23.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

class UserInfo:NSObject, NSCoding{
    struct ProperKey{
        static let UserName = "userName"
        static let Password = "password"
        static let SoundStage1 = "soundStage1"
        static let SoundStage2 = "soundStage2"
        static let SoundStage3 = "soundStage3"
        static let SoundStage4 = "soundStage4"
        static let TouchStage1 = "touchStage1"
        static let TouchStage2 = "touchStage2"
        static let TouchStage3 = "touchStage3"
        static let TouchStage4 = "touchStage4"
    }
    
    //用户名
    var userName :String?
    //用户密码
    var password :String?
    
    //以下八个为用户是否通过这八个关卡
    var soundStage1 :Bool?
    var soundStage2 :Bool?
    var soundStage3 :Bool?
    var soundStage4 :Bool?
    var touchStage1 :Bool?
    var touchStage2 :Bool?
    var touchStage3 :Bool?
    var touchStage4 :Bool?
    
    
    //编码
    func encode(with coder: NSCoder) {
        coder.encode(userName, forKey: ProperKey.UserName)
        coder.encode(password, forKey: ProperKey.Password)
        coder.encode(soundStage1, forKey: ProperKey.SoundStage1)
        coder.encode(soundStage2, forKey: ProperKey.SoundStage2)
        coder.encode(soundStage3, forKey: ProperKey.SoundStage3)
        coder.encode(soundStage4, forKey: ProperKey.SoundStage4)
        
        coder.encode(touchStage1, forKey: ProperKey.TouchStage1)
        coder.encode(touchStage2, forKey: ProperKey.TouchStage2)

        coder.encode(touchStage3, forKey: ProperKey.TouchStage3)

        coder.encode(touchStage4, forKey: ProperKey.TouchStage4)

        
    }
    
    
    //取出对象的时候，解码取出
    required init?(coder: NSCoder) {
        userName = coder.decodeObject(forKey: ProperKey.UserName) as? String
        password = coder.decodeObject(forKey: ProperKey.Password) as? String
        soundStage1 = coder.decodeObject(forKey: ProperKey.SoundStage1) as? Bool
        soundStage2 = coder.decodeObject(forKey: ProperKey.SoundStage2) as? Bool
        soundStage3 = coder.decodeObject(forKey: ProperKey.SoundStage3) as? Bool
        soundStage4 = coder.decodeObject(forKey: ProperKey.SoundStage4) as? Bool
        
        touchStage1 = coder.decodeObject(forKey: ProperKey.TouchStage1) as? Bool
        touchStage2 = coder.decodeObject(forKey: ProperKey.TouchStage2) as? Bool
        touchStage3 = coder.decodeObject(forKey: ProperKey.TouchStage3) as? Bool
        touchStage4 = coder.decodeObject(forKey: ProperKey.TouchStage4) as? Bool
    }
    
    
    //初始化用户账号和密码
    //初始化用户对所有关卡的通过都是false
    
    
    required init(name:String,password:String) {
        self.userName = name
        self.password = password
        self.soundStage1 = false
        self.soundStage2 = false
        self.soundStage3 = false
        self.soundStage4 = false
        
        self.touchStage1 = false
        self.touchStage2 = false
        self.touchStage3 = false
        self.touchStage4 = false
    }
}


//为了实验中对象的存储，上述对象的存储
extension UserDefaults { //1
    
    //存对象
    func saveCustomObject(customObject object: NSCoding, key: String) { //2
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        self.set(encodedObject, forKey: key)
        self.synchronize()
    }
 
    //取出对象
    func getCustomObject(forKey key: String) -> AnyObject? { //3
        let decodedObject = self.object(forKey: key) as? NSData
 
        if let decoded = decodedObject {
            let object = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data)
            return object as AnyObject?
        }
        return nil
    }
}
