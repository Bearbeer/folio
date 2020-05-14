# frozen_string_literal: true

# 회원 헬퍼
module UserHelper
  def user_view(user)
    {
      id: user.id,
      username: user.username,
      name: user.name,
      mobile: user.mobile,
      email: user.email,
      gender: user.gender,
      birthday: user.birthday,
      address: user.address,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end