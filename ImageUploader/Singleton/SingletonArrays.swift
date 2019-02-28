//
//  IndexArray.swift
//  ImageUploader
//
//  Created by 1 on 19.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import Foundation

public class SingletonArrays {
    private init() {}
    static let shared = SingletonArrays()
    public var indexArray = [Int]()
    public var links = [Link]()
}
