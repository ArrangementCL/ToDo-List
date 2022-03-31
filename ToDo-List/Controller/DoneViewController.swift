//
//  DoneViewController.swift
//  ToDo-List
//
//  Created by 陳列 on 2022/3/30.
//

import UIKit

class DoneViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allList: [ToDoList] = []
    var doneList: [ToDoList] = []
    var todoList: [ToDoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager.shared.loadFromCoreData(data: &allList)
        doneList = allList.filter({$0.complete == true})
        todoList = allList.filter({$0.complete == false})
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName.doneCell) as! DoneTableViewCell
        let data = doneList[indexPath.row]
        
        cell.doneTextField.text = data.title
        cell.timeLabel.text = data.date?.calculateTimeDifference(toTheDate: Date())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteData = doneList[indexPath.row]
            doneList.remove(at: indexPath.row)
            allList = todoList + doneList
            CoreDataManager.shared.deleteFromCoreData(data: deleteData)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    
}
