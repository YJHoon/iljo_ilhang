class User < ApplicationRecord
  enum gender: {male: 0, femail: 1}
end
