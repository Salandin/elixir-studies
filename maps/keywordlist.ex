colors = [{:primary, "red"}, {:secondary, "blue"}]

IO.puts(colors[:primary])
IO.puts(colors[:secondary])

IO.inspect(colors = [{:primary, "red"}, {:primary, "blue"}])
IO.inspect(colors = [{:primary, "red"}, {:primary, "red"}])
