//
//  ProductsTableViewController.swift
//  shopingList
//
//  Created by ZELIMKHAN MAGAMADOV on 03.10.2020.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addProductButton: UIButton!
    
    var productList: ProductsList! {
        didSet {
            navigationItem.title = productList.nameList
        }
    }
    
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProductButton.layer.cornerRadius = addProductButton.bounds.height / 2
        
        let addCellNib = UINib(nibName: "ProductAddCell", bundle: nil)
        tableView.register(addCellNib, forCellReuseIdentifier: "addProductCell")
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    
    
    @IBAction func addProductToList(_ sender: UIButton) {
//        let alertController = UIAlertController(title: "Add product", message: nil, preferredStyle: .alert)
//        alertController.addTextField { (textFieldNameProduct) in
//            textFieldNameProduct.placeholder = "name product"
//        }
//        alertController.addTextField { (textFieldQuantity) in
//            textFieldQuantity.placeholder = "quantity"
//        }
//
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
//            if let nameProduct = alertController.textFields?[0].text,
//               let quantity = alertController.textFields?[1].text,
//               !nameProduct.isEmpty {
//                let newProduct = Product(name: nameProduct, quantity: Int(quantity) ?? 1)
//                self.productList.products.append(newProduct)
//                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addList"), object: nil)
//            }
//
//        }
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
        
        guard !isEditingMode else {
            return
        }
     
        isEditingMode = true
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        
    }

}



extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.productStore.products.count + (isEditingMode ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < productList.productStore.products.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
            
            cell.textLabel?.text = productList.productStore.products[indexPath.row].name
            cell.detailTextLabel?.text = "\(productList.productStore.products[indexPath.row].quantity)"
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addProductCell", for: indexPath) as! ProductAddCell
            cell.addProductTextField.delegate = self
            cell.addProductTextField.text?.removeAll()
            
//            DispatchQueue.main.async {
//                cell.addProductTextField.becomeFirstResponder()
//            }
            
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == productList.productStore.products.count {
            let productCell = cell as! ProductAddCell
            productCell.addProductTextField.becomeFirstResponder()
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let productForDelete = productList.productStore.products[indexPath.row]
        
        
        delete(product: productForDelete)
        
    }

    func delete(product: Product) {
        if let index = productList.productStore.products.firstIndex(of: product) {
            productList.productStore.products.remove(at: index)
            saveAndReload()
        }
        
    }
    
    func saveAndReload() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "addList")))
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func insertNew(product: Product) {
        productList.productStore.products.append(product)
        saveAndReload()
    }
    
}

extension ProductViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if let newProductName = textField.text {
           let newProduct = Product(name: newProductName, quantity: 1)
            isEditingMode = false
            insertNew(product: newProduct)
        }
        
        return true
        
    }
    
}
