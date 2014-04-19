LCS_MATH = {}

function LCS_MATH.Round( x )
  if x % 2 ~= 0.5 then
    return math.floor( x + 0.5 )
  end

  return x - 0.5
end