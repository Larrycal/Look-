//
//  NetworkSocketManager.swift
//  CacheCore
//
//  Created by 柳钰柯 on 2018/4/24.
//  Copyright © 2018年 Larry. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class NetWorkSocketManager {
    
    var port:UInt16
    var host:String
    var config: CacheBusinessConfig
    
    public init(host: String,port: UInt16,config: CacheBusinessConfig) {
        self.host = host
        self.port = port
        self.config = config
    }
    
    public func start() {
        debugPrint("开始socket测试")
        self.configDelegate()
        do {
            try self.socket.connect(toHost: host, onPort: port)
        } catch {
            debugPrint("socket链接失败")
        }
        self.openSocketBackgroundThread()
    }
    
    func configDelegate() {
        self.socketDelegate.socketDidReadDataWithTagHandler = {
            [unowned self](_ sock: GCDAsyncSocket, _ data: Data, _ tag: Int) -> Void in
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments)
                if let jsonArray = jsonObject as? [String:[String]] {
                    if jsonArray["values"] != nil {
                        DataBaseManager.shared.deleteDataWith(config: self.config, values: jsonArray["values"]!, callBack: { (isSuccess) in
                            if isSuccess {
                                debugPrint("删除\(jsonArray["values"]!)等数据成功")
                            } else {
                                debugPrint("删除数据失败")
                            }
                        })
                    }
                }
            } catch  {
                debugPrint("data to jsonObject 失败")
            }
        }
        self.socketDelegate.socketDidConnectToHostHandler = {
            (_ sock: GCDAsyncSocket, _ host: String, _ port: UInt16) -> Void in
            debugPrint("链接到 host: \(host) port:\(port) 成功")
            self.socket.readData(withTimeout: -1, tag: 0)
        }
        
        self.socketDelegate.socketDidWriteDataWithTagHandler = {
            (_ sock: GCDAsyncSocket, _ tag: Int) -> Void in
            debugPrint("发送数据成功")
            self.socket.readData(withTimeout: -1, tag: 0)
        }
    }
    
    func openSocketBackgroundThread() {
        let socketThread = Thread(target: self, selector: #selector(onBackgroundThreadToReadData), object: nil)
        socketThread.start()
    }
    
    // MARK: - 事件响应
    @objc func onBackgroundThreadToReadData() {
        debugPrint("当前线程：\(Thread.current)  主线程：\(Thread.main)")
        // 开启runloop
        let runloop = RunLoop.current
        runloop.add(Timer(timeInterval: 0.5, repeats: true, block: { [unowned self](timer) in
            self.socket.readData(withTimeout: -1, tag: 0)
        }), forMode: RunLoopMode.defaultRunLoopMode)
        runloop.add(Timer(timeInterval: 25, repeats: true, block: { [unowned self](timer) in
            if let d = "alive".data(using: String.Encoding.utf8) {
                self.socket.write(d, withTimeout: -1, tag: 0)
            }
        }), forMode: RunLoopMode.defaultRunLoopMode)
        runloop.run()
    }
    
    lazy var socket:GCDAsyncSocket = {
        let temp = GCDAsyncSocket(delegate: self.socketDelegate, delegateQueue: DispatchQueue.global())
        return temp
    }()
    
    lazy var socketDelegate:NetworkSocketDelegate = {
        let temp = NetworkSocketDelegate()
        return temp
    }()
}

extension String {
    public func dropReturnSymbol() -> String {
        if self.count > 1 {
            // 由于下标索引是确定上界或者下界的包含单向区间
            let returnIndex = self.index(self.startIndex, offsetBy: self.count - 1)
            let otherIndex = self.index(self.startIndex, offsetBy: self.count - 2)
            if self[returnIndex...] == "\n" {
                return String(self[...otherIndex])
            } else {
                return self
            }
        } else {
            if self == "\n" {
                return ""
            } else {
                return self
            }
        }
    }
}
