//
//  ListDetailTableViewController.swift
//  Checklists
//
//  Created by Leonel Menezes on 15/05/17.
//  Copyright © 2017 BEPID. All rights reserved.
//

import UIKit
protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailTableViewController)
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishingEditing checklist: Checklist)
}

class ListDetailTableViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate : ListDetailViewControllerDelegate?
    
    var checklistToEdit : Checklist?
    var iconName = "Folder"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
            iconImageView!.image = UIImage(named: iconName)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func done(){
        if let checklist = checklistToEdit{
            checklist.name = textField.text!
            checklist.iconName = self.iconName
            delegate?.listDetailViewController(self, didFinishingEditing: checklist)
        }else{
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        }else{
            return nil
        }
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IconPicker" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    func iconPicker(_ iconPicker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    


}
