App.progress_bar = App.cable.subscriptions.create "ProgressBarChannel",
  connected: ->
# Called when the subscription is ready for use on the server

  disconnected: ->
# Called when the subscription has been terminated by the server

  received: (data) ->
# Called when there's incoming data on the websocket for this channel
  @appendLine(data)

  appendLine: (data) ->
    html = @createLine(data)
    $("[data]").append(html)

  createLine: (data) ->
    """
    <article class="progress_bar">
      <span class="body">#{data["body"]}</span>
    </article>
    """