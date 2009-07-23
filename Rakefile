require 'rawr'
require 'rake'

# Keystore generated with "keytool -genkey -alias Computron -keystore ./keystore"
desc "Builds project jars and signs the files in the /package/jar directory"
task :sign_applet => 'rawr:jar' do
  (Dir.glob('package/jar/lib/java/**/*.jar') + ['package/jar/Computron.jar']).each do |jar|
    puts `jarsigner -keystore ./keystore -storepass computron #{jar} Computron`
  end
end