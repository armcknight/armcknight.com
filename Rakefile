desc 'Install dev dependencies.'
task :init do
  sh 'brew install exiftool imagemagick'
end

desc 'Build all SASS and Jekyll sources.'
task :build do
	_build
end

desc 'Build everything necessary to render a photo gallery from a directory of images: build Jekyll YAML front matter for album and each photo, render thumbnails, and an index for the gallery. At the end, runs everything in `rake build`.'
task :prepare_photo_gallery,[:dir] do |t, args|
  _prepare_photo_gallery args[:dir]
end

desc 'Start local webserver to test the static site. Opens a new browser window to the home index. Server continues running, so multiple builds can be done and just requires a reload in the browser.'
task :serve do
	require 'shell'
	shell = Shell.new
	shell.pushd '_site'
	shell.system('python -m SimpleHTTPServer 4000 --bind localhost &')
	puts 'Loading site...'
	sleep 3
	shell.system('open http://localhost:4000')
end

desc 'Stop the local webserver.'
task :endserve do
	sh 'killall Python'
end

desc 'Push the git repo to remote and sync the compiled site to S3.'
task :publish do
  sh 'git push origin'
  sh 'aws s3 sync _site/ s3://armcknight.com --exclude .git/ --profile default --acl public-read'
end

def _prepare_photo_gallery input_dir
  require 'date'

  # get and check some required paths
  raise "Image directory does not exist (#{input_dir})." unless Dir.exist?(input_dir)

  # generate the yaml front matter for the album
  album = input_dir.split('/').last
  album_yaml_url = "#{input_dir}/../../_albums/#{album}.html"

  if File.exist?(album_yaml_url) then
    album_front_matter = IO.readlines(album_yaml_url)
    album_name = album_front_matter[1].gsub('name: ', '').chomp
    description = album_front_matter[2].gsub('description: ', '').chomp
    cover_image_url = album_front_matter[3].gsub('cover_image_url: ', '').chomp
    puts "Album front matter exists...\nread album name: \"#{album_name}\"\ndescription: \"#{description}\"\ncover image url: \"#{cover_image_url}\""
  else
    puts "Enter album name: "
    album_name = STDIN.gets.chomp
    puts "Enter album description: "
    description = STDIN.gets.chomp
    puts "Enter album cover image thumbnail url: "
    cover_image_url = STDIN.gets.chomp
  
    File.open(album_yaml_url, 'w', File::CREAT) do |file|
      file << <<~FRONTMATTER
                ---
                name: #{album_name}
                description: #{description}
                cover_image_url: #{cover_image_url}
                ---
                FRONTMATTER
      file.chmod(0644)
    end
  end

  # create gallery index.html
  File.open("#{input_dir}/index.html", 'w', File::CREAT) do |file|
    file << <<~FRONTMATTER
                ---
              
                ---
                {% include subindex-html-start.html name="#{album_name}" css_file="photos.css" description="#{description}" %}
                {% assign photos = site.photos | where:'album', '#{album}' %}
                {% for photo in photos %}
                  <table >
                    <tr>
                      <td class="thumbnail">
                        <a href="img/{{ photo.image_url }}"><img src="img/{{ photo.thumbnail_url }}" height="100px" alt="{{ photo.description }}" /></a>
                      </td>
                      <td class="description">
                        {{ photo.description }}
                      </td>
                    </tr>
                  </table>
                {% endfor %}
                {% include subindex-html-end.html %}
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
    if File.exist?(thumbnail_url) then
      puts "Thumbnail already exists for #{image}." 
    else
      sh "magick #{url} -resize x100 #{thumbnail_url}" unless File.exist?(thumbnail_url)
    end
  
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

  # build everything
  _build
end 

def _build
	sh 'sass --update css'
	sh 'jekyll build'
end