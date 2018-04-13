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

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var attachButton: UIBarButtonItem!
    @IBOutlet weak var txtViewEditor: UITextView!
    var managedObjectContext: NSManagedObjectContext?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = note!.subject
        
        if let content = note!.content {
            txtViewEditor.attributedText = content as! NSAttributedString
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotesEditorViewController.updateEditorTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NotesEditorViewController.updateEditorTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func configureDoneButton() {
        self.doneButton.isEnabled = !(txtViewEditor.attributedText.length == 0)
    }
    
    @IBAction func saveContent(_ sender: Any) {
        guard let note = note else { return }
        note.content = txtViewEditor.attributedText
        note.modifiedAt = Date()
        do {
            try managedObjectContext?.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    @IBAction func showSourceAlert(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func photoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @objc fileprivate func updateEditorTextView(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyBoardEndScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyBoardEndFrame = self.view.convert(keyBoardEndScreenCoordinates, to: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide {
            txtViewEditor.contentInset = UIEdgeInsets.zero
        } else {
            txtViewEditor.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardEndFrame.height, right: 0)
            txtViewEditor.scrollIndicatorInsets = txtViewEditor.contentInset
        }
        txtViewEditor.scrollRangeToVisible(txtViewEditor.selectedRange)
    }

}

extension NotesEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated:true, completion: nil)
        var attributedString :NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString: txtViewEditor.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = info[UIImagePickerControllerEditedImage] as? UIImage
        let oldWidth = textAttachment.image!.size.width
        
        let scaleFactor = oldWidth / (txtViewEditor.frame.size.width - 10)
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.append(attrStringWithImage)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17.0), range: NSMakeRange(0, attributedString.length))
        txtViewEditor.attributedText = attributedString
        txtViewEditor.becomeFirstResponder()
    }
}



extension NotesEditorViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        attachButton.isEnabled = true
        configureDoneButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        attachButton.isEnabled = false
        configureDoneButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        configureDoneButton()
    }
    
}
