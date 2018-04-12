//
//  NotesListTableViewController.swift
//  MyNotes
//
//  Created by Mahin on 11/04/18.
//  Copyright © 2018 Quickeans. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class NotesListTableViewController: UITableViewController {
    
    var locManager = CLLocationManager()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var managedObjectContext: NSManagedObjectContext?
    var resultController: NSFetchedResultsController<Note>!
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.requestWhenInUseAuthorization()
        
        managedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "subject", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        resultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        resultController.delegate = self
        do {
            try! resultController.performFetch()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesListTableViewCell", for: indexPath) as! NotesListTableViewCell
        let note = resultController.object(at: indexPath)
        cell.textLabel?.text = note.subject
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        cell.detailTextLabel?.text = String(dateFormatter.string(from: note.createdAt!))
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let note = self.resultController.object(at: indexPath)
            self.managedObjectContext?.delete(note)
            do {
                try self.resultController.managedObjectContext.save()
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
            
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        return nil
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEditorVC", sender: indexPath)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? IndexPath, let editorVC = segue.destination as? NotesEditorViewController {
            editorVC.managedObjectContext = self.managedObjectContext!
           // editorVC.managedObjectContext = resultController.managedObjectContext
            editorVC.note = resultController.object(at: sender)
        }
    }
    
    
    fileprivate func insertSubject(with title: String) {
        let note = Note(context: managedObjectContext!)
        note.subject = title
        note.createdAt = Date()
        note.modifiedAt = nil
        note.content = nil
        
        var currentLocation: CLLocation!
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            currentLocation = locManager.location
            note.latitude = Double(currentLocation.coordinate.latitude)
            note.longitude = Double(currentLocation.coordinate.longitude)
            
        } else {
            note.latitude = 0.0
            note.longitude = 0.0
        }
        
        do {
            try managedObjectContext?.save()
            let indexPath: IndexPath = IndexPath(row: 0, section: 0)
            self.performSegue(withIdentifier: "showEditorVC", sender: indexPath)
        } catch {
            print(error)
        }
    }
    
    @IBAction func addNewNoteAction(_ sender: UIBarButtonItem) {
        
        
        alertController = UIAlertController(title: "Add New Subject", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.delegate = self
            textField.placeholder = "Enter Subject"
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { action in
            let firstTextField = self.alertController.textFields![0] as UITextField
            self.insertSubject(with: firstTextField.text!)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        continueAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension NotesListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexpath = newIndexPath {
                tableView.insertRows(at: [indexpath], with: .automatic)
            }
        case .delete:
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .automatic)
            }
        default: break
        }
    }
}

extension NotesListTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        alertController.actions[0].isEnabled = newLength >= 1
        return true
    }
    
}







