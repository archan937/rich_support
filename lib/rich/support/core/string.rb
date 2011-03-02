require "rich/support/core/string/colorize"
require "rich/support/core/string/html_safe"
require "rich/support/core/string/inflections"

class String
  include Rich::Support::Core::String::Colorize
  include Rich::Support::Core::String::HtmlSafe
  include Rich::Support::Core::String::Inflections
end