class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first
  end

  PIXEL_BLACK = "0"
  PIXEL_WHITE = "1"
  PIXEL_TRANSPARENT = "2"

  def calc_part_1(pixels_wide, pixels_tall)
    chosen_layer = to_layers(pixels_wide * pixels_tall).min_by{ |layer| layer.count("0") }

    chosen_layer.count("1") * chosen_layer.count("2")
  end

  def calc_part_2(pixels_wide, pixels_tall)
    layer_size = pixels_wide * pixels_tall
    layers = to_layers(layer_size)

    decoded_image = (0..(layer_size-1)).map do |i|
      choose_pixel(layers.dup, i)
    end.join

    puts decoded_image.chars.map{ |p| p == PIXEL_BLACK ? "X" : " " }.each_slice(pixels_wide).map(&:join)

    decoded_image
  end

  private

  def to_layers(layer_size)
    layer_number = @input.length / layer_size

    (0..(layer_number-1)).map do |i|
      layer_start = i*layer_size
      layer_end = (i+1)*layer_size-1

      @input[layer_start..layer_end]
    end
  end

  def choose_pixel(layers, i)
    top_layer = layers.first
    return top_layer[i] if top_layer[i] == PIXEL_BLACK || top_layer[i] == PIXEL_WHITE
    layers.shift
    choose_pixel(layers, i)
  end
end