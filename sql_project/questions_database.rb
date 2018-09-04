require 'sqlite3'
require 'singleton'
require_relative 'qquestions_questions.rb'
require_relative 'qreplies_questions.rb'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end 
end

class User
  attr_accessor :fname, :lname
  
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM users')
    data.map { |d| User.new(d) }
  end
  
  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE id = ?
    SQL
    
    return nil if user.empty?
    
    User.new(user.first)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users 
      WHERE fname = ? AND lname = ?
    SQL
    
    return nil if user.empty?
    
    User.new(user.first)
  end
  
  def authored_questions
    Questions.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_author_id(@id)
  end
  
end