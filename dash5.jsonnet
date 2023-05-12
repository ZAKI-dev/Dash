local grafana = import 'grafonnet/grafana.libsonnet';
 
 grafana.dashboard.new(
     title='My dashboard',
     editable=true,
     schemaVersion=21,
     # Display metrics over the last 30 minutes
     time_from='now-30m'
 ).addPanel(
     grafana.graphPanel.new(
         title='Pending requests',
         # Direct queries to the `Prometheus` data source
         datasource='Prometheus',
         min=0,
         labelY1='pending',
         fill=0,
         decimals=2,
         decimalsY1=0,
         sort='decreasing',
         legend_alignAsTable=true,
         legend_values=true,
         legend_avg=true,
         legend_current=true,
         legend_max=true,
         legend_sort='current',
         legend_sortDesc=true,
     ).addTarget(
         grafana.prometheus.target(
             # Query 'server_pending_requests' from datasource
             expr='rate(prometheus_http_requests_total{code=\"200\"}[$__rate_interval])',
             # Label query results as 'alias'
             # (corresponds to specific instances in the application cluster)
             legendFormat='{{alias}}',
         )
     ),
     gridPos = { h: 8, w: 8, x: 0, y: 0 }
 )