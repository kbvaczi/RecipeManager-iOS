//: Playground - noun: a place where people can play

import UIKit
import Locksmith

var str = "Hello, playground"

try Locksmith.saveData(["some key": "some value"], forUserAccount: "myUserAccount")

