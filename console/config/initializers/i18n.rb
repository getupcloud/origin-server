## http://stackoverflow.com/questions/3492631/rails-i18n-default-value
#module I18n
#  # For MissingTranslationData, return the message given to .t
#  def self.fallback_exception_handler(exception, locale, key, options)
#puts "TRNAS[#{locale}]: #{key}"
#    options ||= {}
#    if exception.is_a?(MissingTranslation)
#      if locale == self.default_locale
#        puts '+='
#        puts normalize_keys locale, key, options[:scope]
#        puts (normalize_keys locale, key, options[:scope]).last.to_s
#       puts '==='
#        send(:normalize_keys, locale, key, options[:scope]).last.to_s
#      else
#        puts "== '#{key.to_s}'"
#        key.to_s
#      end
#    else
#      send I18n::ExceptionHandler, exception, locale, key, options
#    end
#  end
#
#end
#
#I18n.exception_handler = :fallback_exception_handler

#I18n.enforce_available_locales = true
