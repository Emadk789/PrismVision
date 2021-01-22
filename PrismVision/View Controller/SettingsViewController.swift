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
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let language = NSLocale.autoupdatingCurrent.languageCode;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!;

        
        switch indexPath.section {
        case 0:
            cell.imageView?.image = UIImage(systemName: "globe")
            cell.imageView?.tintColor = .systemGray
            cell.textLabel?.text = NSLocalizedString("Language", comment: "The Language of the app");
            cell.detailTextLabel?.text = NSLocalizedString("English", comment: "Language")
            
        case 1:
            cell.imageView?.image = UIImage(systemName: "questionmark.circle")
            cell.imageView?.tintColor = .systemGray
            cell.detailTextLabel?.text = ""
            cell.textLabel?.text = NSLocalizedString("Tutorial", comment: "Tutorial")
            break
        default:
            break
        }
        
        cell.selectionStyle = .none;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        else if indexPath.section == 1 {
            let vc = TutorialViewController()
            present(vc, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
