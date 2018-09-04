require_relative 'questions_database.rb'

class QuestionFollows 
  
  attr_accessor :id, :user_id, :question_id
  
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.find_by_id(id)
    qfollows = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        * 
      FROM 
        question_follows 
      WHERE 
        id = ?
    SQL
    return nil if qfollows.empty?
    
    QuestionFollows.new(qfollows.first)
  end
    
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM question_follows')
    data.map { |d| QuestionFollows.new(d) }
  end
  
  
end