window.PerformanceDashboard = {} unless window.PerformanceDashboard?
window.PerformanceDashboard.Sparkline = {} unless window.PerformanceDashboard.Sparkline?

class Sparkline
  w = 100
  h = 50

  initializeEvents: (dataArray) ->
    values = @extractDataPoints(dataArray)
    y = d3.scale.linear().domain([0, d3.max(values)]).range([0, h])
    x = d3.scale.linear().domain([0, values.length]).range([0, w])

    vis = d3.select(".sparkline")
      .append("svg:svg")
      .attr("width", w)
      .attr("height", h)
    g = vis.append("svg:g")
      .attr("transform", "translate(0,#{w})")
    #path element for line itself
    line = d3.svg.line()
      .x( (d, i) -> x(i) )
      .y( (d) -> -1 * y(d) )
    g.append("svg:path").attr("d", line(values))


  extractDataPoints: (dataArray)->
    data_arr = []
    for d in dataArray
      data_arr.push d[1]


$ ->
  window.PerformanceDashboard.Sparkline = new Sparkline()
