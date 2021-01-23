//
//  SettingsViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 06/11/2020.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let textView: UITextView = {
        let textView = UITextView()

        textView.textAlignment = .center
        textView.textColor = .systemGray
        var text: NSMutableAttributedString = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let title = NSAttributedString(string: "From", attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.systemGray, .paragraphStyle: paragraph])
        let body = NSAttributedString(string: "\nPrism Vision", attributes: [.font:UIFont.boldSystemFont(ofSize: 25), .foregroundColor : UIColor.systemGray, .paragraphStyle: paragraph])

        text.append(title)
        text.append(body)
        textView.attributedText = text
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        view.addSubview(textView)
        configurTextViewAnchors()
    }
    private func configurTextViewAnchors() {
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
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
