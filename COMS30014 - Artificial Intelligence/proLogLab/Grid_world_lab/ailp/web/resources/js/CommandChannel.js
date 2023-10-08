/**
  * CommandChannel Object (implemented using the JavaScript "module" design pattern)
  *
  * Synchronous http duplex communication from client using polling and two-stage rest calling:
  *     - first rest call fetches a list of pending commands for all agents
  *     - second rest call passes back the results of executed commands
  */

var CommandChannel = (function ($) {

	// public variables and public methods all exported via 'my' object
	var my = {};

	//
	// private variables
	//

    var active = false;

    var invocation = 0;

    var count = 0;

    var agent_by_id = {};
    var agents = [];

	var default_options = {
		url: "http://127.0.0.1:8000",
		type: "POST",
		interval: 2000, // 2 seconds
		repeat: 9007199254740992    // MAXINT
	};

	//
	// private methods
	//

	function step() {
		// each step has two http interactions with the server: 1st to get commands; 2nd to transmit results of commands
		if (count < my.options.repeat) {
			count++;
			invocation++;
			$.ajax({
			  	type: "POST",
			  	url: my.options.url + '/commands',
			  	// data: {},
			  	success: execute_commands
			});
		} else {
			active = false;
		}
	}

	function execute_commands(data, textStatus, jqXHR) {		
		// parse and execute the array of commands
		var results = [];
		var json = $.parseJSON(jqXHR.responseText);
		if (json.commands !== undefined) {
			json.commands.push(["god", "tick"]);
			for(var i=0; i<json.commands.length; i++) {
				// cmd is an array: [ id, commandName, arg0,arg1,...,argN ] where N >= 0
				var cmd = json.commands[i];
				// default result is to return failure
				var res = {fail: true};
				// unpack and attempt to execute command
				var id = cmd[0];
				var agent = agent_by_id[id];
				if (agent !== undefined) {
					var commandname = cmd[1];
					if (agent.commands[commandname] !== undefined) {
						// strip id and commandName off front of array, leaving just 0 or more args
						var args = cmd.slice(2);
						res = agent.commands[commandname].call(agent,args) || {};
					}
				}
				// package up result with a copy of original command
				results.push({
					command: cmd, 
					result: res
				});
			}
		}

		// initiate 2nd call to the server again, but this time with results
		$.ajax({
		  	type: "POST",
		  	url: CommandChannel.options.url + '/results',
		  	data: {
		      	"results": JSON.stringify(results)
		  	},
		  	success: function(){}
		});

		// if still in running mode, set a timer to trigger next cycle of command execution
		if (active) {
			setTimeout(step, my.options.interval);
		}
	}

	//
	// public variables
	//

    my.options = undefined;

	//
	// public methods
	//

	my.open = function(options) {
		// extend our default options with those provided
		my.options = $.extend({}, default_options, options);
		count = 0;
		// if (active) {
		// 	step();
		// }
	};

    my.run = function(repeats) {
		my.options.repeat = repeats || 9007199254740992;    // MAXINT
		count = 0;
		active = true;
		step();
	};

    my.pause = function() {
		active = false;
	};

    my.getInvocation = function() {
		return invocation;
	};

	// commands are enacted by agent objects

	my.Agent = function(agentId, commands, properties) {
		//
		//	STRING agentId - unique identifier
		//	OBJECT commands - commandName:function pairs
		//	OBJECT properties - arbitrary key:value pairs
		//
		if (agent_by_id[agentId] !== undefined) {
			throw "Agent already exists: " + agentId;
		}

		this.id = agentId;
		this.commands = commands || {};
		this.properties = properties || {};

		agent_by_id[agentId] = this;
	}

	my.getAgent = function(agentId) {
		return agent_by_id[agentId];
	}

	my.resetAgents = function() {
		//TODO: destroy any existing agents
		var god = agent_by_id["god"];
		if (god == undefined) {
	    	agent_by_id = {};
	    	agents = [];
	    }
	    else {
	    	agent_by_id = {"god":god};
	    	agents = [god];
	    }
	}

	return my;
}($));

