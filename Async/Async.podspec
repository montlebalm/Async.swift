Pod::Spec.new do |s|
  s.name        = "Async"
  s.version     = "0.1.0"
  s.summary     = "Async makes asynchronous control flow a pleasure."
  s.homepage    = "https://github.com/montlebalm/Async.swift"
  s.license     = { :type => "MIT" }
  s.authors     = { "montlebalm" => "chris@chrismontrois.net" }

  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.source   = { :git => "https://github.com/montlebalm/Async.swift.git", :tag => "0.1.0"}
  s.source_files = "Async/**/*.swift"
end
