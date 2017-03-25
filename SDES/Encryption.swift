//
//  Encryption.swift
//  SDES
//
//  Created by Michel Kansou on 24/03/2017.
//  Copyright © 2017 Michel Kansou. All rights reserved.
//

import Foundation


final class Encryption {
    private var K1 = [Int](repeating: 0, count: 8)
    private var K2 = [Int](repeating: 0, count: 8)
    private var pt = [Int](repeating: 0, count: 8)
    
    func saveParameters(plaintext: String, k1: [Int], k2: [Int]) -> Void {
        var pt = [Int](repeating: 0, count: 8)
        let characters = Array(plaintext.characters)
    
        do {
            let result = try analyseInput(characters: characters, pt: pt)
            pt = result
        } catch {
            print("\n .. Invalid Key ..")
            exit(0)
        }
        self.pt = pt
        
        print("Plaintext array : ")
        print(self.pt)
        print("\n")
        
        self.K1 = k1
        self.K2 = k2
    }
    
    func analyseInput(characters: [Character], pt: [Int]) throws -> [Int] {
        var c1 : Character
        var ts : String
        var pt = pt
        for i in 0 ... 7
        {
            c1 = characters[i]
            ts = String(describing: c1) // problem
            pt[i] = Int(ts)! //else { print("key not readable") }
            if (pt[i] != 0 && pt[i] != 1) {
                print("\n .. Invalid Key ..")
                exit(0)
            }
        }
        
        return pt
    }
    
    /** perform Initial Permutation in following manner [2 6 3 1 4 8 5 7] **/
    func InitialPermutation() -> Void {
        var temp = [Int](repeating: 0, count: 8)
        temp[0] = pt[1]
        temp[1] = pt[5]
        temp[2] = pt[2]
        temp[3] = pt[0]
        temp[4] = pt[3]
        temp[5] = pt[7]
        temp[6] = pt[4]
        temp[7] = pt[6]
    
        pt = temp;
    
        print("Initial Permutaion(IP) : ");
        print(pt);
        print("\n");
    
    }
    
    func InverseInitialPermutation() -> Void {
        var temp = [Int](repeating: 0, count: 8)
    
        temp[0] = pt[3]
        temp[1] = pt[0]
        temp[2] = pt[2]
        temp[3] = pt[4]
        temp[4] = pt[6]
        temp[5] = pt[1]
        temp[6] = pt[7]
        temp[7] = pt[5]
    
        pt = temp
    }
    
    
    /** mappingF . arguments 4-bit right-half of plaintext & 8-bit subkey **/
    func mappingF(R: [Int], SK: [Int]) -> [Int] {
        var temp = [Int](repeating: 0, count: 8)
    
        // EXPANSION/PERMUTATION [4 1 2 3 2 3 4 1]
        temp[0]  = R[3]
        temp[1]  = R[0]
        temp[2]  = R[1]
        temp[3]  = R[2]
        temp[4]  = R[1]
        temp[5]  = R[2]
        temp[6]  = R[3]
        temp[7]  = R[0]
    
        print("EXPANSION/PERMUTATION on RH : ")
        print(temp)
        print("\n")
    
        // Bit by bit XOR with sub-key
        temp[0] = temp[0] ^ SK[0]
        temp[1] = temp[1] ^ SK[1]
        temp[2] = temp[2] ^ SK[2]
        temp[3] = temp[3] ^ SK[3]
        temp[4] = temp[4] ^ SK[4]
        temp[5] = temp[5] ^ SK[5]
        temp[6] = temp[6] ^ SK[6]
        temp[7] = temp[7] ^ SK[7]
    
        print("XOR With Key : ")
        print(temp)
        print("\n")
    
        // S-Boxes
        let S0 : [[Int]] = [[1,0,3,2], [3,2,1,0], [0,2,1,3], [3,1,3,2]]
        let S1 : [[Int]] = [[0,1,2,3], [2,0,1,3], [3,0,1,0], [2,1,0,3]]
    
        let d11 = temp[0] // first bit of first half
        let d14 = temp[3] // fourth bit of first half
    
        let row1 = BinaryOp.BinToDec(bits: d11,d14) // for input in s-box S0
    
    
        let d12 = temp[1] // second bit of first half
        let d13 = temp[2] // third bit of first half
        let col1 = BinaryOp.BinToDec(bits: d12,d13) // for input in s-box S0
    
    
        let o1 = S0[row1][col1]
    
        let out1 = BinaryOp.DecToBinArr(decimalNumber: o1);
    
        print("S-Box S0: ")
        print(out1)
        print("\n")
    
        let d21 = temp[4] // first bit of second half
        let d24 = temp[7] // fourth bit of second half
        let row2 = BinaryOp.BinToDec(bits: d21,d24)
    
        let d22 = temp[5] // second bit of second half
        let d23 = temp[6] // third bit of second half
        let col2 = BinaryOp.BinToDec(bits: d22,d23)
    
        let o2 = S1[row2][col2]
    
        let out2 = BinaryOp.DecToBinArr(decimalNumber: o2)
    
        print("S-Box S1: ")
        print(out2)
        print("\n")
    
        //4 output bits from 2 s-boxes
        var out = [Int](repeating: 0, count: 4)
        out[0] = out1[0]
        out[1] = out1[1]
        out[2] = out2[0]
        out[3] = out2[1]
    
        //permutation P4 [2 4 3 1]
    
        var O_Per = [Int](repeating: 0, count: 4)
        O_Per[0] = out[1]
        O_Per[1] = out[3]
        O_Per[2] = out[2]
        O_Per[3] = out[0]
    
        print("Output of mappingF : ")
        print(O_Per)
        print("\n")
    
        return O_Per
    }
    
