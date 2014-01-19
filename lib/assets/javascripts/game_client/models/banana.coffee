class @Banana extends Figure

  constructor: (data) ->
    @presenter        = new ImagePresenter(this)
    @image            = @setImage(data)

  getPresenter: () =>
    @presenter

  setImage: (data) =>
    switch data
      when "banana 1" then client.images['banana_1']
      when "banana 2" then client.images['banana_2']
      when "banana 3" then client.images['banana_3']
