//
//  main.swift
//  SDES
//
//  Created by Michel Kansou on 24/03/2017.
//  Copyright © 2017 Michel Kansou. All rights reserved.
//

import Foundation

var keyGeneration = KeyGeneration()
var encryption = Encryption()
var ct = [Int](repeating: 0, count: 8)

do {
    //Ex Input : 10101010
    print("Enter 8-bit Plaintext : ")
    let plainText = readLine()
    print(" \n ")
    
    //Ex Input : 1010000010
    print("Enter 10-bit Key : ")
    let key = readLine()
    print(" \n ")
    
    print("\n Key Generation ...\n")
    print("\n---------------------------------------\n")
    keyGeneration.GenerateKeys(inputKey: key!)
    print("\n---------------------------------------\n")
    ct = encryption.encrypt(plaintext: plainText!, LK: keyGeneration.getK1(), RK: keyGeneration.getK2())
    print("\n---------------------------------------\n")
    
    print(" \n Decryption  ")
    
    //Enter decrypted message
    print("Enter 8-bit Ciphertext : ")
    let decryptedPlainText = readLine()
    print(" \n ")
    
    //Enter key to decrypte message ex Input : 1010000010
    print("Enter 10-bit Key : ")
    let decryptionKey = readLine()
    
    print(" \n ")

    print("\n Key Generation ...\n")
    print("\n---------------------------------------\n")
    print("\n For decryption Two Sub-keys will be used in reverse order \n")
    print("\n---------------------------------------\n\n")
    keyGeneration.GenerateKeys(inputKey: decryptionKey!)
    print("\n---------------------------------------\n")
    
    ct = encryption.encrypt(plaintext: decryptedPlainText!, LK: keyGeneration.getK2(), RK: keyGeneration.getK1())
    
    print("\n---------------------------------------\n")
} catch {
    print("-- Error Occured : Invalid Input ")
}


