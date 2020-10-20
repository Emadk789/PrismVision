//
//  TestViewController.swift
//  PrismVision
//
//  Created by Emad Albarnawi on 18/10/2020.
//

import UIKit

class TestViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    
    var horizantalConstriant: NSLayoutConstraint?;
    var verticalConstriant: NSLayoutConstraint?;
    
    var leftCosntriant: NSLayoutConstraint?;
    var topConstriant: NSLayoutConstraint?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        button1.translatesAutoresizingMaskIntoConstraints = false;
//        button1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
//        button1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        
        horizantalConstriant = button1.centerXAnchor.constraint(equalTo: view.centerXAnchor);
        verticalConstriant = button1.centerYAnchor.constraint(equalTo: view.centerYAnchor);

        horizantalConstriant?.isActive = true;
        verticalConstriant?.isActive = true;
        
        
      
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        
        
        
    }
    

    @IBAction func button2Clicked(_ sender: Any) {
        
        horizantalConstriant?.isActive = false;
        verticalConstriant?.isActive = false;
        
        
        leftCosntriant = button1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 300);
        topConstriant = button1.topAnchor.constraint(equalTo: view.topAnchor, constant: 600);
        
        leftCosntriant?.isActive = true;
        topConstriant?.isActive = true;
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
