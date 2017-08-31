class String
  BLANK_RE = /\A[[:space:]]*\z/

  def present?
    !blank?
  end

  def blank?
    empty? || BLANK_RE.match(self)
  end

  def presence
    blank? ? nil : self
  end
end
