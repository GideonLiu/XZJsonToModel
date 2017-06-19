//
//  XZObject.swift
//  jsonToModelDemo
//
//  Created by Gideon on 2017/6/19.
//  Copyright © 2017年 Gideon. All rights reserved.
//

import Foundation

extension NSObject{
    
    func initializeWithDictionary(_ item:NSDictionary?){
        if item == nil {return}
        let mirror = Mirror(reflecting: self)
        for case let (label,_) in mirror.children{
            //            if item![label!] != nil{
            //                let mi = Mirror(reflecting: item![label!]!)
            //                if mi.subjectType == NSNull.classForCoder() {
            //                    self.setValue("", forKey: label!)
            //                }else{
            //                    self.setValue(item![label!]!, forKey: label!)
            //                }
            //            }
            
            let dArray = self.xz_dict().keys
            let aArray = self.xz_array().keys
            let sArray = self.xz_string().keys
            if dArray.contains(label!) {
                let dic = self.xz_dict()
                let name = dic[label!]
                let newItemClass = XZClassFromName(name!)as! NSObject.Type
                let newItem = newItemClass.init()
                let newDic = item![label!]! as! NSDictionary
                newItem.initializeWithDictionary(newDic as NSDictionary?)
            }else if aArray.contains(label!){
                let dic = self.xz_array()
                let name = dic[label!]
                let newItemClass = XZClassFromName(name!)as! NSObject.Type
                let newArray = item![label!]! as! NSArray
                var a = [AnyObject]()
                for newD in newArray {
                    let newItem = newItemClass.init()
                    let newDic = newD as! NSDictionary
                    newItem.initializeWithDictionary(newDic as NSDictionary?)
                    a.append(newItem)
                }
                self.setValue(a, forKey: label!)
            }else if sArray.contains(label!){
                let dic = self.xz_string()
                let name = dic[label!]
                if name != nil && item![name!] != nil{
                    let mi = Mirror(reflecting: item![name!]!)
                    if mi.subjectType == NSNull.classForCoder() {
                        self.setValue("", forKey: label!)
                    }else{
                        self.setValue(item![name!]!, forKey: label!)
                    }
                }
            }else{
                if item![label!] != nil{
                    let mi = Mirror(reflecting: item![label!]!)
                    if mi.subjectType == NSNull.classForCoder() {
                        self.setValue("", forKey: label!)
                    }else{
                        self.setValue(item![label!]!, forKey: label!)
                    }
                }
            }
        }
    }
    
    
    func xz_dict() -> [String:String] {
        return [:]
    }
    
    func xz_array() -> [String:String] {
        return [:]
    }
    
    func xz_string() -> [String:String] {
        return [:]
    }
}

func XZClassFromName(_ className : String) -> AnyClass{
    let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String + "." + className//vip_student.XZBaseViewController 类似这样
    let type:AnyClass = NSClassFromString(name)!
    return type
}

