//
//  ViewController.swift
//  neuroverse
//
//  Created by Anuva Garg on 20/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mainScanTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToScanText", sender: self)
    }
    @IBAction func mainSentimentTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSentiment", sender: self)
    }
}
