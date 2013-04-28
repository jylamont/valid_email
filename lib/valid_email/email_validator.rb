require 'active_model'
require 'active_model/validations'
require 'valid_email/email'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    begin
      r = ValidEmail::Email.valid?(value)

      # Check if domain has DNS MX record
      if r && options[:mx]
        require 'valid_email/mx_validator'
        r &&= MxValidator.new(:attributes => attributes).validate(record)
      end
    rescue Exception => e
      r = false
    end
    record.errors.add attribute, (options[:message] || I18n.t(:invalid, :scope => "valid_email.validations.email")) unless r
  end
end
