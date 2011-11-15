window.PerformanceDashboard = {} unless window.PerformanceDashboard?
window.PerformanceDashboard.Sparkline = {} unless window.PerformanceDashboard.Sparkline?

class Sparkline
  w = 50
  h = 50
  margin = 5

  initializeEvents: (dataArray, column) ->
    values = @extractDataPoints(dataArray)
    y = d3.scale.linear().domain([0, d3.max(values)]).range([0, h-margin])
    x = d3.scale.linear().domain([0, values.length-1]).range([0, w-margin])

    console.log column
    vis = d3.select(column)
      .append("svg:svg")
      .attr("width", w)
      .attr("height", h)

    vis.selectAll('path.line')
      .data([values])
      .enter().append("svg:path")
      .attr("d", d3.svg.line().x( (d, i) -> x(i)).y(y))


  extractDataPoints: (dataArray)->
    data_arr = []
    for d in dataArray
      data_arr.push d[1]
    data_arr


$ ->
  window.PerformanceDashboard.Sparkline = new Sparkline()
