levelModule.factory('level', ['$q', '$http', '$log', ($q, $http, $log) ->
  @base_url = '/admin/api/v1'
  @sending  = false

  @apiCall = (callback, apiFunction) =>
    apiFunction()
    .success (data) =>
      callback(data)
    .error (data, status, header, config) =>
      $log.error("could not #{config} status #{status}")

  all: (callback) =>
    @apiCall callback, () =>
      $http.get(@base_url + '/levels.json')

  find: (id, callback) =>
    @apiCall callback, () =>
      $http.get(@base_url + "/levels/#{id}.json")

  launch: (name, callback) =>
    @apiCall callback, () =>
      $http.post(@base_url + '/levels.json', {level: {name: name}})

  build: (level, callback) =>
    @apiCall callback, () =>
      $http.put(@base_url + "/levels/#{level.id}/build.json", {level: {config: level.config_file}})

  run: (level, callback) =>
    @apiCall callback, () =>
      $http.put(@base_url + "/levels/#{level.id}/run.json")

  stop: (level, callback) =>
    @apiCall callback, () =>
      $http.put(@base_url + "/levels/#{level.id}/stop.json")

  join: (level, callback) =>
    @apiCall callback, () =>
      $http.put(@base_url + "/levels/#{level.id}/join.json")

  remove: (level, callback) =>
    @apiCall callback, () =>
      $http.delete(@base_url + "/levels/#{level.id}")

  objects_count: (level, callback) =>
    @apiCall callback, () =>
      $http.get(@base_url + "/levels/#{level.id}/objects_count.json")

])