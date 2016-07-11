//
//  ResultDetail.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2015. 11. 11..
//  Copyright © 2015년 IMLab. All rights reserved.
//

import Foundation
import UIKit


class ResultGraphVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var tableContent: UITableView!

    var bleMan: HsBleSuMan?
    var dbStudent: HmStudent?


    @IBAction func btnActGoBack(sender: AnyObject) {
        showWantBackMessage { () -> Void in
            self.dismissViewControllerAnimated(viewAnimate, completion: nil)
            //self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: viewAnimate)
        }
    }


    override func viewWillAppear(animated: Bool) {
        setLanguageString()


        //print ("  position Json >>  \(dbStudent?.myDataFromDB?.positionJson())")

    }
    
    //////////////////////////////////////////////////////////////////////     _//////////_     [ UI      << >> ]    _//////////_   Table View
    // MARK: Table View

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(" numberOfRowsInSection")
        print(" numberOfRowsInSection :: \(HsBleSingle.inst().stageLimit) ")

        if bleMan == nil {
            return (dbStudent?.myDataFromDB?.arrSet.count)!
        } else {
            if (bleMan?.curStudent == nil) {
                return (bleMan?.dataObj.arrSet.count)!
            } else {
                return (bleMan?.curStudent?.myData?.arrSet.count)!
            }
        }  // return Int(HsBleSingle.inst().stageLimit)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print ("cellForRowAtIndexPath   \(indexPath)")
        var cell:ResultGraphUnit? = tableView.dequeueReusableCellWithIdentifier("graphCell") as? ResultGraphUnit
        if cell == nil {
            addTableCellNib()
            cell = tableView.dequeueReusableCellWithIdentifier("graphCell") as? ResultGraphUnit
        }
        if bleMan == nil { cell?.dbStudent = dbStudent!  }
        else { cell?.bleMan = bleMan! }
        cell?.setCycleNumber(indexPath.row)
        //cell?.cellDidLoad()        cell?.cellDidAppear()
        //cell?.setItems(indexPath.row + 1, dObj: (bleMan?.dataObj)!)
        return cell!
    }
    func addTableCellNib() {
        let nib = UINib(nibName: "ResultGraphUnit", bundle: nil)
        tableContent.registerNib(nib, forCellReuseIdentifier: "graphCell")
    }

    // MARK:  언어 세팅.
    func setLanguageString() {
        labelTitle.text = langStr.obj.detail
        if bleMan == nil {
            labelName.text = dbStudent?.name
        } else {
            if bleMan?.curStudent == nil {
                labelName.text = ""
            } else { labelName.text = bleMan?.curStudent?.name }
        }
    }
}