require_relative 'questions_database.rb'

class Tags
  attr_accessor :id, :name
  
  
  def initialize(options)
    @id = options['id']
    @name = options['name']
  end
  
  def self.find_by_id(id)
    tags = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        * 
      FROM 
        tags 
      WHERE 
        id = ?
    SQL
    return nil if tags.empty?
    
    Tags.new(tags.first)
  end
    
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM tags')
    data.map { |d| Tags.new(d) }
  end
end