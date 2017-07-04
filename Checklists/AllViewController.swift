//
//  AllViewController.swift
//  Checklists
//
//  Created by Leonel Menezes on 12/05/17.
//  Copyright © 2017 BEPID. All rights reserved.
//

import UIKit

class AllViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    
    //var lists : [Checklist]
    
    var dataModel : DataModel!
    
//    required init?(coder aDecoder: NSCoder) {
//        lists = [Checklist]()
//        super.init(coder: aDecoder)
//        loadChecklists()
//        print("o documents directory é: \(documentsDirectory())")
//        print("O data file path é: \(dataFilePath())")
//        var list = Checklist(name: "Birthdays")
//        lists.append(list)
//        
//        list = Checklist(name: "Groceries")
//        lists.append(list)
//        
//        list = Checklist(name: "Cool Apps")
//        lists.append(list)
//        
//        list = Checklist(name: "To Do")
//        lists.append(list)
//        
//        for list in lists {
//            let item = ChecklistItem()
//            item.text = "Item for \(list.name)"
//            list.items.append(item)
//            
//        }
//    }
//    
    
    
    
    // MARK: - VIEW

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklists", sender: checklist)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
//    func documentsDirectory() -> URL {
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return path[0]
//    }
//    
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklist.plist")
//    }
//    
//    func saveChecklists(){
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        
//        archiver.encode(lists, forKey: "Checklists")
//        
//        archiver.finishEncoding()
//        
//        data.write(to: dataFilePath(), atomically: true)
//    }
//    
//    func loadChecklists(){
//        let path = dataFilePath()
//        if let data = try? Data(contentsOf: path){
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//            
//            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
//            
//            unarchiver.finishDecoding()
//        }
//        
//    }
    
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.imageView!.image = UIImage(named: checklist.iconName)
        cell.accessoryType = .detailDisclosureButton
        let count = checklist.countUncheckedItems();
        if(count > 0){
            cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Restantes"
        }else if(count == 0){
            cell.detailTextLabel!.text = "Nenhum item"
        }else{
            cell.detailTextLabel!.text = "Tudo feito!"
        }
        
        //cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Restantes"
        
        return cell
    }
    
    func makeCell(for tableView : UITableView) -> UITableViewCell{
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        
        performSegue(withIdentifier: "ShowChecklists", sender: checklist)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            dataModel.lists.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailTableViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
    //MARK: - listDetail protocol
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishingEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - NAVIGATION CONTROLLER
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    // MARK: - segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklists" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailTableViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }

    
}
