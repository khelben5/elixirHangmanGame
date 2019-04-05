:timer.tc(fn ->
  for a <- 1..99,
      b <- (a + 1)..99,
      c <- (b + 1)..99,
      :math.pow(a, 2) + :math.pow(b, 2) == :math.pow(c, 2) do
    {a, b, c}
  end
end)
|> IO.inspect()
