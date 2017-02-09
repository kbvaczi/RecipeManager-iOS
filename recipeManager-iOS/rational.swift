//
//  Rational.swift
//  recipeManager-iOS
//
//  Created by KENNETH VACZI on 1/20/17.
//  Copyright © 2017 KENNETH VACZI. All rights reserved.
//

import Foundation

class Rational {

    var numerator: Int
    var denominator: Int

    // From this Stack Overflow Post
    //http://stackoverflow.com/questions/35895154/decimal-to-fraction-conversion-in-swift
    init(_ x0: Double, withPrecision eps: Double = 1.0E-6) {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        self.numerator = h
        self.denominator = k
    }

    convenience init(_ x0: Decimal, withPrecision eps: Double = 1.0E-6) {
        self.init((x0 as NSDecimalNumber).doubleValue, withPrecision: eps)
    }

    var stringValue: String {
        let wholeNumber: Int = Int(self.numerator / self.denominator)
        let mixedNumNumerator: Int = numerator % denominator
        let mixedNumDenominator: Int = denominator
        var mixedNumString = ""
        if wholeNumber > 0 {
            mixedNumString += String(wholeNumber)
        }
        if mixedNumNumerator > 0 {
            if wholeNumber > 0 {
                mixedNumString += " "
            }
            mixedNumString += String(mixedNumNumerator) + "/" + String(mixedNumDenominator)
        }
        return mixedNumString
    }

}
