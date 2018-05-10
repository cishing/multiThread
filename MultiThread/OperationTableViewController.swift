//
//  OperationTableViewController.swift
//  MultiThread
//
//  Created by XiaShiyang on 2018/4/27.
//  Copyright © 2018年 cishing. All rights reserved.
//

import UIKit

// MARK: 自定义Operation
class SYOperation: Operation {
    
    // 重写main方法，将任务写在main方法中
    override func main() {
        
        Thread.sleep(forTimeInterval: 0.5)
        
        print("自定义Operation任务: \(Thread.current)")
    }
}

class OperationTableViewController: UITableViewController {

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
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        switch indexPath.row {
            
        case 0:
            
            cell.textLabel?.text = "自定义Operation 与 BlockOperation"
            
        case 1:
            
            cell.textLabel?.text = "配合OperationQueue实现"
            
        case 2:
            
            cell.textLabel?.text = "最大并发数实现"
            
        case 3:
            
            cell.textLabel?.text = "Operation依赖关系"
            
        case 4:
            
            cell.textLabel?.text = "OperationQueue取消"
            
        default:
            
            cell.textLabel?.text = "OperationQueue暂停/恢复"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
            
        case 0:
            
            diyOperationAndBlockOperation()
           
        case 1:
            
            operationQueue()
            
        case 2:
            
            maxConcurrentOperationCount()
            
        case 3:
            
            addDependency()
            
        case 4:
            
            operationQueueCancle()
            
        default:
            
            suspendAndContinue()
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

// MARK: - 自定义Operation 与 BlockOperation
extension OperationTableViewController {
    
    func diyOperationAndBlockOperation() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let diyOperation = SYOperation()
        diyOperation.start()        // 必须调用start()方法任务才会执行
        
        let blockOperation = BlockOperation.init {
            
            print("BlockOperation任务: \(Thread.current)")
        }
        
        let completionBlcok = {
            
            print("BlockOperation任务执行完毕")
        }
        
        // 所有 operation 都支持一个可选的 completion block，会在主任务执行完成时被调用
        blockOperation.completionBlock = completionBlcok
        
        blockOperation.start()
        
        print("#------mission end------#")
        print("结果: 不开启新线程，串行执行任务")
    }
}

// MARK: - 配合OperationQueue实现
extension OperationTableViewController {
    
    // OperationQueue只有并发队列的实现和主队列的获取，没有串行队列的实现
    func operationQueue() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let diyOperation = SYOperation()
        
        let blockOperation = BlockOperation.init {
            
            print("BlockOperation任务: \(Thread.current)")
        }
        
        let operationQueue = OperationQueue()   // 并发队列
        
        operationQueue.addOperation(diyOperation)   // 调用addOperation，任务就会自动执行
        operationQueue.addOperation(blockOperation) // 异步执行
        
        let mainQueue = OperationQueue.main     // 获取主队列的任务是异步执行的，主队列是串行队列
        mainQueue.addOperation {
            
            Thread.sleep(forTimeInterval: 0.5)
            
            print("主队列任务1: \(Thread.current)")
        }
        
        mainQueue.addOperation {
            
            print("主队列任务2: \(Thread.current)")
        }
        
        print("#------mission end------#")
        print("结果: OperationQueue初始化，默认是生成了一个并发队列，而且执行的是一个异步操作\n获取主队列的任务是异步执行的，主队列是串行队列")
    }
}

// MARK: - 最大并发数实现
extension OperationTableViewController {
    
 /*

     maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
     maxConcurrentOperationCount这个值不应超过系统限制(64)，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}
 */
    
    func maxConcurrentOperationCount() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let queueCount1 = OperationQueue()
        
        // 设置maxConcurrentOperationCount为1，同任务优先级，实现串行操作
        queueCount1.maxConcurrentOperationCount = 1
        
