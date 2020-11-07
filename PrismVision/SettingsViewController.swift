//
//  SettingsViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 06/11/2020.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!;
//        if indexPath.row == 0;
        cell.textLabel?.text = indexPath.row == 0 ? "English" : "العربية";
        
        switch indexPath.row {
        case 0:
            //TODO: Add this to the userDefaults!
            cell.accessoryType = .checkmark;
        default:
            break;
        }
        cell.selectionStyle = .none;
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath;
        let myIndexPath = IndexPath(row: 0, section: 1);
        let cell = tableView.cellForRow(at: indexPath)!;
        let englishCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0));
        let arabicCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0));

        englishCell?.accessoryType = .none;
        arabicCell?.accessoryType = .none;
        
        cell.accessoryType = .checkmark;
        cell.isSelected = false;
    }
    
}
