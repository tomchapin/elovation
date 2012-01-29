class ResultService
  def self.create(game, params)
    winner = Player.find(params[:winner_id])
    loser = Player.find(params[:loser_id])

    result = game.results.build(
      :winner => winner,
      :loser => loser,
      :players => [winner, loser]
    )

    if result.valid?
      RatingService.update(game, winner, loser)
      result.save!

      Result.transaction do
        OpenStruct.new(
          :success? => true,
          :result => result
        )
      end
    else
      OpenStruct.new(
        :success? => false,
        :result => result
      )
    end
  end
end
