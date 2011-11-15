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
    """
      <tr>
        <td><strong>#{k}</strong></td>
        <td>Sparkline</td>
        <td>#{v[v.length-1][1].toFixed(2)}
      </tr>
    """

$ ->
  window.PerformanceDashboard.MainDashboard = new MainDashboard
