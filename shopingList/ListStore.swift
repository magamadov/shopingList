//
//  ProductsListStore.swift
//  shopingList
//
//  Created by ZELIMKHAN MAGAMADOV on 03.10.2020.
//

import Foundation

class ListStore {
    
    var lists = [List]()
    
    let productsListURL: URL = {
        let documentsDirectoies = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectoies.first!
        return documentDirectory.appendingPathComponent("lists.plist")
    }()
    
    func createList(name: String) {
        let newList = List(nameList: name)
        lists.append(newList)
    }
    
    func saveProductLists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: productsListURL, options: .atomic)
        } catch {
            print("Failed encoding and save data: \(error)")
        }
    }
    
    
    
    func removeList(list: List) {
        let index = lists.firstIndex { (productList) -> Bool in
            if list.nameList == productList.nameList {
                return true
            }
            return false
        }
        
        if let index = index {
            lists.remove(at: index)
        }
        saveProductLists()
    }
    
    init() {
        do {
            let data = try Data(contentsOf: productsListURL)
            let decoder = PropertyListDecoder()
            let items = try decoder.decode([List].self, from: data)
            lists = items
        } catch {
            print("Failed load data from disk: \(error)")
            
        }
    }
    
}
