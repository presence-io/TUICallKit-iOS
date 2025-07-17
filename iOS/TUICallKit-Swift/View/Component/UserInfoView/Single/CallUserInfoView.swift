//
//  CallUserInfoView.swift
//  TUICallKit
//
//  Created by vincepzhang on 2023/2/15.
//

import Foundation

class CallUserInfoView: UIView {
    
    let remoteUserListObserver = Observer()
    
    let userHeadImageView: UIImageView = {
        let userHeadImageView = UIImageView(frame: CGRect.zero)
        userHeadImageView.layer.masksToBounds = true
        userHeadImageView.layer.cornerRadius = 6.0
        if let image = TUICallKitCommon.getBundleImage(name: "default_user_icon") {
            userHeadImageView.image = image
        }
        return userHeadImageView
    }()
    
    let userNameLabel: UILabel = {
        let userNameLabel = UILabel(frame: CGRect.zero)
        userNameLabel.textColor = UIColor.t_colorWithHexString(color: "#D5E0F2")
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        userNameLabel.backgroundColor = UIColor.clear
        userNameLabel.textAlignment = .center
        return userNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUserImageAndName()
        registerObserveState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        TUICallState.instance.remoteUserList.removeObserver(remoteUserListObserver)
    }
    
    // MARK: UI Specification Processing
    private var isViewReady: Bool = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if isViewReady { return }
        constructViewHierarchy()
        activateConstraints()
        isViewReady = true
    }
    
    func constructViewHierarchy() {
        addSubview(userHeadImageView)
        addSubview(userNameLabel)
    }
    
    func activateConstraints() {
        self.userHeadImageView.snp.makeConstraints { make in
            make.top.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 100.scaleWidth(), height: 100.scaleWidth()))
        }
        self.userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userHeadImageView.snp.bottom).offset(10.scaleHeight())
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(30)
        }
    }
    
    // MARK: Register TUICallState Observer && Update UI
    func registerObserveState() {
        remoteUserListChanged()
    }
    
    func remoteUserListChanged() {
        TUICallState.instance.remoteUserList.addObserver(remoteUserListObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.setUserImageAndName()
        })
    }
    
    // MARK: Update UI
    func setUserImageAndName() {
        guard let remoteUser = TUICallState.instance.remoteUserList.value.first else { return }
        userNameLabel.text = User.getUserDisplayName(user: remoteUser)
        if let url = URL(string: remoteUser.avatar.value) {
            userHeadImageView.sd_setImage(with: url, completed: { [weak self] image, error, cacheType, url in
                guard let self = self, let image = image else { return }
                if let croppedImage = image.cropToSquareIfNeeded() {
                    self.userHeadImageView.image = croppedImage
                } else {
                    self.userHeadImageView.image = image
                }
            })
        }
    }
}

extension UIImage {
    func cropToSquareIfNeeded() -> UIImage? {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        
        var cropRect: CGRect = .zero
        
        if originalHeight > originalWidth {
            // 高度大于宽度，以宽度为边，从顶部裁剪
            cropRect = CGRect(x: 0, y: 0, width: originalWidth, height: originalWidth)
        } else if originalWidth > originalHeight {
            // 宽度大于高度，以高度为边，从中间裁剪
            let xOffset = (originalWidth - originalHeight) / 2
            cropRect = CGRect(x: xOffset, y: 0, width: originalHeight, height: originalHeight)
        } else {
            // 正方形图片，直接返回原图
            cropRect = CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight)
        }
        
        // 注意：这里 cropRect 的坐标单位是基于图片的像素尺寸，如果图片的 scale 不是1，可能需要调整
        if let cgImage = self.cgImage,
           let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
        }
        return nil
    }
}
