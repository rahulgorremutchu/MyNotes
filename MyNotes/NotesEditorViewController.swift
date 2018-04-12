//
//  NotesEditorViewController.swift
//  MyNotes
//
//  Created by Mahin on 11/04/18.
//  Copyright © 2018 Quickeans. All rights reserved.
//

import UIKit
import CoreData

class NotesEditorViewController: UIViewController {

    @IBOutlet weak var editorTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = note!.subject
        editorTableView.estimatedRowHeight = 70.0
        editorTableView.rowHeight = UITableViewAutomaticDimension
    }

}

extension NotesEditorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditorTableViewCell") as! EditorTableViewCell
        cell.txtViewEditor.delegate = self
        return cell
    }
}

extension NotesEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        editorTableView.beginUpdates()
        editorTableView.endUpdates()
    }
}
