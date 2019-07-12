Pod::Spec.new do |s|

  s.name         = "DDQKit"
  s.version      = "1.0.4"
  s.ios.deployment_target = '8.0'
  s.summary      = "工具类集合"
  s.homepage     = "https://github.com/MyNameDDQ/DDQKit"
  s.license      = "MIT"
  s.author       = { "MyNameDDQ" => "wjddq@qq.com" }
  s.source       = { :git => 'https://github.com/MyNameDDQ/DDQKit.git', :tag => s.version}
  s.requires_arc = true
  s.source_files = '*.{h,m}'
 
  s.dependency 'DDQUIKit'
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'
  s.dependency 'IQKeyboardManager'
  s.dependency 'Masonry'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'
  s.dependency 'FMDB'
  s.dependency 'WebViewJavascriptBridge'
  s.dependency 'SAMKeychain'

end