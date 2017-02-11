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
    var mixedNumWhole: Int {
        return numerator / denominator
    }
    var mixedNumNumer: Int {
        return numerator % denominator
    }

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

    init(_ x0: String) {
        guard let slashRange = x0.range(of: "/") else {
            if let wholeNumber = Int(x0) {
                numerator = wholeNumber
            } else {
                numerator = 0
            }
            denominator = 1
            return
        }
        let numeratorString = x0.substring(to: slashRange.lowerBound)
        let denominatorString = x0.substring(from: slashRange.upperBound)
        guard   let num = Int(numeratorString),
                let denom = Int(denominatorString) else {
            numerator = 0
            denominator = 1
            return
        }
        numerator = num
        denominator = denom
    }

    var stringValue: String {
        var mixedNumString = ""
        if mixedNumWhole > 0 {
            mixedNumString += String(mixedNumWhole)
        }
        if mixedNumNumer > 0 {
            if mixedNumWhole > 0 {
                mixedNumString += " "
            }
            mixedNumString += String(mixedNumNumer) + "/" + String(denominator)
        }
        return mixedNumString
    }

    var decimalValue: Decimal {
        return Decimal(numerator) / Decimal(denominator)
    }

}
