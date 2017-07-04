//
//  AboutViewController.swift
//  MenuTest
//
//  Created by Scarpz on 04/07/17.
//  Copyright © 2017 Scarpz. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var scarpz: UIImageView!
    @IBOutlet weak var crivelli: UIImageView!
    @IBOutlet weak var richard: UIImageView!
    @IBOutlet weak var rodrigo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scarpz.layer.cornerRadius = 20.0
        crivelli.layer.cornerRadius = 4.0
        richard.layer.cornerRadius = 4.0
        rodrigo.layer.cornerRadius = 4.0


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
