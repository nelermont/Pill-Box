//
//  FirstTableViewController.swift
//  Pill Box
//
//  Created by Дмитрий Подольский on 08.12.2020.
//

import UIKit

class FirstTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    @IBAction func unwindSeque(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else {return}
        let sourceVC = segue.source as! NewPillTableViewController
        let emoji = sourceVC.emoji
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            Pills.shared.box[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
        let newIndexPath = IndexPath(row: Pills.shared.box.count, section: 0)
            Pills.shared.box.append(emoji)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editPills" else {return}
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = Pills.shared.box[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! NewPillTableViewController
        newEmojiVC.emoji = emoji
        newEmojiVC.title = "Редактирование"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
  
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        if Pills.shared.box.count == 0 {
            self.title = "Добавить лекарства"
        } else {
            self.title = "Список лекарств"
        }
        
        return Pills.shared.box.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pillsCell", for: indexPath) as! PillsTableViewCell
        let object = Pills.shared.box[indexPath.row]
        cell.set(object: object)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       
        return .delete
    }
      
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Pills.shared.box.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedPills = Pills.shared.box.remove(at: sourceIndexPath.row)
        Pills.shared.box.insert(movedPills, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let push = pushOrNotPush(at: indexPath)
        return UISwipeActionsConfiguration(actions: [push])
    }
    
    
    func pushOrNotPush(at indexPath: IndexPath) -> UIContextualAction {
        let object = Pills.shared.box[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Напоминание Выкл.") { (action, view, completion) in
           Pills.shared.box[indexPath.row] = object
            completion(true)
        }
      
        action.backgroundColor = object.isPush ? .systemPurple : .systemGray
        action.title = object.isPush ? "Напоминание Вкл." : "Напоминание Выкл."
    
        return action
    }
    
  
    
}
