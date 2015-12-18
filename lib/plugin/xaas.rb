module Nippo
  # this class generate random task
  class Task
    DEFAULT_LENGTH = 4

    PATTERN = [
      '* タスク整理',
      '* チームミーティング',
      '* ドキュメント整理',
      '* 1on1',
      '* 社外ミーティング',
      '* 資料作成',
      '* 打ち合わせ',
      '* 開発',
      '* 報告書作成',
      '* 案件対応',
    ]

    def self.get_context
      ret = ""
      DEFAULT_LENGTH.times do
        ret += PATTERN[rand(PATTERN.size)] + "\n"
      end
      ret
    end
  end
end
