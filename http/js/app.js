// Dev-helper
function print_filter(filter){
    var f=eval(filter);
    if (typeof(f.length) != "undefined") {}else{}
    if (typeof(f.top) != "undefined") {f=f.top(Infinity);}else{}
    if (typeof(f.dimension) != "undefined") {f=f.dimension(function(d) { return "";}).top(Infinity);}else{}
    console.log(filter+"("+f.length+") = "+JSON.stringify(f).replace("[","[\n\t").replace(/}\,/g,"},\n\t").replace("]","\n]"));
};

// Histograms
var severity_bar            = dc.barChart("#severity");

// Map
var world_map               = dc.geoChoroplethChart("#map");

// Indexing data.
var cf = crossfilter(data);

// Defining the cross-filter dimensions.
cf.iso = cf.dimension(function(d){ return d.iso });

// Defining the histogram bins.
cf.severity = cf.dimension(function(d) { d.severity_bin = Math.round(d.severity_normalized); return d.severity_bin; });


// Organizing the cross-filter groups.
var all = cf.groupAll();
var iso = cf.iso.group();
var severity = cf.severity.group();

severity_bar.width(200).height(100)
        .x(d3.scale.linear().domain([0,10]))
        .margins({top: 20, left: 40, right: 30, bottom: 20})
        .brushOn(true)
        .dimension(cf.severity)
        .group(severity)
        .elasticY(true)
        .renderVerticalGridLines(true)
        .centerBar(true);

dc.dataCount("#count-info")
    .dimension(cf)
    .group(all);

// Map properties.
var center_points = [85, 28];
var map_scale = 100;

// World map.
world_map.width(700).height(450)
        .dimension(cf.iso)
        .group(iso)
        .colors(['#ecf0f1', '#16a085'])
        .colorDomain([0, 1])
        .colorAccessor(function (d) {
            if(d>0){
                return 1;
            } else {
                return 0;
            }
        })
        .overlayGeoJson(world.features, "adm0_a3", function (d) {
            return d.properties.adm0_a3;
        })
        .projection(d3.geo.mercator()
            .center(center_points)
            .scale(map_scale))
        .title(function(d){
            return d.geounit;
        });

dc.renderAll();

var projection = d3.geo.mercator()
    .center(center_points)
    .scale(map_scale);

var path = d3.geo.path()
    .projection(projection);

var g = d3.selectAll("#map")
    .select("svg")
    .append("g");

// // Adm0 map.
// g.selectAll("path")
//     .data(world.features)
//     .enter()
//     .append("path")
//     .attr("d", path)
//     .attr("stroke",'#2c3e50')
//     .attr("stroke-width",'2px')
//     .attr("fill",'none')
//     .attr("class","macroregiao");

var mapLabels = d3.selectAll("#map")
    .select("svg")
    .append("g");
