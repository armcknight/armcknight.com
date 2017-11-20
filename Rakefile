desc 'Install dev dependencies.'
task :init do
  sh 'brew install exiftool imagemagick'
  sh 'gem install octopress-paginate'
end

desc 'Build all SASS and Jekyll sources.'
task :build do
	_build
end

desc 'Build everything necessary to render a photo gallery from a directory of images: build Jekyll YAML front matter for album and each photo, render thumbnails, and an index for the gallery. At the end, runs everything in `rake build`.'
task :prepare_photo_gallery,[:dir] do |t, args|
  _prepare_photo_gallery args[:dir]
end

desc 'Build all the photo galleries. Helpful to backfill changes to the build process.'
task :prepare_all_galleries do
  directory = "./photos/"
  Dir.new(directory).entries.each do |gallery|
    path = directory + gallery
    next if gallery == '.' || gallery == '..' || !File.directory?(path)
    _prepare_photo_gallery path
  end
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
  album_id = input_dir.split('/').last
  album_yaml_url = "#{input_dir}/../../_albums/#{album_id}.html"
  if File.exist?(album_yaml_url) then
    album_front_matter = IO.readlines(album_yaml_url)
    album_name = album_front_matter[1].gsub('name: ', '').chomp
    album_description = album_front_matter[2].gsub('description: ', '').chomp
    cover_image_url = album_front_matter[3].gsub('cover_image_url: ', '').chomp
    puts "Album front matter exists...\nread album name: \"#{album_name}\"\ndescription: \"#{album_description}\"\ncover image thumbnail url: \"#{cover_image_url}\""
  else
    puts "Enter album name: "
    album_name = STDIN.gets.chomp
    puts "Enter album description: "
    album_description = STDIN.gets.chomp
    puts "Enter album cover image thumbnail url: "
    cover_image_url = STDIN.gets.chomp
  
    File.open(album_yaml_url, 'w', File::CREAT) do |file|
      file << <<~FRONTMATTER
                ---
                name: #{album_name}
                description: #{album_description}
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
                {% include subindex-html-start.html name="#{album_name}" css_file="photo_gallery.css" description="#{album_description}" %}
                                
                {% assign photos = site.photos | where:'album', '#{album_id}' %}

                <!-- cover image -->
                {% assign cover_photo = site.photos | where: 'album', '#{album_id}' | where:'image_url', '#{cover_image_url}' %}

                <center>
                    <table>
                      <tr>
                        <td class="thumbnail">
                          <a href="img/{{ cover_photo[0].image_url }}"><img src="img/{{ cover_photo[0].thumbnail_url }}" height="100px" alt="{{ cover_photo[0].description }}" /></a>
                        </td>
                      </tr>
                      <tr>
                        <td class="description">
                          {{ cover_photo[0].description }}
                        </td>
                      </tr>
                    </table>
                </center>
              
                <!-- album images -->
                {% assign photo_index = 1 %}
                {% for photo in photos %}
                  {% if photo.image_url != '#{cover_image_url}' %}
                    <table class="gallery-item" width="{{ photo.thumbnail_width }}">
                      <tr>
                        <td class="thumbnail">
                          {% if photo_index == 1 %}
                            <a href="slideshow/"><img src="img/{{ photo.thumbnail_url }}" height="100px" alt="{{ photo.description }}" /></a>
                          {% else %}
                            <a href="slideshow/{{ photo_index }}"><img src="img/{{ photo.thumbnail_url }}" height="100px" alt="{{ photo.description }}" /></a>
                          {% endif %}
                        </td>
                      </tr>
                      <tr>
                        <td class="description">
                          {{ photo.description }}
                        </td>
                      </tr>
                    </table>
                  {% endif %}
                  {% assign photo_index = photo_index | plus: 1 %}
                {% endfor %}
                              
                {% include subindex-html-end.html %}
                FRONTMATTER
    file.chmod(0644)
  end

  # create the slideshow
  slideshow_dir = "#{input_dir}/slideshow"
  sh "mkdir #{slideshow_dir}" unless Dir.exist?(slideshow_dir)
  slideshow_template = "#{slideshow_dir}/index.html"
  File.open(slideshow_template, 'w', File::CREAT) do |file|
    file << <<~FRONTMATTER
                ---
                paginate:
                  collection: photos
                  category: #{album_id}
                  per_page: 1
                  limit: false
                  permalink: /:num/
                ---
                {% if paginator.page == 1 %}
                  {% include subindex-html-start.html name="#{album_name}" css_file="slideshow_slide.css" description="#{album_description}" %}
                {% else %}
                  {% include subindex-html-start.html name="#{album_name}" css_file="slideshow_slide.css" description="#{album_description}" back_url="../.." %}
                {% endif %}
                
                {% for photo in paginator.photos %}
                  <center>
                    <table>
                      <tr>
                        <td class="image">
                          <a href="/photos/#{album_id}/img/{{ photo.image_url }}"><img src="/photos/#{album_id}/img/{{ photo.image_url }}" style="max-height: 80%; max-width: 80%;" /></a>
                        </td>
                      </tr>
                      <tr>
                        <td class="description">
                          ({{ paginator.page }}/{{ paginator.total_photos }}): {{ photo.description }}
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <center>
                            {% if paginator.previous_page != nil %}
                              {% if paginator.previous_page == 1 %}
                                <a href="../">Previous</a>
                              {% else %}
                                <a href="../{{ paginator.previous_page }}">Previous</a>
                              {% endif %}
                            {% endif %}
                            {% if paginator.next_page != nil %}
                              {% if paginator.next_page == 2 %}
                                <a href="{{ paginator.next_page }}">Next</a>
                              {% else %}
                                <a href="../{{ paginator.next_page }}">Next</a>
                              {% endif %}
                            {% endif %}
                          </center>
                        </td>
                      </tr>
                    </table>
                  </center>
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
    image_description = `exiftool -p '$description' #{url}`
    timestamp = `exiftool -p '$modifydate' #{url}`
    date = DateTime.strptime(timestamp, '%Y:%m:%d %H:%M:%S')
    puts "overwriting image" if images[date] != nil
  
    # generate the thumbnail image now
    thumbnail_url = url.gsub('.jpg', '') + '-thumbnail.jpg'
    if File.exist?(thumbnail_url) then
      puts "Thumbnail already exists for #{image}." 
    else
      sh "magick #{url} -resize x100 #{thumbnail_url}" unless File.exist?(thumbnail_url)
    end
    thumbnail_width = `exiftool -p '$imageWidth' #{thumbnail_url}`
    thumbnail_width = 150 if thumbnail_width.to_i < 150
    
    image_width = `exiftool -p '$imageWidth' #{url}`
    image_height = `exiftool -p '$imageHeight' #{url}`
  
    images[date] = { 
      'description' => image_description.strip, 
      'url' => image, 
      'thumbnail_url' => thumbnail_url.split('/').last,
      'thumbnail_width' => thumbnail_width,
    }
  end

  # generate the yaml front matter for each picture
  image_idx = 0
  images.keys.sort.each do |sortedKey|
    image = images[sortedKey]
    url = image['url']
    image_width = image['image_width']
    image_height = image['image_height']
    image_description = image['description']
    thumbnail_url = image['thumbnail_url']
    thumbnail_width = image['thumbnail_width']

    File.open("#{input_dir}/../../_photos/#{album_id}-#{image_idx}.html", 'w', File::CREAT) do |file|
      file << <<~FRONTMATTER
                ---
                image_url: #{url}
                description: #{image_description}
                thumbnail_url: #{thumbnail_url}
                thumbnail_width: #{thumbnail_width}
                date: #{sortedKey.strftime("%B %e, %Y")}
                album: #{album_id}
                category: #{album_id}
                ---
                FRONTMATTER
      file.chmod(0644)
    end
  
    image_idx += 1
  end 
end 

def _build
	sh 'sass --update css'
	sh 'jekyll build'
end