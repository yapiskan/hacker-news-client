//
//  Helper.swift
//
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

func printJSON(_ obj: Encodable) throws {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let jsonResultData = try jsonEncoder.encode(obj)
    print(String(data: jsonResultData, encoding: .utf8)!)
}
