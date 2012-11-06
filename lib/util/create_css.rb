#
# This class process the current directory and its subdirectories and creates
# a file
#
class CreateCss

  def initialize
    process
  end

  def process

    @style_css=File.open("style.css","w")
    process_dir('.')
    
  end

  def process_dir(path)
    Dir.foreach(path) do |file|
      if file != 'style.css' and File.exist?(File.join(path,file)) and File.extname(File.join(path,file)) == '.css'
        puts "processing #{File.join(path, file)}"
        @style_css.write "\n/* ------- #{file} ---------*/\n"
        @style_css.write File.read(File.join(path,file))
      end
      if file != '.' and  file != '..' and File.directory?(File.join(path,file))
        puts "processing dir #{File.join(path, file)}"
        process_dir(File.join(path, file))
      end
    end

  end

end

