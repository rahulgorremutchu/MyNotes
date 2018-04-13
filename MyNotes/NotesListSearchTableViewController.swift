//
//  NotesListSearchTableViewController.swift
//  MyNotes
//
//  Created by Mahin on 13/04/18.
//  Copyright © 2018 Quickeans. All rights reserved.
//

import UIKit
import CoreData

protocol SelectSearchCellProtocol {
    func didSelectCell(with note: Note)
}

class NotesListSearchTableViewController: UITableViewController {
    
    var notes: [Note]?
    var filteredNotes: [Note]?
    var managedObjectContext: NSManagedObjectContext?
    var delegate: SelectSearchCellProtocol?
    private let cellIdentifier = "NotesListSearchTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NotesListSearchTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        edgesForExtendedLayout = .bottom
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filtered = filteredNotes else { return 0 }
        return filtered.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotesListSearchTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.accessoryType = .disclosureIndicator
        guard let filtered = self.filteredNotes else { return cell }
        cell.textLabel?.text = filtered[indexPath.row].subject
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TOP MATCHES"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let filtered = self.filteredNotes else { return }
        delegate?.didSelectCell(with: filtered[indexPath.row])
    }

}

extension NotesListSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let notes = notes else { return }
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filteredNotes = notes.filter {
                return ($0.value(forKey: "subject") as? String)!.range(of: text, options: .caseInsensitive) != nil
            }
            self.tableView.reloadData()
        }
    }
    
    
}
