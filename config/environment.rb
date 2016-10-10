require_relative '../app/models/taco_ingredient.rb'
require 'bundler'
Bundler.require

require_all 'app/'

DB = {:conn => SQLite3::Database.new("db/taco_ingredients.db")}

dropsql = <<-SQL
DROP TABLE IF EXISTS ingredients;
SQL

createsql = <<-SQL
CREATE TABLE ingredients(id INTEGER PRIMARY KEY, name TEXT, calories INTEGER,
    cost INTEGER, vegetarian BOOLEAN);
SQL

insertsql = <<-SQL
INSERT INTO ingredients(name, calories, cost, vegetarian) VALUES("Onion", 15, 3, 1);
SQL

DB[:conn].execute(dropsql)
DB[:conn].execute(createsql)
DB[:conn].execute(insertsql)

TacoIngredient.column_names
bean = TacoIngredient.new
bean.name, bean.cost, bean.calories, bean.vegetarian = "bean", 3, 150, 1
bean.insert

Pry.start
