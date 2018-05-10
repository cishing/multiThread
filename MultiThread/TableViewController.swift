//
//  TableViewController.swift
//  MultiThread
//
//  Created by XiaShiyang on 2018/4/25.
//  Copyright © 2018年 cishing. All rights reserved.
//

/*
 区别       |      并发队列       |      串行队列          |        主队列
 ----------|--------------------|----------------------|--------------------------------------------
 同步执行    |    没有开启新线程,   |    没有开启新线程,      |   主线程调用：死锁卡住不执行
           |     串行执行任务     |     串行执行任务        |   其他线程调用：不开启新线程，串行执行任务
 ----------|--------------------|----------------------|--------------------------------------------
 异步执行    |    有开启新线程,     |    有开启新线程(只1条), |   不开启新线程,
           |     并发执行任务     |     串行执行任务        |   串行执行任务
 ---------------------------------------------------------------------------------------------------
 */

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        switch indexPath.row {
            
        case 0:
            
            cell.textLabel?.text = "Thread"
            
        case 1:
            
            cell.textLabel?.text = "GCD"
            
        default:
            
            cell.textLabel?.text = "Operation + OperationQueue"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        switch indexPath.row {
            
        case 0:
            
            let threadViewController = storyboard.instantiateViewController(withIdentifier: "ThreadViewController")
            self.navigationController?.pushViewController(threadViewController, animated: true)
            
        case 1:
            
            let GCDViewController = storyboard.instantiateViewController(withIdentifier: "GCDTableViewController")
            self.navigationController?.pushViewController(GCDViewController, animated: true)
            
        default:
            
            let operationViewController = storyboard.instantiateViewController(withIdentifier: "OperationTableViewController")
            self.navigationController?.pushViewController(operationViewController, animated: true)
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
