require 'spec_helper'

describe EmailValidator do

  let(:record) { User.new }
  let(:validator) { EmailValidator.new({attributes: :email}) }

  it "empty email should be valid" do
    validator.validate_each(record, :email, '')
    expect(record.errors[:email]).to be_empty
  end

  it "invalid_email.com should be invalid" do
    validator.validate_each(record, :email, 'invalid_email.com')
    expect(record.errors[:email]).to have(1).item
    expect(record.errors[:email].first).to be_eql("not a valid email address")
  end

  it "foo@bar.com should be invalid" do
    validator.validate_each(record, :email, 'foo@bar.com')
    expect(record.errors[:email]).to be_empty
  end

end
