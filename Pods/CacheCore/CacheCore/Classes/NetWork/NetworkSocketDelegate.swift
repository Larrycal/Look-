//
// NetworkSocketDelegate.swift
// CacheCore
//
// Created by 柳钰柯 on 2018/4/17.
// Copyright (c) 2018 Larry. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

open class NetworkSocketDelegate: NSObject,GCDAsyncSocketDelegate {
    // MARK: - 公共属性
    /**
     * This method is called immediately prior to socket:didAcceptNewSocket:.
     * It optionally allows a listening socket to specify the socketQueue for a new accepted socket.
     * If this method is not implemented, or returns NULL, the new accepted socket will create its own default queue.
     *
     * Since you cannot autorelease a dispatch_queue,
     * this method uses the "new" prefix in its name to specify that the returned queue has been retained.
     *
     * Thus you could do something like this in the implementation:
     * return dispatch_queue_create("MyQueue", NULL);
     *
     * If you are placing multiple sockets on the same queue,
     * then care should be taken to increment the retain count each time this method is invoked.
     *
     * For example, your implementation might look something like this:
     * dispatch_retain(myExistingQueue);
     * return myExistingQueue;
     **/
    public var newSocketQueueForConnectionHandler: ((_ address: Data, _ sock: GCDAsyncSocket) -> NSObject?)?
    
    /**
     * Called when a socket accepts a connection.
     * Another socket is automatically spawned to handle it.
     *
     * You must retain the newSocket if you wish to handle the connection.
     * Otherwise the newSocket instance will be released and the spawned connection will be closed.
     *
     * By default the new socket will have the same delegate and delegateQueue.
     * You may, of course, change this at any time.
     **/
    public var socketDidAcceptNewSocketHandler: ((_ sock: GCDAsyncSocket, _ newSocket: GCDAsyncSocket) -> Void)?
    
    
    /// Called when a socket connects and is ready for reading and writing.
    public var socketDidConnectToHostHandler: ((_ sock: GCDAsyncSocket, _ host: String, _ port: UInt16) -> Void)?
    
    /**
     * Called when a socket connects and is ready for reading and writing.
     * The host parameter will be an IP address, not a DNS name.
     **/
    public var socketDidConnectToURLHandler: ((_ sock: GCDAsyncSocket, _ url: URL) -> Void)?
    
    /**
     * Called when a socket has completed reading the requested data into memory.
     * Not called if there is an error.
     **/
    public var socketDidReadDataWithTagHandler: ((_ sock: GCDAsyncSocket, _ data: Data, _ tag: Int) -> Void)?
    
    /**
     * Called when a socket has read in data, but has not yet completed the read.
     * This would occur if using readToData: or readToLength: methods.
     * It may be used to for things such as updating progress bars.
     **/
    public var socketDidReadPartialDataOfLengthHandler: ((_ sock: GCDAsyncSocket,
    _ partialLength: UInt,
    _ tag: Int) -> Void)?
    
    /// Called when a socket has completed writing the requested data. Not called if there is an error.
    public var socketDidWriteDataWithTagHandler: ((_ sock: GCDAsyncSocket, _ tag: Int) -> Void)?
    
    /**
     * Called when a socket has written some data, but has not yet completed the entire write.
     * It may be used to for things such as updating progress bars.
     **/
    public var socketDidWritePartialDataOfLengthHandler: ((_ sock: GCDAsyncSocket,
    _ partialLength: UInt,
    _ tag: Int) -> Void)?
    
    /**
     * Called if a read operation has reached its timeout without completing.
     * This method allows you to optionally extend the timeout.
     * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
     * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
     *
     * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
     * The length parameter is the number of bytes that have been read so far for the read operation.
     *
     * Note that this method may be called multiple times for a single read if you return positive numbers.
     **/
    public var socketShouldTimeoutReadWithTagHandler: ((_ sock: GCDAsyncSocket,
    _ tag: Int,
    _ elapsed: TimeInterval,
    _ length: UInt) -> TimeInterval)?
    
    /**
     * Called if a write operation has reached its timeout without completing.
     * This method allows you to optionally extend the timeout.
     * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
     * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
     *
     * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
     * The length parameter is the number of bytes that have been written so far for the write operation.
     *
     * Note that this method may be called multiple times for a single write if you return positive numbers.
     **/
    public var socketShouldTimeoutWriteWithTagHandler: ((_ sock: GCDAsyncSocket,
    _ tag: Int,
    _ elapsed: TimeInterval,
    _ length: UInt) -> TimeInterval)?
    
    /**
     * Conditionally called if the read stream closes, but the write stream may still be writeable.
     *
     * This delegate method is only called if autoDisconnectOnClosedReadStream has been set to NO.
     * See the discussion on the autoDisconnectOnClosedReadStream method for more information.
     **/
    public var socketDidCloseReadStreamHandler: ((_ sock: GCDAsyncSocket) -> Void)?
    
