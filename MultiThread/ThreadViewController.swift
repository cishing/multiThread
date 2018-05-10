//
//  ThreadViewController.swift
//  MultiThread
//
//  Created by XiaShiyang on 2018/4/25.
//  Copyright © 2018年 cishing. All rights reserved.
//

import UIKit

class ThreadViewController: UIViewController {

    @IBOutlet weak var showImgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }

    // MARK: - initWithTarget方式，先创建线程对象，再启动
    @IBAction func initWithTarget(_ sender: UIButton) {
        
        if #available(iOS 10.0, *) {
            
            // 创建线程
            let thread = Thread.init {
                
                print(Thread.current)
            }
            
            thread.name = "initWithTarget"      // 设置线程名字
            thread.threadPriority = 0.9         // 设置优先级，优先级从0.0~1.0，1最高
            thread.start()                      // 启动线程
            
        } else {
            
            // 10.0之前使用
            // Thread.init(target: <#T##Any#>, selector: <#T##Selector#>, object: <#T##Any?#>)
        }
    }
    
    // MARK: - detachNewThreadSelector显式创建并启动线程
    @IBAction func detachNewThreadSelector(_ sender: UIButton) {
        
        if #available(iOS 10.0, *) {
            
            // 创建并启动
            Thread.detachNewThread {
                
                print(Thread.current)
            }
            
        } else {
            
            // 10.0之前使用
            // Thread.detachNewThreadSelector(<#T##selector: Selector##Selector#>, toTarget: <#T##Any#>, with: <#T##Any?#>)
        }
    }
    
    // MARK: - NSObject performSelectorInBackground隐式创建并启动线程
    @IBAction func performSelectorInBackground(_ sender: UIButton) {
        
        // 创建并启动
        self.performSelector(inBackground: #selector(backgroundThread), with: nil)
    }
    
    @objc func backgroundThread() {
        
        print(Thread.current)
    }
    
    // MARK: - 取消线程和退出线程
    // 当使用cancel方法时，只是改变了线程状态标识，并不是结束线程
    @IBAction func cancelAndExit(_ sender: UIButton) {
        
        self.performSelector(inBackground: #selector(cancelAndExitShow), with: nil)
    }
    
    @objc func cancelAndExitShow() {
        
        for index in 0...20 {
            
            print("index = \(index)")
            
            if index == 10 {
                
                print("取消线程：\(Thread.current)")
                
                Thread.current.cancel()         // 改变线程状态标识
            }
            
            if Thread.current.isCancelled {     // 判断线程状态
                
                // "取消"状态，结束线程
                print("结束线程：\(Thread.current)")
                
                Thread.exit()
                
                print("线程结束后，代码不会执行")
            }
        }
    }
    
    // MARK: - 子线程耗时任务，回主线程更新UI
    @IBAction func childThreadToMain(_ sender: UIButton) {
        
        let urlStr = "https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png"
        
        self.performSelector(inBackground: #selector(downLoadImg(_:)), with: urlStr)
    }
    
    @objc func downLoadImg(_ urlStr: String) {
        
        print("子线程下载图片：\(Thread.current)")
        
        guard let imgUrl = URL(string: urlStr) else { return }
        
        guard let imgData = try? Data.init(contentsOf: imgUrl) else { return }
        
        guard let image = UIImage(data: imgData) else { return }
        
        self.performSelector(onMainThread: #selector(finishLoadImg(_:)), with: image, waitUntilDone: false)
    }
    
    @objc func finishLoadImg(_ image: UIImage) {
        
        print("主线程更新UI：\(Thread.current)")
        
        showImgView.image = image
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
