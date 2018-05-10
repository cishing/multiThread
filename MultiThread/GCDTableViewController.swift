//
//  GCDTableViewController.swift
//  MultiThread
//
//  Created by XiaShiyang on 2018/4/27.
//  Copyright © 2018年 cishing. All rights reserved.
//

/*

 - label: 队列标签
 - qos: 队列优先级
 - attributes: 包含两个属性 1)concurrent：标识队列为并行队列
                          2)initiallyInactive：标识运行队列中的任务需要动手触发（未添加此标识时，向队列中添加任务会自动运行），触发时通过 queue.activate() 方法
 - autoreleaseFrequency: 这个属性表示 autorelease pool 的自动释放频率， autorelease pool 管理着任务对象的内存周期。
 
 包含三个属性：
 
 inherit：继承目标队列的该属性
 workItem：跟随每个任务的执行周期进行自动创建和释放
 never：不会自动创建 autorelease pool，需要手动管理。
 
 一般任务采用 .workItem 属性就够了，特殊任务如在任务内部大量重复创建对象的操作可选择 .never 属性手动创建 autorelease pool
 
 - target: 这个属性设置的是一个队列的目标队列，即实际将该队列的任务放入指定队列中运行。目标队列最终约束了队列优先级等属性。
 只有两种情况可以显式地设置目标队列:
 1)初始化方法中，指定目标队列
 2)初始化方法中，attributes 设定为 initiallyInactive，然后在队列执行 activate() 之前可以指定目标队列
 
 DispatchQueue.init(label: <#T##String#>, qos: <#T##DispatchQoS#>, attributes: <#T##DispatchQueue.Attributes#>, autoreleaseFrequency: <#T##DispatchQueue.AutoreleaseFrequency#>, target: <#T##DispatchQueue?#>)
 
 */

import UIKit

class GCDTableViewController: UITableViewController {

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
        return 14
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        switch indexPath.row {
            
        case 0:
        
            cell.textLabel?.text = "串行队列 + 同步"
            
        case 1:
            
            cell.textLabel?.text = "串行队列 + 异步"
            
        case 2:
            
            cell.textLabel?.text = "并发队列 + 同步"
            
        case 3:
            
            cell.textLabel?.text = "并发队列 + 异步"
            
        case 4:
            
            cell.textLabel?.text = "主队列 + 同步"
            
        case 5:
            
            cell.textLabel?.text = "主队列 + 异步"
        
        case 6:
            
            cell.textLabel?.text = "DispatchWorkItem 任务对象"
            
        case 7:
            
            cell.textLabel?.text = "DispatchGroup 任务组"
            
        case 8:
            
            cell.textLabel?.text = "dispatch_barrier_async 栅栏任务"
            
        case 9:
            
            cell.textLabel?.text = "DispatchSemaphore 信号量"
            
        case 10:
            
            cell.textLabel?.text = "DispatchQoS 优先级"
           
        case 11:
            
            cell.textLabel?.text = "asyncAfter 延迟任务"
            
        case 12:
            
            cell.textLabel?.text = "concurrentPerform 迭代任务"
            
        default:
            
            cell.textLabel?.text = "DispatchSource 倒计时"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
            
        case 0:
            
            serialSync()
            
        case 1:
            
            serialAsync()
            
        case 2:
            
            concurrentSync()
            
        case 3:
            
            concurrentAsync()
            
        case 4:
            
/*           mainSync()    在主线程中执行 主队列 + 同步，任务会相互等待，造成死锁
             原因是 mainSync() 这个任务是在主线程执行的，同步任务1被添加到主队列，要等待队列 mainSync() 任务执行完才会执行。
             然后，任务1是在 mainSync() 这个任务中的，按照FIFO的原则，mainSync() 先被添加到主队列，应该先执行完，但是任务1在等待 mainSync() 执行完才会执行，任务1执行完 mainSync() 这个任务才算执行完，所以 mainSync() 同时也在等待任务1。
             这样就造成了死锁，互相等待对方完成任务。
  */
            self.performSelector(inBackground: #selector(mainSync), with: nil)      //在其它线程中执行
            
        case 5:
            
            mainAsync()
            
        case 6:
            
            workItem()
            
        case 7:
            
            dispatchGroup()
            
        case 8:
            
            barrierAsync()
            
        case 9:
            
            semaphore()
            
        case 10:
            
            dispatchQoS()
            
        case 11:
            
            asyncAfter()
            
        case 12:
            
            concurrentPerform()
            
        default:
            
            countTimer()
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

// MARK: - 串行队列 + 同步
extension GCDTableViewController {
    
    func serialSync() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 创建串行队列（DispatchQueue默认是串行队列）
        let serialQueue = DispatchQueue.init(label: "com.cishing.serialSync")
        
        // 添加同步任务1
        serialQueue.sync {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.3)      // 模拟耗时操作
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        // 添加同步任务2
        serialQueue.sync {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")  // 模拟耗时操作
            }
        }
        
        print("#------mission end------#")
        print("结果: 任务在当前线程中按顺序执行，阻塞当前线程")
    }
}

// MARK: - 串行队列 + 异步
extension GCDTableViewController {
    
