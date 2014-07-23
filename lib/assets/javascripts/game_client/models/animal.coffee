class Game.Animal extends Game.Figure

  constructor: (data) ->
    @presenter        = new Game.ImagePresenter(this)
    @image            = @setImage(data)

  getPresenter: () =>
    @presenter

  setImage: (data) =>
    switch data
      when "rabbit" then client.images['rabbit']
      when "gazelle" then client.images['gazelle']
      when "mammoth" then client.images['mammoth']
      when "leopard" then client.images['leopard']