    /** fK(L, R, SK) = (L (XOR) mappingF(R, SK), R) .. returns 8-bit output**/
    func functionFk(L: [Int], R: [Int], SK: [Int]) -> [Int] {
        var temp = [Int](repeating: 0, count: 4)
        var out = [Int](repeating: 0, count: 8)
        
        temp = mappingF(R: R, SK: SK)
    
        //XOR left half with output of mappingF
        out[0] = L[0] ^ temp[0]
        out[1] = L[1] ^ temp[1]
        out[2] = L[2] ^ temp[2]
        out[3] = L[3] ^ temp[3]
    
        out[4] = R[0]
        out[5] = R[1]
        out[6] = R[2]
        out[7] = R[3]
    
    
        return out
    }
    
    /** switch function (SW) interchanges the left and right 4 bits **/
    func switchSW(input: [Int]) -> [Int] {
    
        var temp = [Int](repeating: 0, count: 8)
    
        temp[0] = input[4]
        temp[1] = input[5]
        temp[2] = input[6]
        temp[3] = input[7]
    
        temp[4] = input[0]
        temp[5] = input[1]
        temp[6] = input[2]
        temp[7] = input[3]
    
        return temp
    }
    
    
    func encrypt(plaintext: String , LK: [Int], RK: [Int]) -> [Int] {
    
    
        saveParameters(plaintext: plaintext, k1: LK, k2: RK)
        
    
        print("\n---------------------------------------\n")
        InitialPermutation()
        print("\n---------------------------------------\n")
        //saperate left half & right half from 8-bit pt
        var LH = [Int](repeating: 0, count: 4)
        var RH = [Int](repeating: 0, count: 4)
        
        LH[0] = pt[0]
        LH[1] = pt[1]
        LH[2] = pt[2]
        LH[3] = pt[3]
    
      
        RH[0] = pt[4]
        RH[1] = pt[5]
        RH[2] = pt[6]
        RH[3] = pt[7]

        
        print("First Round LH : ")
        print(LH)
        print("\n")
    
        print("First Round RH: ")
        print(RH)
        print("\n")

        //first round with sub-key K1
        var r1 = [Int](repeating: 0, count: 8)
        r1 = functionFk(L: LH, R: RH, SK: K1)

        print("After First Round : ")
        print(r1)
        print("\n")
        print("\n---------------------------------------\n")
    
        //Switch the left half & right half of about output
        var temp = [Int](repeating: 0, count: 8)
        temp = switchSW(input: r1)

        print("After Switch Function : ")
        print(temp)
        print("\n")
        print("\n---------------------------------------\n")
        
        // again saperate left half & right half for second round
        LH[0] = temp[0]
        LH[1] = temp[1]
        LH[2] = temp[2]
        LH[3] = temp[3]

        RH[0] = temp[4]
        RH[1] = temp[5]
        RH[2] = temp[6]
        RH[3] = temp[7]

    
        print("Second Round LH : ")
        print(LH)
        print("\n")
    
        print("Second Round RH: ")
        print(RH)
        print("\n")

    
        //second round with sub-key K2
        var r2 = [Int](repeating: 0, count: 8)
        r2 = functionFk(L: LH, R: RH, SK: K2)
    
        pt = r2

        print("After Second Round : ")
        print(self.pt)
        print("\n")
        print("\n---------------------------------------\n")

        InverseInitialPermutation();

        print("After Inverse IP (Result) : ")
        print(self.pt)
        print("\n")

        //Encryption done... return 8-bit output .
        return pt
    
    }


}
