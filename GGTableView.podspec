#
# Be sure to run `pod lib lint GGTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GGTableView'
  s.version          = '0.2.5'
  s.summary          = 'This pod just provides a simpler, maybe, way to use UITableView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                      GGTableView centralizes the management logic for the cell, aims to privide a modular way to use UITableView
                       DESC

  s.homepage         = 'https://github.com/coppergaga/GGTableView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'coppergaga' => '411998690@qq.comm' }
  s.source           = { :git => 'https://github.com/coppergaga/GGTableView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_versions = ['5.0']

  s.source_files = 'GGTableView/Classes/**/*'
  s.requires_arc = true
  
  # s.resource_bundles = {
  #   'GGTableView' => ['GGTableView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
