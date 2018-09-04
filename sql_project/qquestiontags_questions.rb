require_relative 'questions_database.rb'

class QuestionTags
  attr_accessor :id, :tag_id, :question_id
  
  
  def initialize(options)
    @id = options['id']
    @tag_id = options['tag_id']
    @question_id = options['question_id']
  end
  
  def self.find_by_id(id)
    question_tags = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        * 
      FROM 
        question_tags 
      WHERE 
        id = ?
    SQL
    return nil if question_tags.empty?
    
    QuestionTags.new(question_tags.first)
  end
    
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM question_tags')
    data.map { |d| QuestionTags.new(d) }
  end
end