        let bq1 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("count1任务一: \(Thread.current)")
            }
        }
        
        let bq2 = BlockOperation.init {
            
            for _ in 0...1 {
                
                Thread.sleep(forTimeInterval: 0.3)
                
                print("count1任务二: \(Thread.current)")
            }
        }
        
        // waitUntilFinished: 阻塞当前线程，直到该操作结束。可用于线程执行顺序的同步
        queueCount1.addOperations([bq1, bq2], waitUntilFinished: true)
        print("结果: maxConcurrentOperationCount为1，同任务优先级，实现串行操作")
        print("------------------------------------------")
        
        let queueCount1_new = OperationQueue()
        
        // 设置maxConcurrentOperationCount为1，不同任务优先级，任务按优先级串行执行
        queueCount1_new.maxConcurrentOperationCount = 1
        
        let bq3 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("count1_new任务一: \(Thread.current)")
            }
        }
        
        let bq4 = BlockOperation.init {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("count1_new任务二: \(Thread.current)")
            }
        }
        
        let bq5 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("count1_new任务三: \(Thread.current)")
            }
        }
        
        bq3.queuePriority = .low
        bq4.queuePriority = .high
        bq5.queuePriority = .normal
        
        queueCount1_new.addOperations([bq3, bq4, bq5], waitUntilFinished: true)
        print("结果: maxConcurrentOperationCount为1，不同任务优先级，任务按优先级串行执行")
        print("------------------------------------------")
        
        let queueCountMore = OperationQueue()
        
        // 设置maxConcurrentOperationCount为3，实现并发操作
        queueCountMore.maxConcurrentOperationCount = 3
        
        let bq6 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("并发任务一: \(Thread.current)")
            }
        }
        
        let bq7 = BlockOperation.init {
            
            for _ in 0...4 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("并发任务二: \(Thread.current)")
            }
        }
        
        let bq8 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("并发任务三: \(Thread.current)")
            }
        }
        
        queueCountMore.addOperations([bq6, bq7, bq8], waitUntilFinished: true)
        print("结果: maxConcurrentOperationCount为3，实现并发操作")
        
        print("#------mission end------#")
    }
}

// MARK: - Operation依赖关系
extension OperationTableViewController {
    
    func addDependency() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        let bq1 = BlockOperation.init {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        let bq2 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")
            }
        }
        
        let bq3 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionThree: \(Thread.current)")
            }
        }
        
        bq1.addDependency(bq3)      // 任务一依赖任务三执行完成才开始执行
        
        queue.addOperations([bq1, bq2, bq3], waitUntilFinished: false)
        
        print("#------mission end------#")
    }
}

// MARK: - OperationQueue取消
extension OperationTableViewController {
    
    func operationQueueCancle() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let queue = OperationQueue()
        
        let bq1 = BlockOperation.init {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.5)
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        let bq2 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.1)
                
                print("missionTwo: \(Thread.current)")
            }
        }
        
        bq2.addDependency(bq1)
        queue.addOperations([bq1, bq2], waitUntilFinished: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

            queue.cancelAllOperations()     // 取消当前队列中所有还未开始执行的任务，已经执行的任务不受影响
        }
        
        print("#------mission end------#")
        print("结果: 取消当前队列中所有还未开始执行的任务，已经执行的任务不受影响")
    }
}

// MARK: - OperationQueue暂停/恢复
extension OperationTableViewController {
    
    func suspendAndContinue() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let queue = OperationQueue()
        
        let bq1 = BlockOperation.init {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.5)
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        let bq2 = BlockOperation.init {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.1)
                
                print("missionTwo: \(Thread.current)")
            }
        }
        
        bq2.addDependency(bq1)
        queue.addOperations([bq1, bq2], waitUntilFinished: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            print("暂停5秒钟...")
            queue.isSuspended = true   // 暂停当前队列中所有还未开始执行的任务，已经执行的任务不受影响
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                
                if queue.isSuspended == true {  // 判断当前队列是否处于暂停状态
                    
                    print("队列即将恢复...")
                    queue.isSuspended = false   // 恢复队列
                }
            })
        }
        
        print("#------mission end------#")
        print("结果: 暂停当前队列中所有还未开始执行的任务，已经执行的任务不受影响")
    }
}
