levelModule.factory 'd3Color', [ () ->
  lolita: ->
    # http://colrd.com/palette/31122/
    d3.scale.ordinal()
      .range ['#328dbd', '#2cb377', '#f28248', '#fdde6c', '#9d3fa3', '#583b97', '#8bbb42']

  paired: ->
    d3.scale.ordinal()
      .range ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928"]
  
  set1: ->
    d3.scale.ordinal()
      .range ["#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00","#ffff33","#a65628","#f781bf","#999999"]
  
  set2: ->
    d3.scale.ordinal()
      .range ["#66c2a5","#fc8d62","#8da0cb","#e78ac3","#a6d854","#ffd92f","#e5c494","#b3b3b3"]
  
  # http://colrd.com/
  papagei: ->
    d3.scale.ordinal()
      .range ['#e7ebee','#6c7197','#739211','#080300','#d92405', '#3563eb', '#eac124']
  
  # http://colrd.com/
  dark: ->
    d3.scale.ordinal()
    .range ['#1a1334', '#26294a', '#01545a', '017351', '#03c383', '#aad962', '#fbbf45', '#ef6a32', '#ed0345', '#a12a5e', '#710162', '#110141']  
  
  # http://colrd.com/
  summerNight: ->
    d3.scale.ordinal()
    .range ['#2a7185', '#a64027', '#fbdf72', '#60824f', '#9cdff0', '#022336', '#725ca5']
  
  # http://colrd.com/
  vanGogh: ->
    d3.scale.ordinal() 
    .range ['#faa818','#41a30d','#ffce38','#367d7d','#d33502','#6ebcbc','#37526d']
  
  # http://colrd.com/
  rainbow: ->
    d3.scale.ordinal()
    .range ['#7f0000',    '#cc0000',    '#ff4444',    
      '#ff7f7f',    '#ffb2b2',    '#995100',    
      '#cc6c00',    '#ff8800',    '#ffbb33',    
      '#ffe564',    '#2c4c00',    '#436500',    
      '#669900',    '#99cc00',    '#d2fe4c',    
      '#3c1451',    '#6b238e',    '#9933cc',    
      '#aa66cc',    '#bc93d1',    '#004c66',    
      '#007299',    '#0099cc',    '#33b5e5',    
      '#8ed5f0',    '#660033',    '#b20058',    
      '#e50072',    '#ff3298',    '#ff7fbf']
  
  # http://colrd.com/
  peacock: ->
    d3.scale.ordinal()
    .range ['#c13600', '#df7605', '#eeca52', '#9baa65', '#0b9f89', '#030736']

  # http://colrd.com/palette/24807/
  round: ->
    d3.scale.ordinal()
    .range ['#0094d4', '#f04533', '#282d6f', '#01b14c', '#fdba2d', '#91969a']    

]