    /**
     * Called when a socket disconnects with or without error.
     *
     * If you call the disconnect method, and the socket wasn't already disconnected,
     * then an invocation of this delegate method will be enqueued on the delegateQueue
     * before the disconnect method returns.
     *
     * Note: If the GCDAsyncSocket instance is deallocated while it is still connected,
     * and the delegate is not also deallocated, then this method will be invoked,
     * but the sock parameter will be nil. (It must necessarily be nil since it is no longer available.)
     * This is a generally rare, but is possible if one writes code like this:
     *
     * asyncSocket          = nil;// I'm implicitly disconnecting the socket
     *
     * In this case it may preferrable to nil the delegate beforehand, like this:
     *
     * asyncSocket.delegate = nil;// Don't invoke my delegate method
     * asyncSocket          = nil;// I'm implicitly disconnecting the socket
     *
     * Of course, this depends on how your state machine is configured.
     **/
    public var socketDidDisconnectWithErrorHandler: ((_ sock: GCDAsyncSocket, _ err: Error?) -> Void)?
    
    /**
     * Called after the socket has successfully completed SSL/TLS negotiation.
     * This method is not called unless you use the provided startTLS method.
     *
     * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
     * and the socketDidDisconnect:withError: delegate method will be called with the specific SSL error code.
     **/
    public var socketDidSecureHandler: ((_ sock: GCDAsyncSocket) -> Void)?
    
    /**
     * Allows a socket delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
     *
     * This is only called if startTLS is invoked with options that include:
     * - GCDAsyncSocketManuallyEvaluateTrust == YES
     *
     * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
     *
     * Note from Apple's documentation:
     *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
     *   [it] might block while attempting network access. You should never call it from your main thread;
     *   call it only from within a function running on a dispatch queue or on a separate thread.
     *
     * Thus this method uses a completionHandler block rather than a normal return value.
     * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
     * It is safe to invoke the completionHandler block even if the socket has been closed.
     **/
    public var socketDidReceiveTrustHandler: ((_ sock: GCDAsyncSocket,
    _ trust: SecTrust,
    _ completionHandler: ((Bool) -> Void)) -> Void)?
    
    // MARK: - GCDAsyncSocketDelegate
    public func newSocketQueueForConnection(fromAddress address: Data, on sock: GCDAsyncSocket) -> NSObject? {
        if let handler = self.newSocketQueueForConnectionHandler {
            return handler(address, sock)
        }
        return nil
    }
    
    public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        self.socketDidAcceptNewSocketHandler?(sock, newSocket)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        self.socketDidConnectToHostHandler?(sock, host, port)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        self.socketDidConnectToURLHandler?(sock, url)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        self.socketDidReadDataWithTagHandler?(sock, data, tag)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        self.socketDidReadPartialDataOfLengthHandler?(sock, partialLength, tag)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        self.socketDidWriteDataWithTagHandler?(sock, tag)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didWritePartialDataOfLength partialLength: UInt, tag: Int) {
        self.socketDidWritePartialDataOfLengthHandler?(sock, partialLength, tag)
    }
    
    public func socket(_ sock: GCDAsyncSocket,
                       shouldTimeoutReadWithTag tag: Int,
                       elapsed: TimeInterval,
                       bytesDone length: UInt) -> TimeInterval {
        if let handler = self.socketShouldTimeoutReadWithTagHandler {
            return handler(sock, tag,elapsed, length)
        }
        fatalError("socket(sock:tag:elapsed:length:) has not been implemented")
    }
    
    public func socket(_ sock: GCDAsyncSocket,
                       shouldTimeoutWriteWithTag tag: Int,
                       elapsed: TimeInterval,
                       bytesDone length: UInt) -> TimeInterval {
        if let handler = self.socketShouldTimeoutWriteWithTagHandler {
            return handler(sock, tag,elapsed, length)
        }
        fatalError("socket(sock:tag:elapsed:length:) has not been implemented")
    }
    
    public func socketDidCloseReadStream(_ sock: GCDAsyncSocket) {
        self.socketDidCloseReadStreamHandler?(sock)
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.socketDidDisconnectWithErrorHandler?(sock, err)
    }
    
    public func socketDidSecure(_ sock: GCDAsyncSocket) {
        self.socketDidSecureHandler?(sock)
    }
    
    public func socket(_ sock: GCDAsyncSocket,
                       didReceive trust: SecTrust,
                       completionHandler: @escaping (Bool) -> Void) {
        self.socketDidReceiveTrustHandler?(sock, trust, completionHandler)
    }
}