    func serialAsync() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 创建串行队列（DispatchQueue默认是串行队列）
        let serialQueue = DispatchQueue.init(label: "com.cishing.serialAsync")
        
        // 添加异步任务1
        serialQueue.async {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.3)      // 模拟耗时操作
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        // 添加异步任务2
        serialQueue.async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")  // 模拟耗时操作
            }
        }
        
        print("#------mission end------#")
        print("结果: （只）开启一个新线程，任务在新线程中按顺序执行，不阻塞当前线程")
    }
}

// MARK: - 并发队列 + 同步
extension GCDTableViewController {
    
    // 系统提供的全局并发队列可以作为普通并发队列使用
    func concurrentSync() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 创建并发队列
        let concurrentQueue = DispatchQueue.init(label: "com.cishing.concurrentSync", attributes: .concurrent)
        
        // 添加同步任务1
        concurrentQueue.sync {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.3)      // 模拟耗时操作
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        // 添加同步任务2
        concurrentQueue.sync {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")  // 模拟耗时操作
            }
        }
        
        print("#------mission end------#")
        print("结果: 任务在当前线程中按顺序执行，阻塞当前线程")
    }
}

// MARK: - 并发队列 + 异步
extension GCDTableViewController {
    
    // 系统提供的全局并发队列可以作为普通并发队列使用
    func concurrentAsync() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 创建并发队列
        let concurrentQueue = DispatchQueue.init(label: "com.cishing.concurrentAsync", attributes: .concurrent)
        
        // 添加异步任务1
        concurrentQueue.async {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.3)      // 模拟耗时操作
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        // 添加异步任务2
        concurrentQueue.async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")  // 模拟耗时操作
            }
        }
        
        print("#------mission end------#")
        print("结果: 开启多个线程，任务（交替）执行，不阻塞当前线程")
    }
}

// MARK: - 主队列 + 同步
extension GCDTableViewController {
    
    // 主队列（串行队列）：UI操作所在队列
    @objc func mainSync() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 获取主队列
        let mainQueue = DispatchQueue.main
        
        // 添加同步任务1
        mainQueue.sync {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.3)      // 模拟耗时操作
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        // 添加同步任务2
        mainQueue.sync {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")  // 模拟耗时操作
            }
        }
        
        print("#------mission end------#")
        print("结果: 在主线程中执行 主队列 + 同步，造成死锁。在其它线程中执行，任务在（主线程）中按顺序执行")
    }
}

// MARK: - 主队列 + 异步
extension GCDTableViewController {
    
    // 主队列（串行队列）：UI操作所在队列
    func mainAsync() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 获取主队列
        let mainQueue = DispatchQueue.main
        
