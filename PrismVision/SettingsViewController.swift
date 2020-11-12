//
//  SettingsViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 06/11/2020.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        2
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let language = NSLocale.autoupdatingCurrent.languageCode;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!;
//        if indexPath.row == 0;
        //TODO: Add it to the Localizable.strings file
        cell.textLabel?.text = NSLocalizedString("Language", comment: "The Language of the app");
        
        switch language {
        case "en":
//            cell.textLabel?.text = "English";
            cell.detailTextLabel?.text = "English";
//            cell.rightDetail.text
//            cell.accessoryType = .checkmark;
        case "ar":
            cell.detailTextLabel?.text = "العربية";
//            cell.textLabel?.text = "العربية";
//            cell.accessoryType = .checkmark;
        default:
            break;
        }
//        cell.textLabel?.text = indexPath.row == 0 ? "English" : "العربية";
        
//        switch indexPath.row {
//        case 0:
//            //TODO: Add this to the userDefaults!
//            cell.accessoryType = .checkmark;
//        default:
//            break;
//        }
        cell.selectionStyle = .none;
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        Locale.autoupdatingcurrent.languageCode
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//        let i = indexPath;
//        let myIndexPath = IndexPath(row: 0, section: 1);
//        let cell = tableView.cellForRow(at: indexPath)!;
//        let englishCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0));
//        let arabicCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0));
//
//        englishCell?.accessoryType = .none;
//        arabicCell?.accessoryType = .none;
//
//        cell.accessoryType = .checkmark;
//        cell.isSelected = false;
        
    }
    
}
