task :init do
  sh 'brew install exiftool imagemagick'
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
  dir = Dir.new("#{args[:dir]}/img")
  raise "Image directory does not exist (#{dir.path})." unless Dir.exist?(dir.path)
  
  album = args[:dir].split('/').last
  
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
  
  # generate the yaml front matter for the album
  File.open("#{args[:dir]}/../../_albums/#{album}.html", 'w', File::CREAT) do |file|
    file << <<~FRONTMATTER
              ---
              name: NAME
              description: DESCRIPTION
              cover_image_url: COVER_IMAGE_URL
              ---
              FRONTMATTER
    file.chmod(0644)
  end
  
  
  # generate the yaml front matter for each picture
  image_idx = 0
  images.keys.sort.each do |sortedKey|
    image = images[sortedKey]
    url = image['url']
    description = image['description']
    thumbnail_url = image['thumbnail_url']

    File.open("#{args[:dir]}/../../_photos/#{album}-#{image_idx}.html", 'w', File::CREAT) do |file|
      file << <<~FRONTMATTER
                ---
                url: #{url}
                description: #{description}
                thumbnail_url: #{thumbnail_url}
                date: #{sortedKey.strftime("%B %e, %Y")}
                album: #{album}
                ---
                FRONTMATTER
      file.chmod(0644)
    end
    
    image_idx += 1
  end
  
  # create a new gallery index.html
  gallery_index_url = "#{args[:dir]}/index.html"
  File.open(gallery_index_url, 'w', File::CREAT) do |file|
    file << <<~FRONTMATTER
                ---
                
                ---
                {% assign photos = site.photos | where:'album', '#{album}' %}
                <ul>
                {% for photo in photos %}
                  <li>
                    {{ photo.description }}
                  </li>
                {% endfor %}
                </ul>
                FRONTMATTER
    file.chmod(0644)
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
