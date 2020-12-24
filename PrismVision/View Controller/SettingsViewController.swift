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
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let language = NSLocale.autoupdatingCurrent.languageCode;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!;

        cell.textLabel?.text = NSLocalizedString("Language", comment: "The Language of the app");
        
        switch language {
        case "en":
            cell.detailTextLabel?.text = "English";
        case "ar":
            cell.detailTextLabel?.text = "العربية";
        default:
            break;
        }
        cell.selectionStyle = .none;
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
}
