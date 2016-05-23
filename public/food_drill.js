/*jslint browser: true*/
/*global $, ng_re, ng_nw, ng_ne, ng_nc, ng_sw, ng_se, ng_ss, food_poverty_by_state, food_poverty_by_region*/

$(function () {
    "use strict";
    // Set drilldown pointers
    $.each(ng_re, function () {
        this.drilldown = this.code;
    });

    // Instanciate the map
    $('#food-region').highcharts('Map', {
        chart : {
            events: {
                drilldown: function (e) {

                    if (!e.seriesOptions) {
                        var chart = this,
                            data = '';
                        switch (e.point.code) {
                        case 'NW':
                            data = ng_nw;
                            break;
                        case 'NE':
                            data = ng_ne;
                            break;
                        case 'NC':
                            data = ng_nc;
                            break;
                        case 'SW':
                            data = ng_sw;
                            break;
                        case 'SE':
                            data = ng_se;
                            break;
                        case 'SS':
                            data = ng_ss;
                            break;
                        }

                        chart.addSeriesAsDrilldown(e.point, {
                            name: e.point.name,
                            joinBy: ['name', 'name'],
                            data: food_poverty_by_state,
                            mapData: data,
                            dataLabels: {
                                enabled: true,
                                format: '{point.code}'
                            },
                            tooltip: {
                                pointFormat: '{point.name}: {point.value}%'
                            }
                        });
                    }
                    this.setTitle(null, { text: e.point.name });
                },
                drillup: function () {
                    this.setTitle(null, { text: 'NG' });
                }
            }
        },

        title : {
            text : 'Food Poverty (%)'
        },

        subtitle: {
            text: 'NG',
            floating: true,
            align: 'right',
            y: 50,
            style: {
                fontSize: '16px'
            }
        },

        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle'
        },

        mapNavigation: {
            enabled: true,
            buttonOptions: {
                verticalAlign: 'bottom'
            }
        },

        colorAxis: {
            min: 10,
            // type: 'logarithmic',
            minColor: '#E6E7E8',
            maxColor: '#005645'
        },

        plotOptions: {
            map: {
                states: {
                    hover: {
                        color: '#EEDD66'
                    }
                }
            }
        },

        series : [{
            animation: {
                duration: 1000
            },
            type: "map",
            joinBy: ['name', 'name'], // <- mapping 'name' in data to 'name' in mapData
            data : food_poverty_by_region,
            dataLabels: {
                enabled: true,
                color: '#FFFFFF',
                format: '{point.name}'
            },
            mapData: ng_re,
            name: 'NG',
            tooltip: {
                pointFormat: '{point.name}: {point.value}%'
            }
        }],
        drilldown: {
            //series: drilldownSeries,
            activeDataLabelStyle: {
                color: '#FFFFFF',
                textDecoration: 'none',
                textShadow: '0 0 3px #000000'
            },
            drillUpButton: {
                relativeTo: 'spacingBox',
                position: {
                    x: 0,
                    y: 60
                }
            }
        }

    });
});
