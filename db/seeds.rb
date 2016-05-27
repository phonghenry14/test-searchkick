# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
20000.times do |index|
  index = 15321 + 1
  pr = Product.create name: "product#{index}"
  c =City.create name: "city#{index}"
  po = Position.create name: "position#{index}"
  pj = Project.create name: "project#{index}"
  sk = Skill.create name: "skill#{index}"
  sc = School.create name: "school#{index}"
  User.create name: "user#{index}", age: 24, product_id: pr.id,
    position_id: po.id, skill_id: sk.id, school_id: sc.id, project_id: pj.id,
    city_id: c.id
end
