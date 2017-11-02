//
//  YCheckVersionView.swift
//  YCheckVersionView
//
//  Created by shusy on 2017/11/2.
//  Copyright © 2017年 杭州爱卿科技. All rights reserved.
//

import UIKit

class YCheckVersionView: UIView {
    
    /// 顶部显示的图片
    public var topImage:String = "wf_appupdate_bg"{
        didSet{
            if topImage == oldValue { return}
            topImageView.image = UIImage(named: topImage)
            caculateTopImageSize()
            topImageView.updateConstraints()
        }
    }
    /// 右上角关闭显示的背景图片
    public var closeBtnImage:String = "later-2" {
        didSet{
            if closeBtnImage == oldValue { return}
            cancelBtn.setBackgroundImage(UIImage.init(named: closeBtnImage), for: UIControlState())
        }
    }
    /// 更新按钮显示的背景图片
    public var updateBtnBgColor:UIColor = UIColor(hue: 97/255.0, saturation: 207/255.0, brightness: 202/255.0, alpha: 1.0) {
        didSet{
            if updateBtnBgColor == oldValue { return}
            bottomBtn.backgroundColor = updateBtnBgColor
        }
    }
    /// 更新描述信息
    private var detailStrArray = Array<String>()
    /// 是否强制更新
    private var isforce = Bool()
    /// 所有的描述文本控件
    private var detailAllLabel = Array<UILabel>()
    /// 版本号
    private var versionLabelText = String()
    /// 更新地址
    private var updateStringPath:String?
    
    /// 顶部显示的更新logo图
    fileprivate lazy var topImageView: UIImageView = {
        let topImageView = UIImageView.init(image: UIImage.init(named: topImage))
        topImageView.contentMode = .scaleAspectFill
        return topImageView
    }()
    
    /// 立即更新按钮
    fileprivate lazy var bottomBtn: UIButton = {
        let bottomBtn = UIButton()
        bottomBtn.layer.cornerRadius = 20
        bottomBtn.layer.masksToBounds = true
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.setTitle("立即升级", for: .normal)
        bottomBtn.backgroundColor = updateBtnBgColor
        return bottomBtn
    }()
    
