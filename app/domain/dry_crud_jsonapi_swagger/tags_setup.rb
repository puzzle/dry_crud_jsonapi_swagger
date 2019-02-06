require 'yaml'

module DryCrudJsonapiSwagger
  class TagsSetup

    def initialize(swagger_doc = nil)
      @swagger_doc = swagger_doc
    end

    def run
      setup_tags
    end

    def path_tag(path)
      customized_tag(path) || derived_tag(path)
    end

    private

    def customized_tag(path)
      customized_tags.each do |tag|
        next if tag['include'].blank?

        return tag['name'] if tag['include'].any? { |inc| path =~ /#{inc}/i }
      end
      
      nil
    end

    def derived_tag(path)
      path.gsub(%r(/{[^}]+}), '').gsub('/', ' ').strip.titleize
    end

    def setup_tags
      customized_tags.each do |tag|
        @swagger_doc.tags tag.slice('name', 'description', 'externalDocs')
      end
    end

    def customized_tags
      @customized_tags ||= load_customized_tags
    end

    def load_customized_tags
      return [] unless File.exist?(Rails.root.join('config', 'swagger-tags.yml'))

      YAML.load_file(Rails.root.join('config', 'swagger-tags.yml')).yield_self do |tags_data|
        raise('Your config/swagger-tags.yml contains malformed data') unless
          Array.wrap(tags_data&.keys).include?('tags') &&
          Array.wrap(tags_data['tags']).all? { |tag| tag.is_a?(Hash) }

        Array.wrap(tags_data['tags'])
      end
    end
  end
end
