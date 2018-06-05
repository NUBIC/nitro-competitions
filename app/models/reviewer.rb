# encoding: UTF-8

class Reviewer < ApplicationRecord
  belongs_to :user
  belongs_to :program
end
