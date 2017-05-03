# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


school_data = [
  {name: 'Arts Magnet Elementary School'},
  {name: 'Cragmont Elementary School'},
  {name: 'Emerson Elementary School'},
  {name: 'Jefferson Elementary School'},
  {name: 'John Muir Elementary School'},
  {name: 'LeConte Elementary School'},
  {name: 'Malcolm X Elementary School'},
  {name: 'Oxford Elementary School'},
  {name: 'Rosa Parks Elementary School'},
  {name: 'Thousand Oaks Elementary School'},
  {name: 'Washington Elementary School'},
  {name: 'King Middle Middle School'},
  {name: 'Longfellow Middle School'},
  {name: 'Willard Middle School'},
  {name: 'Franklin District Preschool'},
  {name: 'Hopkins District Preschool'},
  {name: 'King District Preschool'},
  {name: 'Berkeley High School - AC'},
  {name: 'Berkeley High School - AHA'},
  {name: 'Berkeley High School - CAS'},
  {name: 'Berkeley High School - CPA'},
  {name: 'Berkeley High School - GA'},
  {name: 'Berkeley High School - IB'},
  {name: 'Berkeley High School - All'},
  {name: 'BTA'},
  {name: 'Independent Study'},
  {name: 'Districtwide'},
  {name: 'Herrick Hospital'},
  {name: 'Other BUSD'}
]

schools = School.create(school_data)


