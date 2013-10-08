module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def yellow?(a,b)
		if(a==b)
			return "hilite"
		else
			return nil
		end
  end
end
