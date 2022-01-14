
Pod::Spec.new do |spec|
spec.name         = "CUIKit"
spec.version      = "1.0.0"
spec.summary      = "Кастомных элементов пользовательского интерфейс"
spec.description  = <<-DESC
Набор кастомных элементов пользовательского интерфейса, и также некоторые вспомогательные элементы анимации
DESC

spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author       = { "Ayham Hylam" => "Ayham Hylam" }
spec.homepage     = "https://github.com/ayham-achami/CUIKit.git"

spec.social_media_url = ""
spec.ios.deployment_target = "13.0"
spec.swift_version = "5"

spec.source = {
    :git => "git@github.com:ayham-achami/CUIKit.git",
    :tag => spec.version.to_s
}
spec.frameworks = "UIKit"
spec.source_files = "CUIKit/Sources/**/*.swift"
spec.resource_bundles = {
  'CUIKit' => ['CUIKit/Sources/**/*.{xib,xcassets,imageset}']
}
spec.pod_target_xcconfig = { "SWIFT_VERSION" => "5", 'APPLICATION_EXTENSION_API_ONLY' => 'YES', 'ONLY_ACTIVE_ARCH' => 'NO' }
end
