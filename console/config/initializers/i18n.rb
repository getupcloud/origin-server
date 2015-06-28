require 'gettext'
include GetText

I18n::Backend::Simple.include(I18n::Backend::Gettext)

GetText::LocalePath.add_default_rule File.absolute_path(File.dirname(__FILE__) + '/../locales/%{lang}/LC_MESSAGES/%{name}.mo')
GetText.bindtextdomain 'console'
