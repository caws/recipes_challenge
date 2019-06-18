module V1
  module Users
    class CookCreator < ApplicationService
      attr_accessor :user

      def initialize(params)
        self.user = User.new(params)
        self.user.profile = Profile.second
      end

      def call
        user
      end
    end
  end
end