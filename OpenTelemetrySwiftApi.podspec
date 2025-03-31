Pod::Spec.new do |s|
  s.name = "OpenTelemetrySwiftApi"
  s.version = "1.13.1"
  s.summary = "Unofficial OpenTelemetry API for Swift maintained by Datadog"
  s.description = "This is an unofficial OpenTelemetry API for Swift maintained by Datadog team and primarily used by Datadog SDK for iOS. It follows the official OpenTelemetry releases and provides CocoaPods compatible distribution."

  s.homepage = "https://github.com/DataDog/opentelemetry-swift-packages"
  s.social_media_url = "https://twitter.com/datadoghq"

  s.license = { :type => "Apache", :file => 'LICENSE' }

  s.authors = {
    "Ganesh Jangir" => "ganesh.jangir@datadoghq.com",
    "Maciej Burda" => "maciej.burda@datadoghq.com",
    "Maciek Grzybowski" => "maciek.grzybowski@datadoghq.com",
    "Maxime Epain" => "maxime.epain@datadoghq.com"
  }

  s.swift_version = "5.9.0"
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'

  s.source = { http: "#{s.homepage}/releases/download/#{s.version}/OpenTelemetryApi.zip", sha1: "8c689147db20f3ba581fbfdda29c5d3d694bb84f" }
  s.vendored_frameworks = 'OpenTelemetryApi/OpenTelemetryApi.xcframework'
end
