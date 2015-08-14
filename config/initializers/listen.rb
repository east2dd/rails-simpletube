Thread.new do
  listener = Listen.to('/Volumes/projects/videos/', '/Volumes/recent/') do |modified, added, removed|

    added.each do |path|
      match_data = /(특집|체육경기|화면음악|아동영화|만화영화|우리민족끼리)(.*)(\.flv|\.ts)/.match(path)

      unless match_data.nil?
        puts path
        category = Category.where(name: 'Video').first
        tag = match_data[1]
        video = Video.new
        video.file = File.new(path)
        video.category = category
        video.tag_list = tag

        file_extension = File.extname(path)
        file_name = File.basename(path, file_extension)

        video.title = file_name
        video.save
      end
    end

  end
  listener.start
  sleep
end