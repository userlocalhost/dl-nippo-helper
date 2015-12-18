require 'net/http'
require 'uri'

module Nippo
  class Server
    def initialize(host, user, passwd)
      @host = host
      @basic_user = user
      @basic_passwd = passwd

      @logged_in = false
      @cookie = nil
    end

    def login(user, passwd)
      resp = post({
        :path => 'new_nippou/users/login',
        :data => {
          'data[User][userid]' => user,
          'data[User][password]' => passwd,
          'logincheck' => '',
        },
      })
      @cookie = resp.get_fields('set-cookie').map{|x| x.split(';').first}.join(';')

      # When login processin is successful, responce code 302 (Net::HTTPFound) is returned.
      @logged_in = resp.class == Net::HTTPFound
    end
    def set_am_task(opts)
      post({
        :path => "new_nippou/inputs/nippou/#{opts[:year]}/#{opts[:month]}/#{opts[:day]}/#am",
        :data => {
          'data[Amtask][name]' => opts[:code],
          'data[Amtask][taskcodename]' => opts[:code],
          'data[Amtask][title]' => opts[:title].encode('EUC-JP'),
          'data[Amtask][SH]' => '10',
          'data[Amtask][SM]' => '00',
          'data[Amtask][EH]' => '13',
          'data[Amtask][EM]' => '00',
          'data[Amtask][comment]' => opts[:context].encode('EUC-JP'),
          'data[Amtask][plan]' => '',
          'data[Amtask][subject]' => '',
          'data[Amtask][opinion]' => '',
          'data[Amtask][other]' => '',
          'amregist' => '1',
          'data[Amtask][id]' => '',
        },
      })
    end

    def set_pm_task(opts)
      post({
        :path => "new_nippou/inputs/nippou/#{opts[:year]}/#{opts[:month]}/#{opts[:day]}/#pm",
        :data => {
          'data[Pmtask][name]' => opts[:code],
          'data[Pmtask][taskcodename]' => opts[:code],
          'data[Pmtask][title]' => opts[:title].encode('EUC-JP'),
          'data[Pmtask][SH]' => '14',
          'data[Pmtask][SM]' => '00',
          'data[Pmtask][EH]' => '19',
          'data[Pmtask][EM]' => '00',
          'data[Pmtask][comment]' => opts[:context].encode('EUC-JP'),
          'data[Pmtask][plan]' => '',
          'data[Pmtask][subject]' => '',
          'data[Pmtask][opinion]' => '',
          'data[Pmtask][other]' => '',
          'pmregist' => '1',
          'data[Pmtask][id]' => '',
        },
      })
    end

    def set_rest(opts)
      post({
        :path => "new_nippou/inputs/nippou/#{opts[:year]}/#{opts[:month]}/#{opts[:day]}/#rest",
        :data => {
          'data[Rest][SH]' => '13',
          'data[Rest][SM]' => '00',
          'data[Rest][EH]' => '14',
          'data[Rest][EM]' => '00',
          'registresttime' => '登録'.encode('EUC-JP'),
        },
      })
    end

    def submit(opts)
      post({
        :path => "new_nippou/inputs/nippouend/#{opts[:year]}/#{opts[:month]}/#{opts[:day]}/",
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
