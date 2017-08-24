class Array
  def present?
    !empty?
  end

  def presence
    if present?
      self
    else
      nil
    end
  end
end
