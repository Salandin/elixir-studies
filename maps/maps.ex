colors = %{primary: "red", secondary: "green"}
IO.puts(colors.primary)
IO.puts(colors.secondary)

IO.inspect(Map.put(colors, :primary, "purple"))

IO.puts(colors.primary)
IO.puts(colors.secondary)
