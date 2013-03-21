RSpec::Matchers.define :have_ability_to do |ability, target|
  match do |user|
    Ability.new(user).can? ability, target
  end

  def username user
    user ? user.username : 'guest'
  end

  def target_name target
    if target.respond_to? :id
      "'#{target.class}'[#{target.try(:id)}]"
    else
      "#{target}"
    end
  end

  failure_message_for_should do |user|
    "expected #{username(user)} can #{ability} #{target_name(target)}, but couldn't"
  end

  failure_message_for_should_not do |user|
    "expected #{username(user)} can not #{ability} #{target_name(target)}, but could"
  end

end
