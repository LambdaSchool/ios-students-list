//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var studentsController = StudentController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        //techinically a UI update, placing the code on a background queue.
        studentsController.loadFromPersistentStore { students, error in
            if let error = error {
                print("Error loading students: \(error)")
                return
            }
            
            //makes sure that the updating of the ui is happening on the main thread.
            DispatchQueue.main.async {
                if let students = students {
                    self.filteredAndSortedStudents = students
                }
            }
        }
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        //lets you access the filter control we mades segments indexes. we assigned it to an object called filter
        let filter = TrackType(rawValue: filterSelector.selectedSegmentIndex) ?? .none
        let sort = SortOptions(rawValue: sortSelector.selectedSegmentIndex) ?? .firstName
        filteredAndSortedStudents = studentsController.filter(with: filter, sortedBy: sort)
    }
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        let aStudent = filteredAndSortedStudents[indexPath.row]
        cell.textLabel?.text = aStudent.name
        cell.detailTextLabel?.text = aStudent.course
        
        return cell
    }
}
