module Namely
  class ResourceGateway
    attr_reader :endpoint

    def initialize(options)
      @options = options
      @limit = options[:limit]
    end

    def json_index
      get("/#{endpoint}", limit: limit, after: after)[resource_name]
    end

    def json_show(id)
      get("/#{endpoint}/#{id}")[resource_name].first
    end

    def show_head(id)
      head("/#{endpoint}/#{id}")
    end

    def create(attributes)
      response = post(
        "/#{endpoint}",
        endpoint => [attributes]
      )
      extract_id(response)
    end

    def update(id, changes)
      put("/#{endpoint}/#{id}", endpoint => [changes])
    end

    attr_writer :limit, :after

    private

    attr_reader :options

    def access_token
      options[:access_token]
    end

    def subdomain
      options[:subdomain]
    end

    def endpoint
      options[:endpoint]
    end

    def limit
      @limit || :all
    end

    def after
      @after = options.fetch(:after, 0)
    end

    def paged?
      @limit
    end

    def resource_name
      endpoint.split("/").last
    end

    def url(path)
      "https://#{subdomain}.namely.com/api/v1#{path}"
    end

    def extract_id(response)
      JSON.parse(response)[endpoint].first["id"]
    rescue StandardError => e
      raise(
        FailedRequestError,
        "Couldn't parse \"id\" from response: #{e.message}"
      )
    end

    def get(path, params = {})
      params.merge!(access_token: access_token)
      JSON.parse(RestClient.get(url(path), accept: :json, params: params))
    end

    def head(path, params = {})
      params.merge!(access_token: access_token)
      RestClient.head(url(path), accept: :json, params: params)
    end

    def post(path, params)
      params.merge!(access_token: access_token)
      RestClient.post(
        url(path),
        params.to_json,
        accept: :json,
        content_type: :json,
      )
    end

    def put(path, params)
      params.merge!(access_token: access_token)
      RestClient.put(
        url(path),
        params.to_json,
        accept: :json,
        content_type: :json
      )
    end
  end
end
