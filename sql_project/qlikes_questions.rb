require_relative 'questions_database.rb'

class QuestionLikes
  
  attr_accessor :id, :user_id, :question_id
  
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.find_by_id(id)
    qLikes = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        * 
      FROM 
        question_likes 
      WHERE 
        id = ?
    SQL
    return nil if qLikes.empty?
    
    QuestionLikes.new(qLikes.first)
  end
    
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
    data.map { |d| QuestionLikes.new(d) }
  end
end