# 회원 뷰 헬퍼
module UserHelper
  def user_view(user)
    {
      id: user.id,
      username: user.username,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end