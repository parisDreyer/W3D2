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
  
  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        *
      FROM 
        question_follows 
      JOIN
        users 
      ON 
        users.id = question_follows.user_id
      WHERE 
        question_follows.question_id = ?
    SQL
    return nil if followers.empty?
    
    followers.map { |f| User.new(f) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        *
      FROM 
        question_follows 
      JOIN
        questions
      ON 
        questions.id = question_follows.user_id
      WHERE 
        question_follows.user_id = ?
    SQL
    return nil if followers.empty?
    
    followers.map { |f| Questions.new(f) }
  end
  
  def self.most_followed_questions(n)
    followers = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT 
        *
      FROM 
        question_follows 
      JOIN
        questions
      ON 
        questions.id = question_follows.user_id
      GROUP BY
        title
      ORDER BY COUNT(title)
      LIMIT ?
        
    SQL
    return nil if followers.empty?
    
    followers.map { |f| Questions.new(f) }
  end
  

end