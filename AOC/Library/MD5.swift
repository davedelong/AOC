//
//  MD5.swift
//  AOC
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension String {
    
    public func md5() -> Data {
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        writeMD5(&digestData)
        return digestData
    }
    
    public func writeMD5(_ destination: inout Data) {
        let messageData = data(using:.utf8)!
        
        _ = destination.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
    }
    
    public func md5String() -> String {
        let data = md5()
        return data.map { String(format: "%02hhx", arguments: [$0]) }.joined()
    }
    
}
