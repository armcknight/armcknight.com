task :watch do
	sh 'sass --watch css &'
	sh 'jekyll build --watch &'
	sleep 2
	exit 0
end

task :endwatch do
	sh 'killall ruby'
end

task :build do
	sh 'sass --update css'
	sh 'jekyll build'
end

task :serve do
	require 'shell'
	shell = Shell.new
	shell.pushd '_site'
	shell.system('python -m SimpleHTTPServer 4000 --bind localhost &')
	puts 'Loading site...'
	sleep 3
	shell.system('open http://localhost:4000')
end

task :endserve do
	sh 'killall Python'
end

task :publish do
  sh 'git push origin'
  sh 'aws s3 sync _site/ s3://armcknight.com --exclude .git/ --profile default --acl public-read'
end
