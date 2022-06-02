class ChatsController < ApplicationController
  def show
    #Bさんのユーザー情報の取得
    @user = User.find(params[:id])
    #user_roomsテーブルのuser_idがAさんのレコードのroom_idを配列で取得
    rooms = current_user.user_rooms.pluck(:room_id)
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    if user_room.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
    else
      @room = user_room.room
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end
  
  def create
    @chat = Chat.new(chat_params)
    respond_to do |format|
      if @chat.save
        format.html {redirect_to @chat}
        format.js
      else
        format.html { render :show }
        format.js { render :errors }
      end
    end
  end
  
    private
    def chat_params
      params.require(:chat).permit(:message, :room_id).merge(user_id: current_user.id)
    end
end
