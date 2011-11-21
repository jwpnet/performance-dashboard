window.PerformanceDashboard = {} unless window.PerformanceDashboard?
window.PerformanceDashboard.MainDashboard = {} unless window.PerformanceDashboard.MainDashboard?

class MainDashboard
  $app_name = ""

  color = d3.scale.linear()
    .domain([0, 50])
    .range(['#404040', "#FF0000"])
  constructor: ()->
    $app_name = $('#app_name').html().toLowerCase()
    @initializeEvents()
    
  initializeEvents: () ->
    chart_data = $.get("/get_data/#{$app_name}", (data) ->
      MainDashboard.prototype.renderData data
    )

  renderData: (chart_data) ->
    i = 0
    for k, v of chart_data
      sparkline_container = "sparkline#{i}"
      $('#chart tbody').append(@makeRow k, v, sparkline_container)
      window.PerformanceDashboard.Sparkline.initializeEvents(v, "#"+sparkline_container)
      i += 1

  makeRow: (k, v, sparkline_container) ->
    percent_change = @percentChange(v)
    """
      <tr>
        <td>#{k}</td>
        <td id='#{sparkline_container}'></td>
        <td>#{@changeArrow(percent_change)}</td>
        <td><strong>#{percent_change}%</strong></td>
        <td>#{v[v.length-1][1].toFixed(2)}
      </tr>
    """
  
  changeArrow: (number) ->
    if number > 0
      return "<div class='arrow-up' style='border-bottom:8px solid #{color(number)};'></div>"
    else
      return "<div class='arrow-down'></div>"

  percentChange: (dataArray) ->
    first = dataArray[0][1]
    last = dataArray[dataArray.length-1][1]
    change = last-first
    percent_change = change/last * 100
    percent_change.toFixed(1)

$ ->
  window.PerformanceDashboard.MainDashboard = new MainDashboard
