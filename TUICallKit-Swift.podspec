Pod::Spec.new do |spec|
  spec.name         = 'TUICallKit-Swift'
  spec.version      = '2.6.0.1080'
  spec.platform     = :ios
  spec.ios.deployment_target = '12.0'
  spec.license      = { :type => 'Proprietary',
    :text => <<-LICENSE
    copyright 2017 tencent Ltd. All rights reserved.
    LICENSE
  }
  spec.homepage     = 'https://cloud.tencent.com/document/product/647'
  spec.documentation_url = 'https://cloud.tencent.com/document/product/647'
  spec.authors      = 'tencent video cloud'
  spec.summary      = 'TUICallKit'
  spec.xcconfig     = { 'VALID_ARCHS' => 'armv7 arm64 x86_64' }

  # 这里建议用 HTTPS git 地址 + 指定 tag。
  # 如果还没打 tag，可以先写 :branch => 'main'，或者创建一个 tag '2.6.0.1080' 并推上去。
  spec.source = {
    :git => 'https://github.com/presence-io/TUICallKit-iOS.git',
    # :tag => spec.version.to_s
    :branch => 'main'
  }
  
  spec.dependency 'TUICore'
  spec.dependency 'SnapKit'

  spec.requires_arc = true
  spec.static_framework = true
  spec.source_files  = 'iOS/TUICallKit-Swift/**/*.{h,m,mm,swift}' 
  spec.resource      = ['iOS/TUICallKit-Swift/Resources/*.bundle']
  spec.resource_bundles = {
    'TUICallKitBundle' => [
      'iOS/TUICallKit-Swift/Resources/**/*.strings',
      'iOS/TUICallKit-Swift/Resources/AudioFile',
      'iOS/TUICallKit-Swift/Resources/*.xcassets'
    ]
  }
  spec.swift_version = '5.0'
  
  spec.ios.framework = ['AVFoundation', 'Accelerate', 'AssetsLibrary']
  spec.library = 'c++', 'resolv', 'sqlite3'
  
  spec.default_subspec = 'TRTC'
  
  spec.subspec 'TRTC' do |trtc|
    trtc.dependency 'TXLiteAVSDK_TRTC'
    trtc.dependency 'TUICallEngine/TRTC', '~> 2.6.0.1080'
    trtc.source_files = 'iOS/TUICallKit-Swift/**/*.{h,m,mm,swift}'
    trtc.resource_bundles = {
      'TUICallKitBundle' => [
        'iOS/TUICallKit-Swift/Resources/**/*.strings',
        'iOS/TUICallKit-Swift/Resources/AudioFile',
        'iOS/TUICallKit-Swift/Resources/*.xcassets'
      ]
    }
    trtc.resource = ['iOS/TUICallKit-Swift/Resources/*.bundle']
  end
  
  spec.subspec 'Professional' do |professional|
    professional.dependency 'TXLiteAVSDK_Professional'
    professional.dependency 'TUICallEngine/Professional', '~> 2.6.0.1080'
    professional.source_files = 'iOS/TUICallKit-Swift/**/*.{h,m,mm,swift}'
    professional.resource_bundles = {
      'TUICallKitBundle' => [
        'iOS/TUICallKit-Swift/Resources/**/*.strings',
        'iOS/TUICallKit-Swift/Resources/AudioFile',
        'iOS/TUICallKit-Swift/Resources/*.xcassets'
      ]
    }
    professional.resource = ['iOS/TUICallKit-Swift/Resources/*.bundle']
  end
  
  spec.resource_bundles = {
    'TUICallKit-Swift_Privacy' => [
      'iOS/TUICallKit-Swift/Sources/PrivacyInfo.xcprivacy'
    ]
  }
  
end
