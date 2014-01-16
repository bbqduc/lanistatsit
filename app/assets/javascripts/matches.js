(function () {

var drawGoldTimeSeries = function(svgid, title)
{
	var tmpseries = [];
	var timeserieslen = gon.timeseries[0].gold.length;
	for(var i = 0; i < 10; i++)
	{
		tmpseries.push( { name: gon.timeseries[i].player,
				  data: gon.timeseries[i].gold } );
	}

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
            series: tmpseries
        });
}

var drawTimeSeries = function(svgid, title)
{
	var xpdata = [], golddata=[];
	for(var i in gon.radiant_timeseries.gold)
	{
		golddata.push(gon.radiant_timeseries.gold[i] - gon.dire_timeseries.gold[i])
		xpdata.push(gon.radiant_timeseries.xp[i] - gon.dire_timeseries.xp[i])
	}
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
                data: golddata
            },
	    {
                name: 'Total XP Earned',
                data: xpdata
            }]
        });
}

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

	drawTimeSeries("#testgoldchart", "Team difference over game time");
	drawGoldTimeSeries("#testindividualchart", "Individual gold chart");

};
$(document).ready(ready);

})();
