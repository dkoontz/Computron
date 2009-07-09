require 'rawr'
require 'rake'

# Keystore generated with "keytool -genkey -alias Computron -keystore ./keystore"
desc "Signs jars in-place (in the lib directory)"
task :sign_applet => 'rawr:jar' do
  (Dir.glob('package/jar/lib/java/**/*.jar') + ['package/jar/Computron.jar']).each do |jar|
    puts `jarsigner -keystore ./keystore -storepass computron #{jar} Computron`
  end
end