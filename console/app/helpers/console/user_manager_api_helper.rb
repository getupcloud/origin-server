module Console::UserManagerApiHelper

  class GetupResponse
    def initialize(response)
      @code = response.code.to_i
      @body = response.body
      @message = response.message
      @header = response.header
      @content = JSON.parse response.body, :symbolize_names => true rescue nil
    end

    def code
      @code
    end

    def body
      @body
    end

    def message
      @message
    end 

    def content
      @content
    end

    def header
      @header
    end
  end

  # 
  # 
  def user_manager_post (path, params={})
    call path, params, 'POST'
  end

  def user_manager_get (path, params={})
    call path, params
  end

  private
    def call(path, params, method='GET')
      path = format_path path

      uri = URI.parse get_user_manager_url + path[:address]

      http = Net::HTTP.new uri.host, uri.port

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = if method === 'GET'
        Net::HTTP::Get.new uri.request_uri
      else
        Net::HTTP::Post.new uri.request_uri
      end

      request['X-Remote-User'] = path[:user] if path[:user]
      request.set_form_data(params)

      #puts "User Manager API Helper Req: #{method} #{uri.request_uri}"
      #if method == 'POST'
      #  puts "User Manager API Helper Data: #{params}"
      #end
      response = http.request request
      #puts "response: #{response}"
      response_code = response.code.to_i
      #puts "User Manager API Helper Res: #{response} => #{response.body}"

      if response_code == 500
        raise "Error retrieving resource: #{path}"
        #render inline: response.body.html_safe
      else
        GetupResponse.new response
      end
    end

    def get_user_manager_url
      Console.config.api[:user_manager][:api]
    end

    def format_path path
      if path[0] != '/'
        pipe_position = path.index '/'
        {:user => (path.slice 0, pipe_position), :address => (path.slice pipe_position..-1)}
      else
        {:address => path}
      end
    end
end
