//
//  ViewController.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var output: MainViewOutput!
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Project>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension MainViewController: MainViewInput {
    func injectFetchController(fetchController: NSFetchedResultsController<Project>) {
        self.fetchedResultsController = fetchController
        self.fetchedResultsController.delegate = self
    }
}

// MARK: - Actions

extension MainViewController {
    @IBAction func newProjectAction(_ sender: Any) {
        output.addProjectPressed()
    }
}

// MARK: - Fetch Controller

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

// MARK: - Table view

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let project = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = project.name
        
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.selectRow()
    }
}
