require 'active_model'
require 'active_model/validations'
require 'valid_email/email'

class MxValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    r = ValidEmail::Email.mx_valid?(value)
    record.errors.add attribute, (options[:message] || I18n.t(:invalid, :scope => "valid_email.validations.email")) unless r
    r
  end
end
