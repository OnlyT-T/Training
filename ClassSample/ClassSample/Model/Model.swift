//
//  Model.swift
//  ClassSample
//
//  Created by Tran Thanh Trung on 19/01/2022.
//

import Foundation

class Student
{
    var id: Int = 0
    var name: String = ""
    var age: Int = 0
    var yearOfBirth: Int = 0
    var math: Double = 0
    var physic: Double = 0
    var science: Double = 0
    var address: String = ""

    init (name: String, age: Int, yearOfBirth: Int, math: Double, physic: Double, science: Double, address: String) {
        self.name = name
        self.age = age
        self.yearOfBirth = yearOfBirth
        self.math = math
        self.physic = physic
        self.science = science
        self.address = address
    }
}
