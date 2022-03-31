//
//  ToDoViewController.swift
//  ToDo-List
//
//  Created by 陳列 on 2022/3/30.
//

import UIKit
import KRProgressHUD

class ToDoViewController: UIViewController {

    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var keyboardHeight: CGFloat = 0
    var allList: [ToDoList] = []
    var todoList: [ToDoList] = []
    var doneList: [ToDoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotificationSet()
        tableView.delegate = self
        tableView.dataSource = self
        addTextField.delegate = self
        
        CoreDataManager.shared.loadFromCoreData(data: &allList)
        todoList = allList.filter({$0.complete == false})
        doneList = allList.filter({$0.complete == true})
        // Do any additional setup after loading the view.
    }
    


    
    @IBAction func addTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        if text.isEmpty {
            addBtn.isEnabled = false
            addBtn.backgroundColor = .gray
        } else {
            addBtn.isEnabled = true
            addBtn.backgroundColor = .red
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        let data = ToDoList(context: CoreDataManager.shared.managedObjectContext())
        data.title = addTextField.text
        data.complete = false
        todoList.append(data)
        allList.append(data)
        CoreDataManager.shared.saveContext()
        
        addBtn.isEnabled = false
        addBtn.setTitle(nil, for: .normal)
        addBtn.setImage(UIImage(systemName: "circles.hexagonpath.fill"), for: .normal)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 0, animations: {
            self.addBtn.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
            self.view.layoutIfNeeded()
        }) { _ in
            self.addBtn.imageView?.transform = CGAffineTransform.identity
        }
        addTextField.text = nil
        addTextField.isEnabled = false
        self.view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.tableView.reloadData()
            self.addTextField.isEnabled = true
            self.addBtn.setTitle("送出", for: .normal)
            self.addBtn.setImage(nil, for: .normal)
            self.addBtn.backgroundColor = .gray
        }

    }
    

    
    

    
    //MARK: KEYBOARD

    func keyboardNotificationSet(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillShow (_ notification: Notification) { //鍵盤要出來
        if let keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, animations: {
                let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                self.messageHeight.constant = keyboard.cgRectValue.height - (self.view.frame.height - self.view.safeAreaLayoutGuide.layoutFrame.height - statusBarHeight) + 49 // 整個螢幕高-safeArea高-statusBar高+tabbar高 才能符合全機型
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.keyboardHeight = keyboard.cgRectValue.height
        }
    }
    @objc func keyboardWillChangeFrame(_ notification: Notification) { //切換不同鍵盤的時候
        if let keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0, delay: 0, animations: {
                let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                self.messageHeight.constant = keyboard.cgRectValue.height - (self.view.frame.height - self.view.safeAreaLayoutGuide.layoutFrame.height - statusBarHeight) + 49
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.keyboardHeight = keyboard.cgRectValue.height
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) { //鍵盤要消失
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
            self.messageHeight.constant = 44
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        self.keyboardHeight = 0
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

//MARK: UITableViewDelegate,UITableViewDataSource

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName.todoCell, for: indexPath) as! ToDoTableViewCell
        let data = todoList[indexPath.row]
        cell.toDoTextField.text = data.title
        cell.completeBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        cell.completeBtn.tintColor = .gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell else {
            return
        }
        let data = todoList[indexPath.row]
        
        tableView.isUserInteractionEnabled = false

        cell.completeBtn.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        cell.completeBtn.tintColor = .systemPink
        data.complete = true
        data.date = Date()
        doneList.append(data)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.todoList.remove(at: indexPath.row)
            self.allList = self.todoList + self.doneList
            CoreDataManager.shared.saveContext()
            tableView.isUserInteractionEnabled = true
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteData = todoList[indexPath.row]
            todoList.remove(at: indexPath.row)
            allList = todoList + doneList
            CoreDataManager.shared.deleteFromCoreData(data: deleteData)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    

    
}

//MARK: UITextFieldDelegate

extension ToDoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
