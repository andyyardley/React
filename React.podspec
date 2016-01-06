
Pod::Spec.new do |s|

  s.name         = "React"
  s.version      = "0.0.1"
  s.summary      = "React"

  s.description  = <<-DESC
                   A longer description of React in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://www.niveusrosea.com"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "Apache 2.0"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "Andy Yardley" => "andy@niveusrosea.com" }
  # Or just: s.author    = "andyyardley"
  # s.social_media_url   = ""

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"

  s.source       = { :git => "", :commit => "" }

  s.source_files  = "React/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = ""
  # s.resources = "", ""

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "CommonCrypto"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "NSHash", "~> 1.0"

  # s.prefix_header_contents = "#import <CommonCrypto/CommonDigest.h>"

end
