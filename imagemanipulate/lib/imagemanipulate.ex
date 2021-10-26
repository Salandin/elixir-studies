defmodule Imagemanipulate do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def draw_image(%Imagemanipulate.Image{color: color, pixel_map: pixel_map} = image) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def pick_color(%Imagemanipulate.Image{hex: [red, green, blue | _tail]} = image) do
    %Imagemanipulate.Image{image | color: {red, green, blue}}
  end

  def build_pixel_map(%Imagemanipulate.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horiz = rem(index, 5) * 50
      verti = div(index, 5) * 50

      top_left = {horiz, verti}
      bottom_right = {horiz + 50, verti + 50}

      {top_left, bottom_right}
    end

    %Imagemanipulate.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Imagemanipulate.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code,2) == 0
    end

    %Imagemanipulate.Image{image | grid: grid}
  end

  def build_grid(%Imagemanipulate.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_image/1)
    |> List.flatten
    |> Enum.with_index

    %Imagemanipulate.Image{image | grid: grid}
  end

  def mirror_image(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Imagemanipulate.Image{hex: hex}
  end
end
