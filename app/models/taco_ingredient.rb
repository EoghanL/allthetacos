class TacoIngredient
  @@class_name = TacoIngredient

  def self.db
    DB[:conn]
  end

  def self.table_name
    self.to_s.split(/(?=[A-Z])/).last.downcase + "s"
  end

  def self.column_names
    columns = DB[:conn].execute("PRAGMA table_info(ingredients)").map{|column| column[1]}
    columns.each do |att|
      attr_accessor att.to_sym
    end
    columns
  end

  def self.find(id)
    row = DB[:conn].execute("SELECT * from #{@@class_name.table_name} where id = #{id}").first
    self.new_from_row(row)
  end

  def self.all
    rows = self.db.execute("SELECT * from #{@@class_name.table_name}")
    rows.map do |row|
      self.new_from_row(row)
    end
  end

  def self.new_from_row(row)
    ingr = @@class_name.new
    @@class_name.column_names.each_with_index do |column, index|
      ingr.send(column+"=", row[index])
    end
    ingr
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS #{@@class_name.table_name}
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT, calories INTEGER,
      vegetarian BOOLEAN, cost INTEGER);
    SQL

    self.db.execute(sql)
  end

  def insert
    cols = TacoIngredient.column_names.drop(1).join(", ")
#    binding.pry
    vals = @@class_name.column_names.map{|col| "'#{self.send(col)}'"}.drop(1).join(", ")
#    binding.pry
    sql = <<-SQL
      INSERT INTO #{@@class_name.table_name} (#{cols})
      VALUES (#{vals});
    SQL
    binding.pry
    self.class.db.execute(sql)

  end

  def destroy
    sql = <<-SQL
      DELETE FROM taco_ingredients WHERE id = ?;
    SQL

    self.class.db.execute(sql, self.id)
  end

  def update
    sql = <<-SQL
      UPDATE taco_ingredients
      SET name = ?, calories = ?, vegetarian = ?, cost = ?
      WHERE id = ?
    SQL

    self.class.db.execute(sql, self.name, self.calories, self.vegetarian, self.cost, self.id)
  end
end
