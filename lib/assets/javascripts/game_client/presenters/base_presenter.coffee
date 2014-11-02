class Game.BasePresenter

  show_field_info: (shape, map) =>
    shape.on 'click', (e) =>
      field = map.getFieldFromFieldShape(shape)
      field_info = $('#field_info')
      field_info.find('td.type').text(field.data.vegetation.type)
      field_info.find('td.size').text(field.data.vegetation.size)

      if field.data.flora
        field_info.find('td.flora').text(field.data.flora.type)
        field_info.find('td.flora-size').text(field.data.flora.size)
      else
        field_info.find('td.flora').text('')
        field_info.find('td.flora-size').text('')

      if field.data.fauna
        field_info.find('td.fauna').text(field.data.fauna.type)
        field_info.find('td.fauna-health').text(field.data.fauna.health)
        field_info.find('td.fauna-age').text(field.data.fauna.age)
      else
        field_info.find('td.fauna').text('')
        field_info.find('td.fauna-health').text('')
        field_info.find('td.fauna-age').text('')
