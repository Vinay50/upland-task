# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

10.times do |i|
  Product.create( name: "#Star Wars #{i}", category: "Lord of the Rings #{i}")
end

