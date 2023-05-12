local grafana = import 'grafonnet/grafana.libsonnet';
grafana.dashboard.new(
    title='Http total request',
    # allow the user to make changes in Grafana
    editable=true,
    # avoid issues associated with importing multiple versions in Grafana
    schemaVersion=21,
).addPanel(
    grafana.graphPanel.new(
        title='My first graph',
        # demonstration data
        datasource='Prometheus'
    ).addTarget(
        grafana.prometheus.target(
            expr='rate(prometheus_http_requests_total{code=\"200\"}[$__rate_interval])'
        )
    ),
    # panel position and size
    gridPos = { h: 8, w: 8, x: 0, y: 0 }
)