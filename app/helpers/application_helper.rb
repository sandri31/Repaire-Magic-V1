# frozen_string_literal: true

# Replace magic symbols in text with images
# @param text [String] Text in which to replace magic symbols
# @param magic_symbols [Hash] Map of magic symbols to image filenames
# @return [String] Text with magic symbols replaced by images
module ApplicationHelper
  def replace_magic_symbols(text, magic_symbols)
    magic_symbols.each do |symbol, image|
      text = text.gsub(/(?<!\w)#{Regexp.escape(symbol)}(?!\w)/,
                       ActionController::Base.helpers.image_tag(image, class: 'magic-symbol'))
    end

    text.html_safe
  end
end
