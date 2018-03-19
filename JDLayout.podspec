

Pod::Spec.new do |s|

  s.name         = "JDLayout"
  s.version      = "1.1.6"
  s.summary      = "JDLayout"

  s.description  = <<-DESC
			JDRouter
                   DESC

  s.homepage     = "https://github.com/wangjindong/JDLayout.git"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "wangjindong" => "419591321@qq.com" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/wangjindong/JDLayout.git", :tag => s.version.to_s }


  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true

  s.subspec "ObjectC" do |cp|
    cp.source_files = 'JDLayout/Layout/*.{h,m}'
    cp.public_header_files = 'JDLayout/JDLayout/*.h'
  end

  s.subspec "Swfit" do |cp|
    cp.source_files = 'JDLayout/Layout Swift/*.{h,m}'
    cp.public_header_files = 'JDLayout/Layout Swift/*.h'
  end
 
end
