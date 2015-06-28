if ENV['RAILS_ENV'] != 'production'
  require 'gettext/tools/task'
  require 'haml/magic_translations/xgettext/haml_parser'

  GetText::Tools::XGetText.add_parser(Haml::MagicTranslations::XGetText::HamlParser)
  GetText::Tools::Task.define do |task|
    task.package_name      = 'OpenShift Console'
    task.domain            = 'console'
    task.mo_base_directory = '../../config/locales'
    task.po_base_directory = '../../config/locales'
    task.spec              = Gem::Specification.load('../../openshift-origin-console.gemspec')
    task.files             = Dir.glob('../../appx/{models,controllers,views,helpers}/**/*.{rb,haml}')
    task.locales           = [ 'en', 'pt' ]
  end
end
