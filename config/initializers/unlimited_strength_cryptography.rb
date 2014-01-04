# http://stackoverflow.com/questions/14552303/opensslcipherciphererror-with-rails4-on-jruby

if RUBY_PLATFORM == 'java'
  security_class = java.lang.Class.for_name('javax.crypto.JceSecurity')
  restricted_field = security_class.get_declared_field('isRestricted')
  restricted_field.accessible = true
  restricted_field.set nil, false
end

