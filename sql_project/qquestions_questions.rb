require_relative 'questions_database.rb'
require_relative 'qreplies_questions'

class Questions
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    
    @author_id = options['author_id']
  end
  
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    data.map { |d| Questions.new(d) }
  end
  
  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        * 
      FROM 
        questions 
      WHERE 
        id = ?
    SQL
    return nil if question.empty?
    
    Questions.new(question.first)
  end
    
  
  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT 
        * 
      FROM 
        questions 
      WHERE 
        questions.author_id = ?
    SQL
    return nil if questions.empty?
    
    questions.map { |q| Questions.new(q) }
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies 
    Reply.find_by_question_id(@id)
  end
end
