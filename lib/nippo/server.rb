require 'net/http'
require 'uri'

module Nippo
  class Server
    def initialize(opts)
      @host = opts[:server]
      @basic_user = opts[:auth_user]
      @basic_passwd = opts[:auth_passwd]

      @login_user = opts[:login_user]
      @login_passwd = opts[:login_passwd]

      @task_code = opts[:code]
      @task_title = opts[:title]
      @task_context = opts[:context]

      @day = opts[:day]
      @month = opts[:month]
      @year = opts[:year]

      @logged_in = false
      @cookie = nil
    end

    def login
      resp = post({
        :path => 'new_nippou/users/login',
        :data => {
          'data[User][userid]' => @login_user,
          'data[User][password]' => @login_passwd,
          'logincheck' => '',
        },
      })
      @cookie = resp.get_fields('set-cookie').map{|x| x.split(';').first}.join(';')

      # When login processin is successful, responce code 302 (Net::HTTPFound) is returned.
      @logged_in = resp.class == Net::HTTPFound
    end
    def set_am_task
      post({
        :path => "new_nippou/inputs/nippou/#{@year}/#{@month}/#{@day}/#am",
        :data => {
          'data[Amtask][name]' => @task_code,
          'data[Amtask][taskcodename]' => @task_code,
          'data[Amtask][title]' => @task_title.encode('EUC-JP'),
          'data[Amtask][SH]' => '10',
          'data[Amtask][SM]' => '00',
          'data[Amtask][EH]' => '13',
          'data[Amtask][EM]' => '00',
          'data[Amtask][comment]' => @task_context.encode('EUC-JP'),
          'data[Amtask][plan]' => '',
          'data[Amtask][subject]' => '',
          'data[Amtask][opinion]' => '',
          'data[Amtask][other]' => '',
          'amregist' => '1',
          'data[Amtask][id]' => '',
        },
      })
    end

    def set_pm_task
      post({
        :path => "new_nippou/inputs/nippou/#{@year}/#{@month}/#{@day}/#pm",
        :data => {
          'data[Pmtask][name]' => @task_code,
          'data[Pmtask][taskcodename]' => @task_code,
          'data[Pmtask][title]' => @task_title.encode('EUC-JP'),
          'data[Pmtask][SH]' => '14',
          'data[Pmtask][SM]' => '00',
          'data[Pmtask][EH]' => '19',
          'data[Pmtask][EM]' => '00',
          'data[Pmtask][comment]' => @task_context.encode('EUC-JP'),
          'data[Pmtask][plan]' => '',
          'data[Pmtask][subject]' => '',
          'data[Pmtask][opinion]' => '',
          'data[Pmtask][other]' => '',
          'pmregist' => '1',
          'data[Pmtask][id]' => '',
        },
      })
    end

    def set_rest
      post({
        :path => "new_nippou/inputs/nippou/#{@year}/#{@month}/#{@day}/#rest",
        :data => {
          'data[Rest][SH]' => '13',
          'data[Rest][SM]' => '00',
          'data[Rest][EH]' => '14',
          'data[Rest][EM]' => '00',
          'registresttime' => '登録'.encode('EUC-JP'),
        },
      })
    end

    def submit
      post({
        :path => "new_nippou/inputs/nippouend/#{@year}/#{@month}/#{@day}/",
        :data => {
          'data[Mail][memo]' => '',
        },
      })
    end

    def logged_in?
      @logged_in
    end

    private
    def post(opts)
      url = URI.parse("http://#{@host}/#{opts[:path]}")

      # setting request parameters
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth(@basic_user, @basic_passwd)
      req.set_form_data(opts[:data])
      req['Cookie'] = @cookie

      # send http post request
      Net::HTTP.new(url.host, url.port).start do |http|
         http.request(req)
      end
    end
  end
end
