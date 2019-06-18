module V1
  module Profiles
    class ProfileChecker < ApplicationService
      attr_accessor :user, :type

      def initialize(user, type)
        self.type = type.upcase
        self.user = user
      end

      def call
        return true if user.profile.title.to_s == type.to_s

        false
      end
    end
  end
end