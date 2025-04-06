class UserSerializer
  def self.render_balance(user)
    {
      points: user.points
    }
  end
end
