window.PerformanceDashboard = {} unless window.PerformanceDashboard?
window.PerformanceDashboard.MainDashboard = {} unless window.PerformanceDashboard.MainDashboard?

class MainDashboard
  $app_name = ""
  constructor: ()->
    $app_name = $('#app_name').html().toLowerCase()
    @initializeEvents()
    
  initializeEvents: () ->
    chart_data = $.get("/get_data/#{$app_name}", (data) ->
      MainDashboard.prototype.renderData data
    )

  renderData: (chart_data) ->
    for k, v of chart_data
      $('#chart tbody').append(@makeRow k, v)

  makeRow: (k, v) ->
    percent_change = @percentChange(v)
    """
      <tr>
        <td><strong>#{k}</strong></td>
        <td>Sparkline</td>
        <td colspan="2">#{percent_change} #{@changeArrow(percent_change)}
        </td>
        <td>#{v[v.length-1][1].toFixed(2)}
      </tr>
    """
  
  changeArrow: (number) ->
    if number > 0
      return "<div class='arrow-up'></div>"
    else
      return "<div class='arrow-down'></div>"

  percentChange: (dataArray) ->
    first = dataArray[0][1]
    last = dataArray[dataArray.length-1][1]
    change = first-last
    percent_change = change/last * 100
    percent_change.toFixed(1)

$ ->
  window.PerformanceDashboard.MainDashboard = new MainDashboard
