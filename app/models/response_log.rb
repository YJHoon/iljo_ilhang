class ResponseLog < ApplicationRecord
  enum request_type: { open_api: 0, crawling: 1 }
end
