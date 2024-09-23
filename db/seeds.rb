# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Clear database
Studio.destroy_all

# Create studios
studio_big = Studio.create!(name: 'Very nice studio', description: 'Very big apartment')
studio_small = Studio.create!(name: 'Super nice studio', description: 'Small apartment')

puts 'Studios seeded successfully'

# Create stays for studio_big
Stay.create!(studio: studio_big, start_date: '2024-01-01', end_date: '2024-01-08')
Stay.create!(studio: studio_big, start_date: '2024-01-16', end_date: '2024-01-24')

# Create stays for studio_small
Stay.create!(studio: studio_small, start_date: '2024-01-05', end_date: '2024-01-10')
Stay.create!(studio: studio_small, start_date: '2024-01-15', end_date: '2024-01-20')
Stay.create!(studio: studio_small, start_date: '2024-01-21', end_date: '2024-01-25')

puts 'Stays seeded successfully'
