//
//  ProductsListTableViewController.swift
//  shopingList
//
//  Created by ZELIMKHAN MAGAMADOV on 03.10.2020.
//

import UIKit

class ListViewController: UITableViewController {
    
    var storeList: ProductsListStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData),
                                               name: NSNotification.Name("addList"),
                                               object: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let list = storeList.lists[indexPath.row]
        
        cell.textLabel?.text = list.nameList
        cell.detailTextLabel?.text = "Товаров: \(list.productStore.products.count)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let itemForDelete = storeList.lists[indexPath.row]
            
            if itemForDelete.productStore.products.count > 0 {
                let nameList = storeList.lists[indexPath.row].nameList
                let alertController = UIAlertController(title: "Внимание!", message: "Вы уверены, что хотите удалить список \(nameList)?", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Да", style: .destructive) { (action) in
                    self.storeList.removeList(list: itemForDelete)
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
                
                let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            } else {
                storeList.removeList(list: itemForDelete)
                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProductList" {
            let productsVC = segue.destination as! ProductsTableViewController
            if let index = tableView.indexPathsForSelectedRows?.first {
                productsVC.productList = storeList.lists[index.row]
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    @objc func reloadData() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        storeList.saveProductLists()
    }
    
}
