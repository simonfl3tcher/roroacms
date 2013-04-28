class String
  def nonnegative_float?
    !!match(/\A\+?\d+(?:\.\d+)?\Z/)
  end
end