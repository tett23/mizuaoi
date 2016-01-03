#p RAILS_ROOT

namespace :mp4 do
  task :unexist_files => :environment do
    db_video_items = Video.select(:output_name).where(is_encoded: true).all.map do |video|
      video.output_name
    end

    exist_items = Dir.glob('/home/tett23/movie/frogbit/*.mp4').map do |item|
      File.basename(item)
    end
    (db_video_items - exist_items).each do |item|
      puts item
    end.sort
  end
end
