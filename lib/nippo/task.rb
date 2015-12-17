module Nippo
  class Task
    def self.get_context
      ret = ""
      while s = STDIN.gets
        s.chomp =~ /^exit|^EXIT/ ? break : ret += s
      end
      ret
    end
  end
end
