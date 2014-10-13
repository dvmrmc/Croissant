Pod::Spec.new do |s|
s.name = "Croissant"
s.version = "0.0.1"
s.summary = "A simple queued downloader."
s.description = <<-DESC
This library is a simple queued downloader written in Objective-C and released under MIT License.
DESC
s.homepage = "https://github.com/cerberillo/Croissant"
s.license = { :type => "MIT" }
s.author = { "David Martin" => "david@martinmacias.com" }
s.platform = :ios
s.platform = :ios, "6.1"
s.source = { :git => "https://github.com/cerberillo/Croissant.git", :tag => s.version.to_s }
s.framework = "Foundation"
s.source_files = "croissant/**/*.{h,m}"
s.requires_arc = true
end