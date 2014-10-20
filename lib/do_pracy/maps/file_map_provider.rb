require 'json'

module DoPracy

  class SimpleTransformer

    def initialize image_width, image_height, lon_range, lat_range
      @image_width = image_width
      @image_height = image_height
      @lon_range = lon_range
      @lat_range = lat_range
    end

    def get lat, lon
      x = @image_width * (lon - @lon_range.min) / @lon_range.length
      y = @image_height * (-lat + @lat_range.max) / @lat_range.length
      {:x => x, :y => y}
    end

  end

  class FileMapProvider

    $maps_folder = "maps"

    def initialize map_definition_file_name
      map_definition_file = File.open("#{$maps_folder}/#{map_definition_file_name}", 'r').read
      map_definition = JSON.parse map_definition_file

      @image_name = "#{$maps_folder}/#{map_definition['file']}"
      @image_width = map_definition["width"].to_i
      @image_height = map_definition["height"].to_i
      @lon_range = Range.new map_definition["lon_min"].to_f, map_definition["lon_max"].to_f
      @lat_range = Range.new map_definition["lat_min"].to_f, map_definition["lat_max"].to_f

      @transformer = SimpleTransformer.new @image_width, @image_height, @lon_range, @lat_range

    end

    def get_map_image
      @image_name
    end

    def get_width
      @image_width
    end

    def get_height
      @image_height
    end

    def get_transformer
      @transformer
    end

  end

end
