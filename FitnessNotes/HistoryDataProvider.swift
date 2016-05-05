//
//  HistoryDataProvider.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/4/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit

class HistoryDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let nums = [1,2,3,4,5,6,7,8,9,10]
    
    //MARK: - DataSource
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nums.count
    }
    
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = nums[indexPath.row].description
        
        return cell
    }
    
    
    //MARK: - Delegate
    
    
}
