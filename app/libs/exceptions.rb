module Exceptions
  class DefaultError < StandardError
    attr_reader :message

    def initialize(msg = "알 수 없는 에러가 발생했습니다.", notification = false)
      @message = msg
      puts "DefaultError => #{msg}" if Rails.env.development?
    end
  end

  class ForbiddenError < StandardError
    attr_reader :message

    def initialize(msg = "403 에러가 발생했습니다.", notification = false)
      @message = msg
      puts "ForbiddenError => #{msg}" if Rails.env.development?
    end
  end

  class OpenApiError < StandardError
    attr_reader :message

    def initialize(msg = "400 에러가 발생했습니다.", notification = false)
      @message = msg
      puts "OpenApiError => #{msg}" if Rails.env.development?
    end
  end
end
