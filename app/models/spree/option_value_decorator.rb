Spree::OptionValue.class_eval do
  # Removed for Rails 4, must convert to strong params.
  # attr_accessible :adder, :customization_lines
  has_many :line_item_option_values
end
