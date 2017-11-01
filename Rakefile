task :init do
  sh 'brew install exiftool'
end

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

task :prepare_photo_gallery,[:dir] do |t, args|
  require 'date'
  
  # get and check some required paths
  dir = Dir.new(args[:dir])
  raise "Directory does not exist (#{dir.path})." unless Dir.exist?(dir.path)
  
  index_url = "#{dir.path}.html"
  raise "Album index file does not exist (#{index_url})." unless File.exist?(index_url)
  
  # gather information about the images to display
  images = Hash.new
  dir.each do |image|
    next if image == '.' || image == '..' || image == '.DS_Store'
    url = "#{dir.path}/#{image}"
    description = `exiftool -p '$description' #{url}`
    timestamp = `exiftool -p '$modifydate' #{url}`
    date = DateTime.strptime(timestamp, '%Y:%m:%d %H:%M:%S')
    puts "overwriting image" if images[date] != nil
    
    # generate the thumbnail image now
    thumbnail_url = url.gsub('.jpg', '') + '-thumbnail.jpg'
    sh "magick #{url} -resize x100 #{thumbnail_url}"
    
    images[date] = { 
      'description' => description.strip, 
      'url' => image, 
      'thumbnail_url' => thumbnail_url.split('/').last
    }
  end
  
  # generate the HTML to put into the photo gallery index
  html = "<div>\n"
  images.keys.sort.each do |sortedKey|
    image = images[sortedKey]
    url = image['url']
    description = image['description']
    thumbnail_url = image['thumbnail_url']
    
    html << "\t<a href=\"#{url}\"><img src=\"#{thumbnail_url}\" alt=\"#{description}\" /></a>\n"
  end
  html << '</div>'
  
  # append the generated HTML into the index html file for the album
  File.open(index_url, 'a') do |file|
    file << html
  end
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
