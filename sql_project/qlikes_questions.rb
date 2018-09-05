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
  
  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        *
      FROM 
        users 
      JOIN     
        question_likes 
      ON 
        question_likes.user_id = users.id
      WHERE 
        question_likes.question_id = ?
    SQL
    return nil if likers.empty?
    
    likers.map { |q| User.new(q) }
  end
  
  def self.num_likes_for_question_id(question_id)
    count = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        COUNT(user_id)
      FROM 
        users 
      JOIN     
        question_likes 
      ON 
        question_likes.user_id = users.id
      WHERE 
        question_likes.question_id = ?
    SQL
    count 
  end
  
  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        *
      FROM 
        questions 
      JOIN     
        question_likes 
      ON 
        question_likes.question_id = questions.id
      WHERE 
        question_likes.user_id = ?
    SQL
    return nil if questions.empty?
    
    questions.map { |q| Questions.new(q) }
  end
  
  
end