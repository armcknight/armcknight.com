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
  input_dir = "#{args[:dir]}"
  raise "Image directory does not exist (#{input_dir})." unless Dir.exist?(input_dir)
  
  # generate the yaml front matter for the album
  album = input_dir.split('/').last
  album_yaml_url = "#{input_dir}/../../_albums/#{album}.html"
  File.open(album_yaml_url, 'w', File::CREAT) do |file|
    file << <<~FRONTMATTER
              ---
              name: NAME
              description: DESCRIPTION
              cover_image_url: COVER_IMAGE_URL
              ---
              FRONTMATTER
    file.chmod(0644)
  end unless File.exist?(album_yaml_url)
  
  # create gallery index.html
  File.open("#{input_dir}/index.html", 'w', File::CREAT) do |file|
    file << <<~FRONTMATTER
                ---
                
                ---
                {% assign photos = site.photos | where:'album', '#{album}' %}
                {% for photo in photos %}
                  <a href="img/{{ photo.image_url }}"><img src="img/{{ photo.thumbnail_url }}" height="100px" alt="{{ photo.description }}" /></a>
                {% endfor %}
                FRONTMATTER
    file.chmod(0644)
  end
  
  # move images to img/ subdirectory
  image_subdirectory = "#{input_dir}/img"
  if Dir.exist?(image_subdirectory) then
    puts "img/ subdirectory already exists, working with whatever images are in there."
  else
    sh "mkdir #{image_subdirectory}"
    sh "mv #{input_dir}/*.jpg #{image_subdirectory}"
  end
  
  # gather information about the images to display
  images = Hash.new
  Dir.new(image_subdirectory).each do |image|
    next if image == '.' || image == '..' || image == '.DS_Store' || image.include?('thumbnail')
    url = "#{image_subdirectory}/#{image}"
    description = `exiftool -p '$description' #{url}`
    timestamp = `exiftool -p '$modifydate' #{url}`
    date = DateTime.strptime(timestamp, '%Y:%m:%d %H:%M:%S')
    puts "overwriting image" if images[date] != nil
    
    # generate the thumbnail image now
    thumbnail_url = url.gsub('.jpg', '') + '-thumbnail.jpg'
    puts("no file at #{thumbnail_url}") unless File.exist?(thumbnail_url)
    sh "magick #{url} -resize x100 #{thumbnail_url}" unless File.exist?(thumbnail_url)
    
    images[date] = { 
      'description' => description.strip, 
      'url' => image, 
      'thumbnail_url' => thumbnail_url.split('/').last
    }
  end
  
  # generate the yaml front matter for each picture
  image_idx = 0
  images.keys.sort.each do |sortedKey|
    image = images[sortedKey]
    url = image['url']
    description = image['description']
    thumbnail_url = image['thumbnail_url']

    File.open("#{input_dir}/../../_photos/#{album}-#{image_idx}.html", 'w', File::CREAT) do |file|
      file << <<~FRONTMATTER
                ---
                image_url: #{url}
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
  
  # run jekyll build
  
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
