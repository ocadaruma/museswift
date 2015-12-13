Pod::Spec.new do |s|
  s.name         = "MuseSwift"
  s.version      = "0.0.3"
  s.summary      = "A score rendering library"

  s.description  = <<-DESC
                   * Parse ABC notation.
                   * Render score.
                   DESC

  s.homepage     = "https://github.com/ocadaruma/museswift"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "ocadaruma" => "ocadaruma@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/ocadaruma/museswift.git", :tag => "0.0.3" }
  s.source_files  = "MuseSwift/Source/**/*.swift"
  s.resources = ["MuseSwift/Resource/**/*.png"]
  s.requires_arc = true

end
