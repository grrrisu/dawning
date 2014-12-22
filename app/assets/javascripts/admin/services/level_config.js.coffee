levelModule.factory('levelConfigs', [ '$q', '$http', '$log', ($q, $http, $log) ->

  all: () ->
    @future = $q.defer()
    $http.get('/admin/api/v1/config_files.json')
      .success (data) =>
        @future.resolve(data)
      .error (data, status, headers, config) =>
        $log.warn(data, status, headers(), config)
        @future.reject("Error while loading config files status: #{status}")
    @future.promise

])
