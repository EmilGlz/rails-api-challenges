module Api
    module V1
      class ChallengesController < ApplicationController
        before_action :authenticate_user!, only: %i[create update destroy]
        before_action :set_challenge, only: %i[show update destroy]
        before_action :authorize_admin, only: %i[create update destroy]
        # GET    /api/v1/challenges
        def index
          # show all challenges
          @challenge = Challenge.all
          render json: @challenge
        end

        # POST   /api/v1/challenges
        def create
            # @challenge = Challenge.new(challenges_params.merge(user_id: current_user.id))
            @challenge = current_user.challenges.build(challenges_params)
            if @challenge.save
                render json: { message: "Challenge added successfully", data: @challenge }
            else
                render json: { message: "Failed to add challenge", data: @challenge.errors }
            end
        end

        # GET    /api/v1/challenges/:id
        def show
          # show single challenge
          if @challenge
            render json: { message: "Challenge found!", data: @challenge }
          else
            render json: { message: "Challenge not found!", data: @challenge.errors }
          end
        end

        # PATCH/PUT  /api/v1/challenges/:id
        def update
            if @challenge.update(challenges_params)
              render json: { message: "Challenge updated", data: @challenge }
            else
              render json: { message: "Challenge not found!", data: @challenge.errors }
            end
        end

        # DELETE /api/v1/challenges/:id
        def destroy
            if @challenge.destroy
                render json: { message: "Challenge deleted", data: @challenge }
            else
                render json: { message: "Challenge not found!", data: @challenge.errors }
            end
        end

        private
        def authorize_admin
          render json: { message: "Forbidden Action" } unless current_user.email == ENV["ADMIN_EMAIL"]
        end

        def set_challenge
            @challenge = Challenge.find(params[:id])
        end

        def challenges_params
            params.require(:challenge).permit(:title, :description, :start_date, :end_date)
        end
      end
    end
end
