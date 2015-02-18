Pod::Spec.new do |s|
s.name             = "NSManagedObjectContext-HYPSafeSave"
s.version          = "0.5"
s.summary          = "Warns you of unsafe NSManagedObjectContext saves"
s.description      = <<-DESC
When doing `[context save:&error]` warns you about:

* Usage of confinement contexts
* Main context saved in a background thread
* Background context saved in a main thread
DESC
s.homepage         = "https://github.com/hyperoslo/NSManagedObjectContext-HYPSafeSave"
s.license          = 'MIT'
s.author           = { "Hyper AS" => "teknologi@hyper.no" }
s.source           = { :git => "https://github.com/hyperoslo/NSManagedObjectContext-HYPSafeSave.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/hyperoslo'

s.platform     = :ios, '7.0'
s.requires_arc = true

s.source_files = 'Source/**/*'

s.frameworks = 'CoreData'
end
