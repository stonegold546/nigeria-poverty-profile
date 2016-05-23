/*jslint browser: true*/
/*global $, ng_all, dollar_poverty_by_state*/

$(function () {
    "use strict";
    $('#dollar-state').highcharts('Map', {
        title : {
            text : 'Dollar Per Day Poverty (%)'
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
            min: 30,
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
            data : dollar_poverty_by_state,
            dataLabels: {
                enabled: true,
                color: '#FFFFFF',
                format: '{point.code}'
            },
            mapData: ng_all,
            name: 'NG',
            tooltip: {
                pointFormat: '{point.name}: {point.value}%'
            }
        }]
    });
});
