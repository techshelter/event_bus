require './lib/event_bus'

bus = EventBus.new

bus.register('user.created')
bus.register('food.arrived')
bus.register('test')

class Test
  def on_test(payload)
    puts "my test: #{payload}"
  end
end

class FoodHandler
  def on_food_arrived(payload)
    puts "My food has arrived #{payload[:food]}"
  end
end

class UserHandler
  def on_user_created(payload)
    puts "User created => #{payload[:user]}"
  end
end

class TestHandler
  def on_user_created(payload)
    puts "Je m execute aussi"
  end
end

bus.subscribe(Test.new)
bus.subscribe(UserHandler.new)
bus.subscribe(TestHandler.new)
# bus.subscribe(FoodHandler.new)

bus.on('user.created') {|payload| puts "please send mail to user #{payload[:user]}"}
# bus.on('user.created') { puts "this user is an admin"}

# bus.on('food.arrived') {|payload| puts "Daouda will eat #{payload[:food]}"}

# bus.on('event') { p "hello" }


bus.publish('test', test: 1)
# bus.publish('food.arrived', food: 'alloco poulet')
bus.publish('user.created', user: 'Kalifa Bayoko')