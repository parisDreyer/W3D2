require_relative 'questions_database.rb'


class Reply
  attr_accessor :id, :user_id, :question_id
  
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
  end
  
  def self.find_by_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        * 
      FROM 
        replies 
      WHERE 
        id = ?
    SQL
    return nil if replies.empty?
    
    Reply.new(replies.first)
  end
    
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    data.map { |d| Reply.new(d) }
  end
  
  def self.find_by_author_id(author_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT 
        * 
      FROM 
        replies 
      WHERE 
        replies.author_id = ?
    SQL
    return nil if replies.empty?
    
    replies.map { |r| Reply.new(r) }
  end
  
  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        * 
      FROM 
        replies 
      WHERE 
        replies.question_id = ?
    SQL
    return nil if replies.empty?
    
    replies.map { |r| Reply.new(r) }
  end
  
  def author 
    User.find_by_id(@author_id)
  end
  
  def question 
    Questions.find_by_id(@question_id)
  end
  
  def parent_reply 
    Reply.find_by_id(@parent_reply_id)
  end 
  
  def child_replies
    Reply.find_by_question_id(@question_id)
  end
end