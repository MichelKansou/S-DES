//
//  KeyGeneration.swift
//  SDES
//
//  Created by Michel Kansou on 24/03/2017.
//  Copyright © 2017 Michel Kansou. All rights reserved.
//

import Foundation

final class KeyGeneration {
    private var key = [Int](repeating: 0, count: 10)
    private var k1 = [Int](repeating: 0, count: 8)
    private var k2 = [Int](repeating: 0, count: 8)
    private var flag : Bool = false
    
    func GenerateKeys(inputKey: String) -> Void {
        var key = [Int](repeating: 0, count: 10)
        let characters = Array(inputKey.characters)

        do {
            let result = try analyseInput(characters: characters, key: key)
            key = result
        } catch {
            print("\n .. Invalid Key ..")
            exit(0)
        }
        self.key = key
        
        print("Input Key : ")
        print(self.key)
        print("\n")
        
        permutationP10()
        
        print("After Permutation(P10) Key : ")
        print(self.key)
        print("\n")
        
        leftshiftLS1()
        
        print("After LeftShift LS-1 Key : ")
        print(self.key)
        print("\n")
        
        
        self.k1 = permutationP8()
        
        print("Subkey K1 Generated : ")
        print(self.k1)
        print("\n")
        
        leftshiftLS2()
        
        print("After LeftShift LS-2 Key : ")
        print(self.key)
        print("\n")
        
        self.k2 = permutationP8()
        print("Subkey K2 Generated : ")
        print(self.k2)
        print("\n")
        
        flag = true
    }
    
    func analyseInput(characters: [Character], key: [Int]) throws -> [Int] {
        var c1 : Character
        var ts : String
        var key = key
        for i in 0 ... 9
        {

            c1 = characters[i]
            ts = String(describing: c1) // problem
            key[i] = Int(ts)! //else { print("key not readable") }
            if (key[i] != 0 && key[i] != 1) {
                print("\n .. Invalid Key ..")
                exit(0)
            }
        }
        
        print("Generated Key : ", key)
        
        return key
    }
    
    /** Perform permutation P10 on 10-bit key
     P10(k1, k2, k3, k4, k5, k6, k7, k8, k9, k10) = (k3, k5, k2, k7, k4, k10, k1, k9, k8, k6)
     **/
    
    private func permutationP10() -> Void {
        var temp = [Int](repeating: 0, count: 10)
    
        temp[0] = self.key[2]
        temp[1] = self.key[4]
        temp[2] = self.key[1]
        temp[3] = self.key[6]
        temp[4] = self.key[3]
        temp[5] = self.key[9]
        temp[6] = self.key[0]
        temp[7] = self.key[8]
        temp[8] = self.key[7]
        temp[9] = self.key[5]
    
        self.key = temp
    }
    
    /** Performs a circular left shift (LS-1), or rotation, separately on the first
     five bits and the second five bits. **/
    
    private func leftshiftLS1() -> Void {
        var temp = [Int](repeating: 0, count: 10)
    
        temp[0] = key[1]
        temp[1] = key[2]
        temp[2] = key[3]
        temp[3] = key[4]
        temp[4] = key[0]
    
        temp[5] = key[6]
        temp[6] = key[7]
        temp[7] = key[8]
        temp[8] = key[9]
        temp[9] = key[5]
    
        key = temp
    }
    
    
    /** apply Permutaion P8, which picks out and permutes 8 of the 10 bits according to the following
     rule: P8[ 6 3 7 4 8 5 10 9 ] , 8-bit subkey is returned **/
    private func permutationP8() -> [Int] {
        var temp = [Int](repeating: 0, count: 8)
    
        temp[0] = key[5]
        temp[1] = key[2]
        temp[2] = key[6]
        temp[3] = key[3]
        temp[4] = key[7]
        temp[5] = key[4]
        temp[6] = key[9]
        temp[7] = key[8]
    
        return temp
    }
    
    private func leftshiftLS2() -> Void{
        var temp = [Int](repeating: 0, count: 10)
    
        temp[0] = key[2]
        temp[1] = key[3]
        temp[2] = key[4]
        temp[3] = key[0]
        temp[4] = key[1]
    
        temp[5] = key[7]
        temp[6] = key[8]
        temp[7] = key[9]
        temp[8] = key[5]
        temp[9] = key[6]
    
        key = temp
    
    }
    
    public func getK1() -> [Int] {
        if(!flag)
        {
            print("\nError Occured: Keys are not generated yet ")
            return [0]
        }
        return k1
    }
    
    public func getK2() -> [Int]{
        if(!flag)
        {
            print("\nError Occured: Keys are not generated yet ")
            return [0]
        }
        return k2
    }
}


