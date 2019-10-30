//
//  Student.swift
//  Students
//
//  Created by Andrew R Madsen on 8/5/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import Foundation

struct Student: Codable {
    var name: String
    var course: String
    //creating two computed properties that split the name property into first and last names.
    var firstName: String {
        return String(name.split(separator: " ")[0])
    }
    var lastName: String {
        return String(name.split(separator: " ").last ?? "")
    }
    
}
