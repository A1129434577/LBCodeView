Pod::Spec.new do |spec|
  spec.name         = "LBCodeView"
  spec.version      = "1.0.0"
  spec.summary      = "验证码输入框"
  spec.description  = "可以自定义样式的验证码输入框，一个数字一个框，支持自定义验证码长度。"
  spec.homepage     = "https://github.com/A1129434577/LBCodeView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/LBCodeView.git', :tag => spec.version.to_s }
  spec.source_files = "LBCodeView/**/*.{h,m}"
  spec.requires_arc = true
end
