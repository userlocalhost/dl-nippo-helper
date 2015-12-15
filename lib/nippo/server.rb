require 'net/http'
require 'uri'

module Nippo
  class Server
    def initialize(host, user, passwd)
      @host = host
      @basic_user = user
      @basic_passwd = passwd

      @logged_in = false
    end

    def login(user, passwd)
      url = URI.parse("http://#{@host}/new_nippou/users/login")
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth(@basic_user, @basic_passwd)
      req.set_form_data({
        'data[User][userid]' => user,
        'data[User][password]' => passwd,
        'logincheck' => '',
      })
      resp = Net::HTTP.new(url.host, url.port).start do |http|
         http.request(req)
      end
      @cookie = resp.get_fields('set-cookie').map{|x| x.split(';').first}.join(';')

      # When login processin is successful, responce code 302 (Net::HTTPFound) is returned.
      @logged_in = resp.class == Net::HTTPFound
    end

    def set_am_task(code, title, context)
    end

    def set_pm_task(code, title, context)
    end

    def set_rest
    end

    def pre_submit
    end

    def logged_in?
      @logged_in
    end
  end
end
