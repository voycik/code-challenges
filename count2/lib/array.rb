class Array
  def count2(arg=nil)
    if block_given?
     counter = 0
     self.each{ |element| counter += 1 if yield(element) }
     counter
    elsif arg
      count_specific_elements(arg) 
    else
      self.size
    end
  end

  private

  def count_specific_elements(arg)
    counter = 0
    self.each{ |element| counter += 1 if element == arg }
    counter
  end
end
