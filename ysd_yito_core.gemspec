Gem::Specification.new do |s|

  s.name    = "ysd_yito_core"
  s.version = "0.1.80"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-10-18"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml','static/**/*.*', 'bin/**/*'] 
  s.description = "Base project to create web applications"
  s.summary = "Base project to create web applications"
  s.executables << 'create_css'
           
  s.add_runtime_dependency "tilt"         
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "ysd_core_themes"
  s.add_runtime_dependency "ysd_core_plugins"       
  s.add_runtime_dependency "ysd_md_yito"

end