//
//  RHashObject.swift
//  placesapp
//
//  Created by Andy on 10/12/2015.
//  Copyright © 2015 niveusrosea. All rights reserved.
//

import Foundation
import NSHash

//func __hashFromString(string: String) -> String
//{
//    let data = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)
//    assert(data != nil)
//    return __sha256(data!).hexString() as String
//}
//
//func __sha256(data : NSData) -> NSData
//{
//    var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
//    CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
//    let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH))
//    return res
//}

enum RHashObjectError: ErrorType
{
    case CannotGenerateHash
}

public protocol RHashObject
{
    func contentsHash() -> String
}

extension RHashObject
{

    public func hashFromString(string: String) -> String
    {
        return string.SHA256()
    }
    
}

extension NSData
{
    func hexString() -> NSString
    {
        let str = NSMutableString()
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
        for byte in bytes {
            str.appendFormat("%02hhx", byte)
        }
        return str
    }
}

extension CustomStringConvertible
{
    public func contentsHash() -> String
    {
        return description.SHA256()
    }
}

extension Array: RHashObject
{
    
    public func contentsHash() -> String
    {
        var output = ""
        for item in self
        {
            if let item = item as? RHashObject
            {
                output += item.contentsHash()
            }
            else if let item = item as? CustomStringConvertible
            {
                output += item.description
            }
            else
            {
                print("Cannot Hash")
            }
        }
        return hashFromString(output)
    }
    
}

extension Int: RHashObject
{
    public func contentsHash() -> String
    {
        return hashFromString(String(self))
    }
}