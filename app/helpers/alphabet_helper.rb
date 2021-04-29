module AlphabetHelper
  def alphabet
    ('a'..'z').to_a
  end

  def link_to_alphabet
    links = alphabet.map do |letter|
      link_to letter.upcase, "##{letter}", class: 'btn btn-outline-primary me-1 mb-1'
    end

    links.join
  end
end