        // 添加异步任务1
        mainQueue.async {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.3)      // 模拟耗时操作
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        // 添加异步任务2
        mainQueue.async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")  // 模拟耗时操作
            }
        }
        
        print("#------mission end------#")
        print("结果: 主队列不会开启新的线程，任务按顺序在主线程中执行")
    }
}

// MARK: - DispatchWorkItem
extension GCDTableViewController {
    
    // DispatchWorkItem是一个代码块，它可以在任意一个队列上被调用。
    // 可以使用它的通知完成回调任务
    func workItem() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 创建DispatchWorkItem
        let workItem = DispatchWorkItem.init {
            
            for _ in 0...2 {
                
                print("workItem mission: \(Thread.current)")
            }
        }
        
        // 执行完后通知
        workItem.notify(queue: DispatchQueue.main) {
            
            print("workItem mission finished: \(Thread.current)")
        }
        
//        workItem.perform()  // 对象方法同步执行，会阻塞当前线程
        
        // 全局队列（并发队列）异步执行
        DispatchQueue.global().async(execute: workItem)
        
//        workItem.wait() // 任务等待，会阻塞当前线程
        
        print("#------mission end------#")
    }
}

// MARK: - DispatchGroup
extension GCDTableViewController {
    
    // 几个队列执行任务，然后把这些队列都放到一个组Group里，当组里所有队列的任务都完成了之后，Group发出通知，回到主队列完成其他任务
    func dispatchGroup() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let group = DispatchGroup()
        
        // 全局并发队列异步执行
        DispatchQueue.global().async(group: group) {    // 1)直接添加到指定group
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        group.wait()      // 如果需要队列前部分任务全部执行结束后再执行后部分队列任务，使用 wait() 会阻塞当前线程
        group.enter()   // 2)使用enter leave配对方法，标识任务加入group
        
        // 自定义并发队列异步执行
        DispatchQueue.init(label: "com.cishing.concurrent", attributes: .concurrent).async {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.3)
                
                print("missionTwo: \(Thread.current)")
            }
            
            group.leave()
        }
        
        // group中所有队列全部任务执行结束后通知
        group.notify(queue: DispatchQueue.main) {
            
            print("group中所有队列全部任务执行结束: \(Thread.current)")
        }
        
        print("#------mission end------#")
    }
}

// MARK: - dispatch_barrier_async
extension GCDTableViewController {
    
    func barrierAsync() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 创建并发队列
        let queue = DispatchQueue.init(label: "com.cishing.concurrent", attributes: .concurrent)
        
        // 添加异步任务1
        queue.async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionOne: \(Thread.current)")
            }
        }
        
        // 添加异步任务2
        queue.async {
            
            for _ in 0...3 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionTwo: \(Thread.current)")
            }
        }
        
        // 添加栅栏，等待队列里前面任务执行完再执行（可以理解为阻塞当前队列）
        queue.async(flags: .barrier) {
            
            for _ in 0...1 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("barrierMission: \(Thread.current)")
            }
            
            // 执行完之后再执行队列后面的任务
        }
        
        // 添加异步任务3
        queue.async {
        
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionThree: \(Thread.current)")
            }
        }
        
        print("#------mission end------#")
    }
}

// MARK: - DispatchSemaphore
extension GCDTableViewController {
    
    /*
    DispatchSemaphore(value: )：用于创建信号量，可以指定初始化信号量计数值。
    semaphore.wait()：信号量-1，会判断信号量，如果大于等于0，则往下执行。如果小于0，则等待。
    semaphore.signal()：代表运行结束，信号量加1，有等待的任务这个时候才会继续执行。
    */
    func semaphore() {
        
        // 限制同时执行的任务数
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let semaphore = DispatchSemaphore(value: 2)     // 初始化信号量计数为0
        
        semaphore.wait()  // 信号量-1，如果信号量计数小于0则等待，大于等于0则往下执行
//        semaphore.wait(timeout: <#T##DispatchTime#>)
//        semaphore.wait(wallTimeout: <#T##DispatchWallTime#>)
        
        DispatchQueue.global().async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionOne: \(Thread.current)")
            }
            