    /// 关闭按钮
    fileprivate lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.setBackgroundImage(UIImage.init(named: closeBtnImage), for: UIControlState())
        return cancelBtn
    }()
    
    /// 提示标题
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.text = "版本更新说明"
        return titleLabel
    }()
    
    /// 蒙版
    fileprivate lazy var backView: UIView = {
        let backView = UIView.init(frame: UIScreen.main.bounds)
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.2
        return backView
    }()
    
    /// 内容视图
    fileprivate lazy var versionView: UIView = {
        let versionView = UIView()
        versionView.backgroundColor = UIColor.white
        versionView.clipsToBounds = true
        versionView.layer.cornerRadius = 5
        return versionView
    }()
    
    /// 更新文本
    fileprivate lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.backgroundColor = UIColor.clear
        versionLabel.textAlignment = .center
        versionLabel.textColor = UIColor.white
        return versionLabel
    }()
    
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - updatedDelArray: 更新描述信息
    ///   - isForcedUpdate: 是否强制更新
    ///   - versionStr:  新的版本号
    ///   - updateURLString:  更新地址
    init(updatedDelArray : Array<String>, isForcedUpdate : Bool, versionStr: String, updateURLString: String) {
        super.init(frame: UIScreen.main.bounds)
        self.detailStrArray = updatedDelArray
        self.isforce = isForcedUpdate
        self.updateStringPath = updateURLString
        self.versionLabelText = versionStr
        if self.isforce {
            self.cancelBtn.isHidden = true
        }else{
            self.cancelBtn.isHidden = false
        }
        self.creatUI()
    }

    /// 布局界面
    func creatUI() {
        self.addSubview(self.backView)
        self.versionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.versionView)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.versionView.addSubview(self.titleLabel)
        self.topImageView.translatesAutoresizingMaskIntoConstraints = false
        self.versionView.addSubview(self.topImageView)
        self.cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        self.versionView.addSubview(self.cancelBtn)
        self.versionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.versionView.addSubview(self.versionLabel)
        self.versionLabel.text = self.versionLabelText
        self.bottomBtn.translatesAutoresizingMaskIntoConstraints = false
        self.versionView.addSubview(self.bottomBtn)
        self.bottomBtn.addTarget(self, action: #selector(updateRightNow(_:)), for: .touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(updateLater(_:)), for: .touchUpInside)
        self.creatAllLabel()
        self.setLayout()
    }
    
    /// 创建所有描述文本
    func creatAllLabel() {
        for str in self.detailStrArray {
            let detailLabel = UILabel()
            detailLabel.text = str
            detailLabel.textColor = UIColor.gray
            detailLabel.font = UIFont.systemFont(ofSize: 14)
            detailLabel.textAlignment = .center
            detailLabel.numberOfLines = 0
            self.detailAllLabel.append(detailLabel)
            self.versionView.addSubview(detailLabel)
        }
    }
    
    /// 布局视图位置
    func setLayout() {
        
        /// 布局容器视图
        let versionViewLeft = NSLayoutConstraint.init(item: self.versionView, attribute: .left, relatedBy: .equal, toItem: self.backView, attribute: .left, multiplier: 1.0, constant: 30.0)
        let versionViewCenterX = NSLayoutConstraint.init(item: self.versionView, attribute: .centerX, relatedBy: .equal, toItem: self.backView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let versionViewCenterY = NSLayoutConstraint.init(item: self.versionView, attribute: .centerY, relatedBy: .equal, toItem: self.backView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let versionViewRight = NSLayoutConstraint.init(item: self.versionView, attribute: .right, relatedBy: .equal, toItem: self.backView, attribute: .right, multiplier: 1.0, constant: -30.0)
        versionViewLeft.isActive = true
        versionViewCenterX.isActive = true
        versionViewCenterY.isActive = true
        versionViewRight.isActive = true
        
        /// 布局顶部图片视图
        let topImageViewLeft = NSLayoutConstraint.init(item: self.topImageView, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let topImageViewRight = NSLayoutConstraint.init(item: self.topImageView, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topImageViewTop = NSLayoutConstraint.init(item: self.topImageView, attribute: .top, relatedBy: .equal, toItem: self.versionView, attribute: .top, multiplier: 1.0, constant: 0.0)
        topImageViewLeft.isActive = true
        topImageViewRight.isActive = true
        topImageViewTop.isActive = true
        caculateTopImageSize()
        
        /// 布局版本号视图
        let versionLabelCenterX = NSLayoutConstraint.init(item: self.versionLabel, attribute: .centerX, relatedBy: .equal, toItem: self.versionView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let versionLabelBottom = NSLayoutConstraint.init(item: self.versionLabel, attribute: .bottom, relatedBy: .equal, toItem: self.topImageView, attribute: .bottom, multiplier: 1.0, constant: -30.0)
        let versionLabelHeight = NSLayoutConstraint.init(item: self.versionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        versionLabelCenterX.isActive = true
        versionLabelBottom.isActive = true
        versionLabelHeight.isActive = true
        
        /// 布局关闭按钮视图
        let cancelBtnWidth = NSLayoutConstraint.init(item: self.cancelBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        let cancelBtnHeight = NSLayoutConstraint.init(item: self.cancelBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0)
        let cancelBtnRight = NSLayoutConstraint.init(item: self.cancelBtn, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -10.0)
        let cancelBtnTop = NSLayoutConstraint.init(item: self.cancelBtn, attribute: .top, relatedBy: .equal, toItem: self.versionView, attribute: .top, multiplier: 1.0, constant: 10)
        cancelBtnWidth.isActive = true
        cancelBtnHeight.isActive = true
        cancelBtnTop.isActive = true
        cancelBtnRight.isActive = true
        
        /// 布局显示标题视图
        let titleLabelCenterX = NSLayoutConstraint.init(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.versionView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let titleLabelTop = NSLayoutConstraint.init(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self.topImageView, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        titleLabelTop.isActive = true
        titleLabelCenterX.isActive = true
        
        //根据描述文本的个数调整位置
        if self.detailStrArray.count > 0 {
            if self.detailStrArray.count == 1 {
                let label = self.detailAllLabel[0]
                label.translatesAutoresizingMaskIntoConstraints = false
                let labelLeft = NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 10.0)
                let labelRight = NSLayoutConstraint.init(item: label, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -10.0)
                let labelTop = NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1.0, constant: 10.0)
                labelLeft.isActive = true
                labelRight.isActive = true
                labelTop.isActive = true
            }
            
            if self.detailStrArray.count == 2 {
                let label1 = self.detailAllLabel[0]
                label1.translatesAutoresizingMaskIntoConstraints = false
                let label1Left = NSLayoutConstraint.init(item: label1, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 10.0)
                let label1Right = NSLayoutConstraint.init(item: label1, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -10.0)
                let label1Top = NSLayoutConstraint.init(item: label1, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1.0, constant: 10.0)
                label1Left.isActive = true
                label1Right.isActive = true
                label1Top.isActive = true
                
                let label2 = self.detailAllLabel[1]
                label2.translatesAutoresizingMaskIntoConstraints = false
                let label2Left = NSLayoutConstraint.init(item: label2, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 10.0)
                let label2Right = NSLayoutConstraint.init(item: label2, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -10.0)
                let label2Top = NSLayoutConstraint.init(item: label2, attribute: .top, relatedBy: .equal, toItem: label1, attribute: .bottom, multiplier: 1.0, constant: 10.0)
                label2Left.isActive = true
                label2Right.isActive = true
                label2Top.isActive = true
            }
            
            if self.detailStrArray.count > 2 {
                
                for (index, label) in self.detailAllLabel.enumerated() {
                    label.translatesAutoresizingMaskIntoConstraints = false
                    if index == 0 {
                        let labelLeft = NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 10.0)
                        let labelRight = NSLayoutConstraint.init(item: label, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -10.0)
                        let labelTop = NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1.0, constant: 10.0)
                        labelLeft.isActive = true
                        labelRight.isActive = true
                        labelTop.isActive = true
                    }else{
                        let lastLabel = self.detailAllLabel[index - 1]
                        let labelLeft = NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 10.0)
                        let labelRight = NSLayoutConstraint.init(item: label, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -10.0)
                        let labelTop = NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: lastLabel, attribute: .bottom, multiplier: 1.0, constant: 10.0)
                        labelLeft.isActive = true
                        labelRight.isActive = true
                        labelTop.isActive = true
                    }
                }
                
            }
            
            //布局立即升级按钮
            //获取
//            let bottomBtnCenterX = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .centerX, relatedBy: .equal, toItem: self.versionView, attribute: .centerX, multiplier: 0, constant: 0)
//            let bottomBtnWidth = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120)
            let bottomBtnLeft = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 80.0)
            let bottomBtnRight = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -80.0)
            let bottomBtnTop = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .top, relatedBy: .equal, toItem: self.detailAllLabel.last, attribute: .bottom, multiplier: 1.0, constant: 10.0)
            let bottomBtnBottom = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .bottom, relatedBy: .equal, toItem: self.versionView, attribute: .bottom, multiplier: 1.0, constant: -10.0)
            let bottomBtnHeight = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
            bottomBtnLeft.isActive = true
            bottomBtnRight.isActive = true
//            bottomBtnCenterX.isActive = true
//            bottomBtnWidth.isActive = true
            bottomBtnBottom.isActive = true
            bottomBtnTop.isActive = true
            bottomBtnHeight.isActive = true
        }else{
            let bottomBtnLeft = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .left, relatedBy: .equal, toItem: self.versionView, attribute: .left, multiplier: 1.0, constant: 80.0)
            let bottomBtnRight = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .right, relatedBy: .equal, toItem: self.versionView, attribute: .right, multiplier: 1.0, constant: -80.0)
            let bottomBtnTop = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1.0, constant: 10.0)
            let bottomBtnBottom = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .bottom, relatedBy: .equal, toItem: self.versionView, attribute: .bottom, multiplier: 1.0, constant: -10)
            let bottomBtnHeight = NSLayoutConstraint.init(item: self.bottomBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
            bottomBtnLeft.isActive = true
            bottomBtnRight.isActive = true
            bottomBtnBottom.isActive = true
            bottomBtnTop.isActive = true
            bottomBtnHeight.isActive = true
        }
    }
    
    /// 计算图片的等比例高度
    func caculateTopImageSize(){
        var imgH = 180
        if let image = self.topImageView.image {
            let screenw = UIScreen.main.bounds.size.width-60
            let imgw = image.size.width
            let imgh = image.size.height
            imgH = Int(screenw*imgh/imgw)
        }
        let topImageViewHeight = NSLayoutConstraint.init(item: self.topImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: CGFloat(imgH))
        topImageViewHeight.isActive = true
    }
    
 
  /// 显示当前视图
  func show() {
        UIApplication.shared.windows[0].addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 事件方法
extension YCheckVersionView {
    /// 立即更新按钮的点击
    @objc func updateRightNow(_ sender : UIButton) {
        if let url = self.updateStringPath {
            if let urlR = URL(string: url) {
                if UIApplication.shared.canOpenURL(urlR) {
                    UIApplication.shared.openURL(urlR)
                }
            }
        }
    }
    /// 关闭按钮的点击
    @objc func updateLater(_ sender : UIButton) {
        for constraint in self.constraints {
            if constraint.firstAttribute == .centerY && constraint.firstItem as! NSObject == self.versionView && constraint.secondItem as! NSObject == self.backView {
                self.removeConstraint(constraint)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                    self.backView.alpha = 0.05
                    let versionViewTop = NSLayoutConstraint.init(item: self.versionView, attribute: .top, relatedBy: .equal, toItem: self.backView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                    versionViewTop.isActive = true
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    self.removeFromSuperview()
                })
            }
        }
    }
}
