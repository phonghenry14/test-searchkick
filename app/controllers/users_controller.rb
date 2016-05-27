class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if params[:query].present?
      query = {query: {
        bool: {
          must: [
            {
              bool: {
                should: [
                  {match: {project_name: params[:project_name]}},
                  {match: {position_name: params[:position_name]}}
                ]
              }
            },
            {
              bool: {
                should: [
                  {range: {
                    created_at: {
                      gte: "12-06-2016",
                      lte: "13-06-2016"
                    }
                  }},
                  {range: {
                    created_at: {
                      gte: "03-07-2016",
                      lte: "13-07-2016"
                    }
                  }}
                ]
              }
            },
            {match: {name: params[:user_name]}},
            {multi_match: {
              query: params[:query],
              fields: ["name", "ja_product_name"]
            }},
            {match: {is_admin: params[:is_admin]}},
            {range: {
              age: {
                gte: 1,
                lte: 10
              }
            }},
            {
              nested: {
                path: "comments",
                query: {
                  bool: {
                    should: [
                      {
                        bool: {
                        must: [
                          {match: {"comments.id" => '1'}},
                          {match: {"comments.content" => params[:comment_content]}}
                        ]
                      }},
                      {
                        bool: {
                        must: [
                          {match: {"comments.id" => "3"}},
                          {match: {"comments.content" => params[:comment_content]}}
                        ]
                      }}
                    ]
                  }
                }
              }
            }
          ],
          must_not: [
            match: {age: 5}
          ]
        }
      }}
      @users = User.search query
    else
      @users = User.all.limit(100)
    end
  end

  def autocomplete
    render json: User.search(params[:term], {
      fields: ["name"],
      limit: 10,
      load: false,
      misspellings: {below: 5}
      }).map(&:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age, :product_id)
    end

    def search_params
      params.permit :page, :sort_attribute, :sort_order
    end
end