            semaphore.signal()  // 信号量计数+1
        }
        
        semaphore.wait()
        
        DispatchQueue.init(label: "com.cishing.concurrent", attributes: .concurrent).async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.3)
                
                print("missionTwo: \(Thread.current)")
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        
        DispatchQueue.global().async {
        
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("missionThree: \(Thread.current)")
            }
            
            semaphore.signal()
        }
        
        print("#------mission end------#")
    }
}

// MARK: - DispatchQoS
extension GCDTableViewController {
    
    // 优先级高的任务完成的更快
    func dispatchQoS() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let queue = DispatchQueue.init(label: "com.cishing.concurrent", attributes: .concurrent)

        // 低优先级任务
        queue.async(qos: .default) {

            for _ in 0...2 {

                Thread.sleep(forTimeInterval: 0.2)

                print("lowMission: \(Thread.current)")
            }
        }

        // 高优先级任务
        queue.async(qos: .userInteractive) {

            for _ in 0...2 {

                Thread.sleep(forTimeInterval: 0.2)

                print("hightMission: \(Thread.current)")
            }
        }
        
        queue.async(flags: .barrier) {
            
            semaphore.signal()
        }
        
        semaphore.wait()
        
        // 低优先级队列
        DispatchQueue.init(label: "com.cishing.lowQueue", qos: .default, attributes: .concurrent).async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("lowQueueMission: \(Thread.current)")
            }
        }
        
        // 高优先级队列
        DispatchQueue.init(label: "com.cishing.hightQueue", qos: .userInteractive, attributes: .concurrent).async {
            
            for _ in 0...2 {
                
                Thread.sleep(forTimeInterval: 0.2)
                
                print("hightQueueMission: \(Thread.current)")
            }
        }
        
        print("#------mission end------#")
    }
}

// MARK: - asyncAfter
extension GCDTableViewController {
    
    // 延迟执行
    func asyncAfter() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        // 延迟把任务加到相应队列中执行
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            
            print("mission: \(Thread.current)")
        }
        
        print("#------mission end------#")
    }
}

// MARK: - concurrentPerform
extension GCDTableViewController {
    
    // 迭代任务
    func concurrentPerform() {
        
        print("currentThread: \(Thread.current)")
        print("#------mission start------#")
        
        let array = Array(1...100)
        var result: [Int] = []
        
        DispatchQueue.global().async {
            
            // iterations: 迭代次数
            DispatchQueue.concurrentPerform(iterations: 100, execute: { (index) in
                
                // 利用 CPU 当前所有可用线程进行计算（任务小也可能只用一个线程）
                
                if array[index] % 13 == 0 {
                    
                    print("find a match \(array[index]) at thread: \(Thread.current)")
                    
                    DispatchQueue.main.async {
                        
                        result.append(array[index])
                    }
                }
            })
            
            // 迭代任务的后续任务需要等待它执行完成才会继续
            DispatchQueue.main.async {
                
                print("result: find \(result.count) number - \(result)")
            }
        }
        
        print("#------mission end------#")
    }
}

// MARK: - DispatchSource
extension GCDTableViewController {
    
    func countTimer() {
        
        var count = 10
        
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: 1.0)
        timer.setEventHandler {     // 事件处理
            
            // 实际使用过程中需要考虑闭包强引用self导致的内存泄露问题 使用闭包捕获列表解决
            
            if count > 0 {
                
                print("count: \(count)")
                
                count -= 1
                
            }else {
                
                timer.cancel()
            }
        }
        
        timer.setCancelHandler {    // 事件结束处理
            
            print("倒计时结束")
        }
        
        timer.resume()  // 必须调用resume方法开始接收事件
    }
}



