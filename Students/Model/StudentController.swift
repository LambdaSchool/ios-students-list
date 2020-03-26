//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation
//track type to make it easier to use the segmented control for filter.
enum TrackType: Int {
    case none
    case iOS
    case Web
    case UX
}

//sort options enum for segmented control options.

enum SortOptions: Int {
    case firstName
    case lastName
}

class StudentController {
    
    //MARK: Properties
    
    private var students: [Student] = []
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    func loadFromPersistentStore(completion: @escaping ([Student]?, Error?) -> Void) {
        //putting the loading of data into a background thread.
        let backGroundQueue = DispatchQueue(label: "studentQueue", attributes: .concurrent)
        //run this work on the background queue. do NOT run it on the main queue (The event loop)
        backGroundQueue.async {
            let fm = FileManager.default
            guard let url = self.persistentFileURL,
                    fm.fileExists(atPath: url.path) else {return}
                
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let students = try decoder.decode([Student].self, from: data)
                    self.students = students
                    completion(students, nil)
                } catch {
                    print("Error loading student data: \(error)")
                    completion(nil, error)
                }
            }
        
        
        
    }
    //this filter is tracking the type of key the value object has. its returning that in an array of Students.
    func filter(with trackType: TrackType, sortedBy sorter: SortOptions) -> [Student] {
        var updatedStudents: [Student]
        
        switch trackType {
        case .iOS:
            updatedStudents = students.filter { $0.course == "iOS" }
        case .Web:
            updatedStudents = students.filter { $0.course == "Web"}
        case .UX:
            updatedStudents = students.filter { $0.course == "UX"}
        default:
            updatedStudents = students
        }
        //this is sorting through the first names and alphabetically saving them.
        if sorter == .firstName {
            updatedStudents = updatedStudents.sorted {$0.firstName < $1.firstName}
        } else {
            updatedStudents = updatedStudents.sorted {$0.lastName < $1.lastName}
        }
        return updatedStudents
    }
}
