require 'rawr'
require 'rake'

# Keystore generated with "keytool -genkey -alias Computron -keystore ./keystore"
desc "Signs jars in-place (in the lib directory)"
task :sign_applet => 'rawr:jar' do
  ['package/jar/Computron.jar', 'package/jar/lib/java/jruby.jar'].each do |jar|
    puts `jarsigner -keystore ./keystore -storepass computron #{jar} Computron`
  end
end