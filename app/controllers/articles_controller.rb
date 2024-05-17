class ArticlesController < ApplicationController
  # http_basic_authenticate_with name: "mohamed", password: "mohamed", except: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :report]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  def report
    @article = Article.find(params[:id])
    @article.increment!(:reports_count)
    @article.save
    redirect_to root_path, status: :see_other, notice: 'Article reported successfully.'
  end


  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_user!
    redirect_to articles_path, notice: "Not authorized" unless @article.user == current_user
  end

  def article_params
    params.require(:article).permit(:title, :body, :status,  :image)
  end


end
