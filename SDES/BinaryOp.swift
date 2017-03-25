//
//  BinaryOp.swift
//  SDES
//
//  Created by Michel Kansou on 24/03/2017.
//  Copyright © 2017 Michel Kansou. All rights reserved.
//

import Foundation


final class BinaryOp {
    
    /** Gets binary digits as arguments & returns decimal number
     for example input args [1,0,0] will return 4 **/
    
    public static func BinToDec(bits: Int...) -> Int {
        var temp : Int = 0
        var base : Int = 1
        
        for i in (0...bits.count-1).reversed() {
            temp = temp + (bits[i]*base)
            base = base * 2
        }
        
        return temp
    }
    
    /** gets decimal number as argument and returns array of binary bits
     for example input arg [10] will return  [1,0,1,0]**/
    public static func DecToBinArr(decimalNumber: Int) -> [Int] {
        // 13 1
        // 6  0
        // 3  1
        // 1  1
        // 0
    
        var decimalNumber = decimalNumber
        
        if(decimalNumber==0) {
            return [Int](repeating: 0, count: 2)
        }
        
        var temp = [Int](repeating: 0, count: 10)
        var count: Int = 0
        
        for i in (0...decimalNumber).reversed() where (decimalNumber != 0) {
            temp[i] = decimalNumber % 2
            decimalNumber = decimalNumber/2
            count += 1
        }
        
        var temp2 = [Int](repeating: 0, count: count)
        
        //for(int i=count-1, j=0;i>=0 && j<count;i--,j++)
        for i in (0..<(count-1)).reversed() {
            for j in 0..<count {
                temp2[j] = temp[i]
            }
        }
    
        //because we requires 2-bits as output .. so for adding leading 0
        if(count<2)
        {
            temp = [Int](repeating: 0, count: 2)
            temp[0] = 0
            temp[1] = temp2[0]
            return temp
        }
    
        return temp2
    }
}
