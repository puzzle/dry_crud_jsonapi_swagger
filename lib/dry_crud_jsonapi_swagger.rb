require "dry_crud_jsonapi_swagger/engine"
require "dry_crud_jsonapi_swagger/param"

module DryCrudJsonapiSwagger
  extend ActiveSupport::Concern

  included do
    class_attribute :swagger_params, instance_writer: false
    self.swagger_params = Hash.new { |hash, key| hash[key] = [] }
  end

  class_methods do
    def swagger_param(action, name, type: type, description: nil, required: false, enum: nil)
      swagger_params[action.to_sym] << Param.new(name, type, description, required, enum)
    end
  end
end
