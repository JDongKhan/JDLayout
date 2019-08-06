

Pod::Spec.new do |s|

    s.name         = "JDLayout"
    s.version      = '1.3.2'
    s.summary      = "JDLayout"

    s.description  = <<-DESC
			JDRouter
                   DESC

    s.homepage     = "https://github.com/JDongKhan/JDLayout.git"

    s.license      = { :type => 'MIT', :file => 'LICENSE' }

    s.author             = { "wangjindong" => "419591321@qq.com" }
    s.platform     = :ios, "8.0"

    s.source       = { :git => "https://github.com/JDongKhan/JDLayout.git", :tag => s.version.to_s }


    s.frameworks = 'Foundation', 'UIKit'
    s.requires_arc = true


    s.source_files = 'JDLayout/*.{h,m}'
    s.public_header_files = 'JDLayout/*.h'


end
