//
//  ViewController.swift
//  9
//
//  Created by student on 2018/12/13.
//  Copyright © 2018年 wyf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Custom View"
        self.view.backgroundColor = UIColor.white
        
        let addBtn = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(addView))
        let moveBtn = UIBarButtonItem(title: "移动", style: .plain, target: self, action: #selector(moveViews))
        self.navigationItem.rightBarButtonItems = [addBtn, moveBtn]
        
        let clearBtn = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(clearView))
        self.navigationItem.leftBarButtonItem = clearBtn

    }
    @objc func addView() {
        let maxWidth: CGFloat = 150
        
        let x = CGFloat(arc4random() % UInt32(self.view.bounds.width))
        let y = CGFloat(arc4random() % UInt32(self.view.bounds.height - 40)) + 40
        let point = CGPoint(x: x, y: y)
        
        let width = CGFloat(arc4random() % UInt32(maxWidth))
        let height = CGFloat(arc4random() % UInt32(maxWidth))
        let size = CGSize(width: width, height: height)
        
        let view = MyView(frame: CGRect(origin: point, size: size))
        self.view.addSubview(view)
    }
    @objc func clearView() {
        self.view.subviews.map { $0.removeFromSuperview() }
    }
    @objc func moveViews() {
        self.view.subviews.map { (view) in
            let x = CGFloat(arc4random() % UInt32(self.view.bounds.width))
            let y = CGFloat(arc4random() % UInt32(self.view.bounds.height - 40)) + 40
            let point = CGPoint(x: x, y: y)
            
            UIView.animate(withDuration: 3, animations: {
                view.center = point
            })
        }
    }
 
}

class MyView: UIView{
    ///重写draw方法
    override func draw(_ rect: CGRect) {
        let viewRect = UIBezierPath(rect: rect)
        ///使用arc4random()方法来生成一个随机数，这个方法会返回一个UInt32的随机数，然后使用这个方法来生成rgb颜色，使用该颜色填充和描边矩形区域。
        let redColor = CGFloat(Float(arc4random() % 255) / 255)
        let greenColor = CGFloat(Float(arc4random() % 255) / 255)
        let blueColor = CGFloat(Float(arc4random() % 255) / 255)
        UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0).set()
        viewRect.stroke()
        viewRect.fill()
    }
    ///重写一个初始化函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    ///如果子类自己重写了初始化函数的话，也必须实现UIView的另一个初始化函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    ///把这些添加的功能放在一个setup()方法当中
    func setup() {
        //设置矩形区域圆角
        self.layer.cornerRadius = 20
        //设置阴影
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.8
        //设置视图的内容模式为重绘
        self.contentMode = .redraw
        //pan移动
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        self.addGestureRecognizer(panGesture)
        
        //tap删除
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
        self.addGestureRecognizer(tapGesture)
        
        //pinch缩放
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        self.addGestureRecognizer(pinchGesture)
        
        //rotation旋转
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotation(gestrue:)))
        self.addGestureRecognizer(rotationGesture)
    }
    //pan移动
    @objc func pan(gesture: UIPanGestureRecognizer) {
        self.center = gesture.location(in: superview)
    }
    
    //tap删除
    @objc func tap(gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    //pinch缩放
    @objc func pinch(gesture: UIPinchGestureRecognizer) {
        let scale = gesture.scale
        self.transform = self.transform.scaledBy(x: scale, y: scale)
        gesture.scale = 1
    }
    
    //rotation旋转
    @objc func rotation(gestrue: UIRotationGestureRecognizer) {
        let rotation = gestrue.rotation
        self.transform = self.transform.rotated(by: rotation)
        gestrue.rotation = 0
    }
}

