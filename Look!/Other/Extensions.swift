//
//  Extensions.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/3/21.
//  Copyright © 2018年 Larry. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor 扩展
extension UIColor {
    public convenience init(hexValue:Int,alpha:Float){
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16)/255.0, green: CGFloat((hexValue & 0xFF00) >> 8)/255.0, blue: CGFloat(hexValue & 0xFF)/255.0, alpha: CGFloat(alpha))
    }
    
    public convenience init(hexValue:Int){
        self.init(hexValue:hexValue,alpha:1.0)
    }
    
    public convenience init(hexString:String,alpha:Float){
        var newHexString = hexString
        newHexString = newHexString.replace("#", withString: "0x")
        let hexValue = Int(strtoul(newHexString, nil, 0))
        self.init(hexValue:hexValue,alpha:alpha)
    }
    
    public convenience init(hexString:String){
        self.init(hexString:hexString,alpha:1.0)
    }
}

// MARK: - String扩展
extension String{
    
    // MARK: - 基础扩展
    public init(data:Data){
        let str:NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        self.init(str)
    }
    
    public var nsstring:NSString{
        return self as NSString
    }
    
    public var length:Int{
        return self.count
    }
    
    public func replace(_ target:String,withString:String) -> String{
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    public func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public func trimEnd(_ string:String? = nil) -> String{
        var newString = " "
        if let str = string {
            newString = str
        }
        let count = newString.count
        let index = self.characters.index(self.endIndex, offsetBy: -count)
        let lastStr = self.substring(from: index)
        if lastStr == newString {
            return self.substring(to: index).trimEnd(string)
        }
        return self
    }
    
    public func trimStart(_ string:String? = nil) -> String{
        if self.length == 0 {
            return self
        }
        var newString = " "
        if let str = string {
            newString = str
        }
        let count = newString.characters.count
        let index = self.characters.index(self.startIndex, offsetBy: count)
        let firstStr = self.substring(to: index)
        if firstStr == newString {
            return self.substring(from: index).trimStart(string)
        }
        return self
    }
    
    public func dropLast() -> String {
        return self.substring(to: self.index(before: self.endIndex))
    }
    
    public func split(_ seperator:String) -> [String] {
        return self.characters.split {String($0) == seperator}.map { String($0) }
    }
    
    public func splitFromFirst(seperator:String) -> [String] {
        return self.characters.split(maxSplits: 1, omittingEmptySubsequences: false, whereSeparator: { (c) -> Bool in
            String(c) == seperator
        }).map(String.init)
    }
    
    public func substring(_ start:Int,length:Int) -> String {
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: length)
        let range = startIndex..<endIndex
        return self.substring(with: range)
    }
    public func substring(_ start:Int,end:Int) -> String {
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: end+1)
        let range = startIndex..<endIndex
        return self.substring(with: range)
    }
    public func laststring(_ length:Int) -> String {
        let startIndex = self.characters.index(self.endIndex, offsetBy: -length)
        let endIndex = self.endIndex
        let range = startIndex..<endIndex
        return self.substring(with: range)
    }
    
    /**
     获取从某个字符串后的子串（不包含当前字符串）
     
     - parameter string: 查找字符串之后的子串
     */
    public func substringFromString(_ aString:String) -> String?{
        if let range = self.range(of: aString) {
            return self.substring(from: range.upperBound)
        }
        return nil
    }
    /**
     获取从开始到第一个查找的字串中的字符串（不包含当前字符串）
     
     - parameter aString: 查找字符串之后的子串
     
     - returns: 子串
     */
    public func substringToString(_ aString:String) -> String?{
        if let range = self.range(of: aString) {
            return self.substring(to: range.lowerBound)
        }
        return nil
    }
    
    /**
     十六进制字符串转化为整形
     
     - returns: 整形数据
     */
    public func hexStringToInt() -> Int{
        return Int(strtoul(self, nil, 16))
    }
    
    /**
     二进制字符串转化为整形
     
     - returns: 整形数据
     */
    public func binaryStringToInt() -> Int{
        return Int(strtoul(self, nil, 2))
    }
    /**
     单行文本尺寸计算
     
     - parameter font: 字体
     
     - returns: 文本尺寸
     */
    public func sizeWithSystemFont(_ font:UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font:font])
    }
    /**
     单行文本尺寸计算
     
     - parameter fontSize: 字体大小
     
     - returns: 文本尺寸
     */
    public func sizeWithSystemFontSize(_ fontSize:CGFloat) -> CGSize {
        return self.sizeWithSystemFont(UIFont.systemFont(ofSize: fontSize))
    }
    
    /**
     计算文本高度
     
     - parameter width: 文本宽度
     - parameter font:  字体
     
     - returns: 文本高度
     */
    public func heightWithWidth(_ width:CGFloat,font:UIFont) -> CGFloat{
        let size = (self as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil)
        return size.height
    }
    
    /**
     计算文本高度
     
     - parameter width:    文本宽度
     - parameter fontSize: 字体大小
     
     - returns: 文本高度
     */
    public func heightWithWidth(_ width:CGFloat,fontSize:CGFloat) -> CGFloat{
        return self.heightWithWidth(width, font: UIFont.systemFont(ofSize: fontSize))
    }
    
    public func toData() -> Data? {
        return self.data(using: String.Encoding.utf8)
    }
    
    // MARK: - 字符串和JSON对象相互转化
    /**
     将JSON字符串转化为JSON对象（字典或数组）
     
     - returns: JSON对象
     */
    public func toJSONObject() -> Any?{
        let jsonData = self.data(using: String.Encoding.utf8)
        var object:Any? = nil
        if let jd = jsonData {
            do {
                object = try  JSONSerialization.jsonObject(with: jd, options: .mutableContainers)
            } catch let error as NSError{
                print("将JSON字符串转化为JSON对象过程中发生错误,错误详情:%@",error.description);
            }
            return object
        }else{
            return object
        }
    }
    
    /**
     将JSON字符串转化为数组
     
     - returns: 数组对象
     */
    public func toJsonArray() -> Array<Any>?{
        return self.toJSONObject() as? Array<Any>
    }
    
    /**
     将JSON字符串转化为字典
     
     - returns: 字典对象
     */
    public func toJsonDictionary() -> Dictionary<String,Any>?{
        return self.toJSONObject() as? Dictionary<String,Any>
    }
    
    /**
     字符串转化为布尔类型
     
     - returns: Bool值
     */
    public func toBool() -> Bool? {
        if self == "true" {
            return true
        } else if self == "false" {
            return false
        }
        return nil
    }
    
    public func decodeFromBase64() ->String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) else { return nil }
        let str = String(data: data, encoding: String.Encoding.utf8)
        return str
    }
}

// 生成二维码
public extension String {
    
    func toQRImage() -> UIImage? {
        let data = self.toData()
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let ciImage = filter?.outputImage else { return nil }
        return UIImage(ciImage: ciImage)
    }
}

// MARK: - 扩展String可选类型
public protocol PossiblyEmpty {
    var isEmpty: Bool { get }
}
extension String: PossiblyEmpty {}
extension Optional where Wrapped: PossiblyEmpty {
    public var isEmpty: Bool {
        switch self {
        case .none: return true
        case .some(let value): return value.isEmpty
        }
    }
}
