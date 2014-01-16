(function()
{
	var lastresult;
	var iv=window.setInterval(function()
	{
		var matchid=$("#matchdata").data("matchid");
		if(matchid)
		{
			$.getJSON(matchid + "/parse_status.json", function(result)
			{
				switch(result.progress)
				{
					case "true":
					{
						window.clearInterval(iv);
						$("#parse_progress").parent().append(
							$('<input class="btn btn-primary" type="submit" value="Download replay">')
						);
						$("#parse_progress").hide();
					}
					break;
					case "inprogress":
					{
						var oldtext=$("#parse_progress").text();
						$("#parse_progress").text(oldtext+"."); // :D
					}
					break;
					case "false":
					{
						if(lastresult === "inprogress")
						{
							window.clearInterval(iv);
							$("#parse_progress").parent().append(
								$("<h4>Replay parsing failed.</h4>")
							);
							$("#parse_progress").hide();
						}
					}
				}
				lastresult=result.progress;
			});
		} else window.clearInterval(iv);
	}, 2000);
})();
