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

    @IBOutlet weak var txtViewEditor: EditorTextView!
    var managedObjectContext: NSManagedObjectContext?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = note!.subject
        
        txtViewEditor.text = """
        Bank Name :- Union Bank of India
        Account No :- 40890201001813
        Name of Branch :- Edakochi
        MICR Code :- 682026016
        IFSC Code :- UBIN0540897
        """
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class EditorTextView: UITextView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: contentSize.height)
    }
}
