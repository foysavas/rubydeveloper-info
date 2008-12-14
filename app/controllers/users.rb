class Users < Application
  # provides :xml, :yaml, :js
  before :ensure_authenticated, :only => %W{edit update}
  params_protected :post => [:inviter_id, :invite_depth, :invite_score]

  def index
    if params[:page]
      @current_page = params[:page].to_i
    else
      @current_page = 1
    end
    @user_count, @users = User.paginated(:order => [:invite_score.desc], :page => @current_page, :per_page => 25)
    display @users
  end

  def show(id)
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  def new
    only_provides :html
    @user = User.new
    display @user
  end

  def edit(id)
    only_provides :html
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  before :check_invite, :only => 'create'
  def create(user)
    @user = User.new(user)
    if @invite
      @user.inviter = @invite.user
    end
    if @user.save
      if @invite
        @invite.used = 1
        @invite.save
        inviter = User.get(@user.inviter_id)
        inviter.invite_score += 1
        inviter.save
      end
      session.user = @user
      redirect resource(@user), :message => {:notice => "User was successfully created"}
    else
      message[:error] = "user failed to be created"
      render :new
    end
  end

  def update(id, user)
    @user = User.get(id)
    raise NotFound unless @user
    raise NotFound unless @user == session.user
    if @user.update_attributes(user)
       redirect resource(@user)
    else
      display @user, :edit
    end
  end


  private

  def check_invite
    unless User.count == 0
      @invite = Invite.find(params[:invite_code])
      if @invite.nil? || @invite.used
        @user = User.new(params[:user])
        message[:error] = "You must have a fresh signup code."
        throw :halt, Proc.new { render :new }
      end
    end
  end

end # Users
