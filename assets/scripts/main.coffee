
{div, h1, form, span, label, input, button} = React.DOM

# Don't trust this algorithm
compareEngine = (yourName, matesName) ->
  you = yourName.split("").sort()
  friend = matesName.split("").sort()
  intersect = []
  if you.length > friend.length
    for letter in you
      if friend.indexOf(letter) != -1
        intersect.push letter
  else
    for letter in friend
      if you.indexOf(letter) != -1
        intersect.push letter

  score = ( intersect.length / (+you.length + friend.length) ) * 100
  return Math.ceil(100 - score - (+you.length + friend.length) )


Results = React.createClass
  getInitialState: ->
    return {progress: 0}
  render: ->
    $this = this
    score = this.props.score
    window.animateProgress = ->
      $this.setState({progress: score})
      return
    setTimeout(window.animateProgress, 200)
    div className:"results",
    	div className:"radial-progress", "data-progress":@state.progress,
    		div className: "circle",
    			div className: "mask full",
    				div className: "fill"
    			div className: "mask half",
    				div className: "fill"
    				div className: "fill fix"
    			div className: "shadow"
    		div className: "inset",
    			div className: "percentage",
    				div className: "numbers",
    					span null, "-"
    					for x in [0...100] by 1
    						span key: x, x+"%"


Cupid = React.createClass
  getInitialState: ->
    return {yourName: "", matesName: "", showResults: false, score: 0, errorMessage: ""}

  handleyourNameChange: (e) ->
    this.setState({yourName: e.target.value})
    this.setState({showResults: false})
    this.setState({errorMessage: ""})
    return

  handleMatesNameChange: (e) ->
    this.setState({matesName: e.target.value})
    this.setState({showResults: false})
    this.setState({errorMessage: ""})

  handleSubmit: (e) ->
    e.preventDefault()
    yourName = this.state.yourName.trim()
    matesName = this.state.matesName.trim()

    # check for empty fields
    if yourName.length < 1
      this.setState({errorMessage: "Please enter your name"})
      return
    else if matesName.length < 1
      this.setState({errorMessage: "Please enter your friend's name"})
      return
    else
      result = compareEngine(yourName, matesName)
      this.setState({score: result})
      this.setState({showResults: true})
      return

  render: ->
  	form className:"Cupid", onSubmit: @handleSubmit,
  		h1 null, "Friendship Rating ¯\\_(ツ)_/¯"
  		span className:"error", @state.errorMessage
  		label htmlFor: "your-name",
  			input
  				type: "text"
  				className:"input"
  				id:"your-name"
  				autoComplete:false
  				placeholder:"Your name"
  				onChange:@handleyourNameChange
  				state: @state.yourName
  		span className: "and", "and"
  		label htmlFor: "mates-name",
  			input
  				type: "text"
  				className:"input"
  				id:"mates-name"
  				autoComplete:false
  				placeholder:"Your friends's name"
  				onChange:@handleMatesNameChange
  				value: @state.matesName
  		button className:"button", type:"submit", "check"
  		resultComponent = React.createFactory(Results)
  		if @state.showResults
            resultComponent {score: @state.score}

ReactDOM.render(<Cupid />, document.getElementById("container"))