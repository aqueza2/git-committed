class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages.where("id > ?", params[:data].to_i )
    # if @messages.length > 10
    #   @over_ten = true
    #   @messages = @messages[-10..-1]
    # end
    # if params[:m]
    #   @over_ten = false
    #   @messages = @conversation.messages
    # end
    if @messages.last && @messages.last.user_id != current_user.id
      @messages.last.read = true;
    end
    @message = @conversation.messages.new

    respond_to do |format|
      format.html do
       render 'index.html.erb'
     end
      format.js do
        render 'index.js.erb'
      end
    end

  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    # else
      # render template: "conversations/"
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end