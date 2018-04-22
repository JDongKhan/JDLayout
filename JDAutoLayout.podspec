

Pod::Spec.new do |s|

    s.name         = "JDAutoLayout"
    s.version      = '1.2.4' 
    s.summary      = "JDAutoLayout"

    s.description  = <<-DESC
			JDRouter
                   DESC

    s.homepage     = "https://github.com/wangjindong/JDLayout.git"

    s.license      = { :type => 'MIT', :file => 'LICENSE' }

    s.author             = { "wangjindong" => "419591321@qq.com" }
    s.platform     = :ios, "8.0"

    s.source       = { :git => "https://github.com/wangjindong/JDLayout.git", :tag => s.version.to_s }


    s.frameworks = 'Foundation', 'UIKit'
    s.requires_arc = true


    s.source_files = 'JDAutoLayout/*.{h,m}'
    s.public_header_files = 'JDAutoLayout/*.h'


end
