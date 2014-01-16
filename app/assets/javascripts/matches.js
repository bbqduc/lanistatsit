(function () {
function calc(a,b) { return a + b[i][keyvalue]; }

var getDiffChartData = function(keyvalue)
{
	var arr = [];
	for(var i in gon.radiant_timeseries[0])
	{
		var radsum = gon.radiant_timeseries.reduce(calc, 0);
		var diresum = gon.dire_timeseries.reduce(calc, 0);
		arr.push (radsum - diresum);
	}
	return arr;
};

var drawGoldTimeSeries = function(svgid, title)
{
	var tmpseries = [];
	for(var i in gon.radiant_timeseries[0])
	{
		var radsum = gon.radiant_timeseries.reduce(calc, 0);
		var diresum = gon.dire_timeseries.reduce(calc, 0);
		arr.push (radsum - diresum);
	}

	$(svgid).highcharts(
	{
		chart: {
			type: 'areaspline'
		},
		title: {
			text: title
		},
		legend: {
			layout: 'vertical',
			align: 'left',
			verticalAlign: 'top',
			x: 150,
			y: 100,
			floating: true,
			borderWidth: 1,
			backgroundColor: '#FFFFFF'
		},
		xAxis: {
			title: {
				text: 'Minute'
			}
		},
		yAxis: {
			title: {
				text: 'Gold'
			}
		},
		tooltip: {
			shared: true,
			valueSuffix: ''
		},
		credits: {
			enabled: false
		},
		plotOptions: {
			areaspline: {
				fillOpacity: 0.5
			}
		},
		series: [{
			name: 'Total Gold Earned',
			data: data[0]
		},
		{
			name: 'Total XP Earned',
			data: data[1]
		}]
	});
};

var drawTimeSeries = function(data, svgid, title)
{
	$(svgid).highcharts({
		chart: {
			type: 'areaspline'
		},
		title: {
			text: title
		},
		legend: {
			layout: 'vertical',
			align: 'left',
			verticalAlign: 'top',
			x: 150,
			y: 100,
			floating: true,
			borderWidth: 1,
			backgroundColor: '#FFFFFF'
		},
		xAxis: {
			title: {
				text: 'Minute'
			}
		},
		yAxis: {
			title: {
				text: 'Gold'
			}
		},
		tooltip: {
			shared: true,
			valueSuffix: ''
		},
		credits: {
			enabled: false
		},
		plotOptions: {
			areaspline: {
				fillOpacity: 0.5
			}
		},
		series: [{
			name: 'Total Gold Earned',
			data: data[0]
		},
		{
			name: 'Total XP Earned',
			data: data[1]
		}]
	});
};

var drawPieChart = function(origdata, valuekey, svgid, title)
{
	var fdata = origdata.filter(function(d) { return d[valuekey] > 0;} );
	if(fdata.length === 0) return;
	$(svgid).attr("class", "matchpiechart");

	var data = [];
	for(var i in fdata)
	{
		data.push([fdata[i].player, fdata[i][valuekey]]);
	}

	$(svgid).highcharts({
		chart: {
			plotBackgroundColor: null,
		plotBorderWidth: null,
		plotShadow: false
		},
		navigation: {
			buttonOptions: {
				enabled: false,
			},
		},
		title: {
			text: title
		},
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		},
		plotOptions: {
			pie: {
				allowPointSelect: true,
				cursor: 'pointer',
				dataLabels: {
					enabled: true,
					color: '#000000',
					connectorColor: '#000000',
					format: '<b>{point.name}</b>: {point.percentage:.1f} %'
				}
			}
		},
		series: [{
			type: 'pie',
			name: title,
			data: data
		}]
	});
};

var ready = function(){
	drawPieChart(gon.damagechartdata.radiant, "herodamage", "#radiantdamagechart", "Radiant Hero Damage");
	drawPieChart(gon.damagechartdata.radiant, "towerdamage", "#radianttowerdamagechart", "Radiant Tower Damage");
	drawPieChart(gon.damagechartdata.radiant, "gold", "#radiantgoldchart", "Radiant Gold");

	drawPieChart(gon.damagechartdata.dire, "herodamage", "#diredamagechart", "Dire Hero Damage");
	drawPieChart(gon.damagechartdata.dire, "towerdamage", "#diretowerdamagechart", "Dire Tower Damage");
	drawPieChart(gon.damagechartdata.dire, "gold", "#diregoldchart", "Dire Gold");

	var golddiffdata = getDiffChartData("gold");
	var xpdiffdata = getDiffChartData("xp");
	drawTimeSeries([golddiffdata, xpdiffdata], "#testgoldchart", "Team difference over game time");
};
$(document).ready(ready);

})();
