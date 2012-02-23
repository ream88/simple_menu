# http://stackoverflow.com/questions/3772864/how-do-i-remove-leading-whitespace-chars-from-ruby-heredoc#answer-5638187

class String
  # Strip leading whitespace from each line that is the same as the 
  # amount of whitespace on the first line of the string.
  # Leaves _additional_ indentation on later lines intact.
  def unindent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end