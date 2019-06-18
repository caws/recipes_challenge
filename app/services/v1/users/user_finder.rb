module V1
  module Users
    class UserFinder < ApplicationService
      attr_accessor :params

      def initialize(params)
        self.params = params
      end

      def call
        if params[:profile_id]
          return Profile.find_by_id(params[:profile_id]).users.page(params[:page])
        end

        User.page(params[:page])
      end
    end
  end
end