module DryCrudJsonapiSwagger
  module Helper

    def setup_swagger_path(path, helper = self, &block)
      return unless path
      @path = path.gsub('1', '{id}')
      controller_class.send(:swagger_path, @path) do
        instance_exec(helper, &block)
      end
    end

    def model_name
      controller_class.model_class.model_name
    end

    def human_name
      model_name.human
    end

    def nested_human_name
      nested_model_name.human
    end

    def controller_route
      controller_class.model_class.new(id: 1)
    end

    def nested_root_path
      nested_model_name.route_key
    end

    def nested_controller_id
      controller_class.model_class.model_name.route_key.singularize + '_id'
    end

    def nested_model_name
      nested_class.model_class.model_name
    end

    def include_description(controller = controller_class)
      <<~DESC
        Available primary relations:
        #{includes(controller.model_class).map { |inc| "* #{inc}" }.join("\n")}

        Separate values with a comma

        To include sub-relations, specify the relationship chain with the elements separated by '.'
        i.e. "employee.address.town"
      DESC
    end

    def includes(model_class)
      model_class.reflect_on_all_associations.reject(&:polymorphic?).map(&:name).sort
    end

    def path_spec(swagger_doc, helper, type) # rubocop:disable Metrics/MethodLength
      summary =
        case type.to_sym
        when :index  then "All #{human_name.pluralize}"
        when :show   then "Single #{human_name}"
        when :nested then "All #{nested_human_name.pluralize} belonging to #{human_name}"
        end

      swagger_doc.operation :get do
        key :summary, summary
        helper.setup_tag(self)
        helper.parameters(self, helper, type)
        response 200 do
          key :description, summary + ' Response'
          helper.response_schema(self, helper, type)
        end
      end
    end

    def setup_tag(swagger_doc)
      tag = TagsSetup.new.path_tag(@path)
      swagger_doc.key :tags, [tag] if tag.present?
    end

    def parameters(swagger_doc, helper, type)
      case type.to_sym
      when :index
        parameter_custom swagger_doc, type
      when :show, :nested
        parameter_id swagger_doc, helper
      end

      parameter_include swagger_doc, helper, type
    end

    def parameter_id(swagger_doc, helper)
      swagger_doc.parameter do
        key :name, :id
        key :in, :path
        key :description, "ID of #{helper.human_name} to fetch"
        key :required, true
        key :type, :integer
      end
    end

    def parameter_include(swagger_doc, helper, type) # rubocop:disable Metrics/MethodLength
      desc = case type.to_sym
               when :index, :show then include_description
               when :nested       then include_description(helper.nested_class)
             end
      swagger_doc.parameter do
        key :name,             :include
        key :in,               :query
        key :description,      desc
        key :required,         false
        key :type,             :array
        key :collectionFormat, :csv
        items do
          key :type, :string
        end
      end
    end

    def parameter_custom(swagger_doc, type)
      controller_class.swagger_params[type].each do |param|
        swagger_doc.parameter do
          key :name,        param.name
          key :in,          :query
          key :description, param.description
          key :required,    param.required
          key :type,        param.type
          key :enum,        param.enum if param.enum.present?
        end
      end
    end

    def response_schema(swagger_doc, helper, type)
      ref = case type.to_sym
            when :index, :show then helper.model_name
            when :nested       then helper.nested_model_name
            end

      swagger_doc.schema do
        key :type, :array
        items do
          key :'$ref', ref
        end
      end
    end
  end
end
