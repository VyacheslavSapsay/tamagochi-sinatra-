# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'yaml'

class Tomagochi
  attr_accessor :type, :name, :hp, :hungry, :mood, :sleep, :wallking, :training, :newday

  def initialize(type, name, hp, hungry, mood, sleep, wallking, training, newday)
    @type = type
    @name = name
    @hp = hp
    @hungry = hungry
    @mood = mood
    @sleep = sleep
    @wallking = wallking
    @training = training
    @newday = newday
  end

  def gameover
    @hp <= 0 || @hungry <= 0 || @mood <= 0 || @sleep <= 0 || @wallking <= 0 || @training <= 0
  end

  def checking
    if @hp > 10
      @hp = 10
    elsif @hungry > 10
      @hungry = 10
    elsif @mood > 10
      @mood = 10
    elsif @sleep > 10
      @sleep = 10
    elsif @wallking > 10
      @wallking = 10
    elsif @training > 10
      @training = 10
    end
  end

  def hp
    @hp += 1
    @hungry -= 1
    @mood -= 1
    @sleep -= 1
    @wallking -= 1
    @training -= 1
  end

  def eating
    if @hungry < 10
      @hungry += 1
      @mood += 1
      @sleep -= 1
      @wallking -= 1
      @training -= 1
    else
      puts "I'm not hungry"
    end
  end

  def play
    if @play < 10
      @play += 1
      @mood += 1
      @sleep -= 1
      @wallking -= 1
    else
      puts "I don't want to play"
    end
  end

  def mood
    if @mood < 10
      @mood += 1
      @hungry -= 1
    else
      puts "I'm happy!!"
    end
  end

  def sleep
    if @sleep < 10
      @sleep += 1
      @mood += 1
      @hungry -= 1
      @wallking -= 1
      @training -= 1
    else
      puts "I don't want to sleep!"
    end
  end

  def wallking
    if @wallking < 10
      @wallking += 1
      @mood += 1
      @hungry -= 1
      @sleep -= 1
      @training -= 1
    else
      puts "I don't want to wallk"
    end
  end

  def training
    if @training < 10
      @training += 1
      @mood += 1
      @hungry -= 1
      @sleep -= 1
      @wallking -= 1
    else
      puts "I don't want to train"
    end
  end

  def tohtml
    @stats = "
Type: #{@type} \nName: #{@name} \nHp: #{@hp}/10 \nHungry: #{@hungry}/10 \nMood: #{@mood}/10 \nSleep: #{@sleep}/10 \nWallking: #{@wallking}/10 \nTraining: #{@training}/10"
  end

  def update_database
    f = File.open('database.yml', 'w')
    params_hash = { "Type": @type, "Name": @name, "Hp": @hp, "Hungry": @hungry, "Mood": @mood, "Sleep": @sleep, "Wallking": @walking, "Training": @training }
    f.write(params_hash.to_yaml)
    f.close
  end

  def delete
    @hp = 0
    @hungry = 0
    @mood = 0
    @sleep = 0
    @wallking = 0
    @training = 0
    @newday = 0
    update_database
  end

  private

  def newday
    @newday += 1
    if @newday.even?
      @hp -= 1
      @hungry -= 1
      @mood -= 1
      @sleep -= 1
      @wallking -= 1
      @training -= 1
    elsif @newday % 5 == 0
      @hp += 1
      @hungry += 1
      @mood += 1
      @sleep += 1
      @wallking += 1
      @training += 1
    elsif @newday % 9 == 0
      @hp -= 1
      @hungry -= 1
      @mood -= 1
      @sleep -= 1
      @wallking -= 1
      @training -= 1
    elsif @newday % 50 == 0
      @hp += 1
      @hungry += 1
      @mood += 1
      @sleep += 1
      @wallking += 1
      @training += 1
    elsif @newday % 21 == 0
      @training += 1
      @mood += 1
    end
  end
end
get '/' do
  erb :pet_create
end

post '/pet_created' do
  @@pet_type = params[:pet_type]
  @@pet_name = params[:pet_name]
  @@pet = Tomagochi.new(@@pet_type, @@pet_name, 10, 10, 10, 10, 10, 10, 1)
  erb :pet_created
end

get '/pet' do
  @@pet.update_database
  redirect to '/pet_die' if @@pet.gameover
  @@pet.checking
  erb :pet
end

post '/eat' do
  @@pet.eating
  erb :eat
end

post '/hp' do
  @@pet.hp
  erb :hp
end

post '/play' do
  @@pet.mood
  erb :play
end

post '/sleep' do
  @@pet.sleep
  erb :sleep
end
post '/wallking' do
  @@pet.wallking
  erb :wallking
end
post '/training' do
  @@pet.training
  erb :training
end
post '/skip_time' do
  @@pet.send(:newday)
  erb :skip_time
end
get '/pet_die' do
  erb :pet_die
end

post '/pet_delete_confirm' do
  erb :pet_delete_confirm
end

post '/pet_delete' do
  @@pet.delete
  erb :pet_delete
end
