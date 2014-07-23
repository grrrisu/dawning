class Game.ApiCaller

  constructor: (@base_url) ->
    @base_url ?= window.location.protocol + '//' + window.location.host + window.location.pathname

  get: (path, onsuccess) =>
    @request(path, 'GET', null, onsuccess)

  post: (path, data, onsuccess) =>
    @request(path, 'POST', data, onsuccess)

  put: (path, data, onsuccess) =>
    @request(path, 'PUT', data, onsuccess);

  delete: (path, onsuccess) =>
    @request(path, 'DELETE', null, onsuccess);

  handle_error: (jqXHR, textStatus, errorThrown) =>
    if(jqXHR.status == 403)
      window.location.href = jqXHR.responseJSON.location
    else
      console.log("XHR ERROR: " + errorThrown + ', ' + textStatus);

  request: (path, type, data, onsuccess) =>
    $.ajax
      url: @base_url + path
      type: type
      data: data
    .done(onsuccess)
    .fail(@handle_error);
