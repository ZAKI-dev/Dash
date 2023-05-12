local grafana = import 'grafonnet/grafana.libsonnet';
grafana.dashboard.new(
    title='My dashboard',
    editable=true,
    schemaVersion=21,
    time_from='now-30m'
).addInput( # add an import variable
    # Variable name to be used in the dashboard code
    name='DS_PROMETHEUS',
    # Variable name to be displayed on the import screen
    label='Prometheus',
    # This variable defines the data source
    type='datasource',
    # Data will be received from the Prometheus plugin
    pluginId='prometheus',
    pluginName='Prometheus',
    # Variable description to be displayed on the import screen
    description='Prometheus metrics bank'
).addTemplate(
    grafana.template.custom(
        name='job',
        label='Job',
        query='label_values(windows_cs_hostname, job)',
        current='',
        hide='variable',
    )
).addTemplate(
    grafana.template.custom(
        name='hostname',
        label='Hostname',
        query='label_values(windows_cs_hostname{job=~"$job"}, hostname)',
        current='',
        hide='variable',
    )
).addTemplate(
    grafana.template.custom(
        name='instance',
        label='instance',
        query='label_values(windows_cs_hostname{job=~"$job",hostname=~"$hostname"}, instance)',
        current='',
        hide='variable',
    )
).addPanel(
    grafana.graphPanel.new(
        title='Panel with Code 200',
        type='bargauge',
        # Use the variable value as a data source
        datasource='${DS_PROMETHEUS}',
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
            expr='rate(prometheus_http_requests_total{code="200"}[$__rate_interval])',
            legendFormat='{{alias}}',
        )
    ),
    gridPos = { h: 8, w: 12, x: 0, y: 0 }
).addPanel(
    grafana.graphPanel.new(
        title='Panel with Code 400',
        datasource='${DS_PROMETHEUS}',
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
            expr='rate(prometheus_http_requests_total{code="400"}[$__rate_interval])',
            legendFormat='{{alias}}',
        )
    ),
    gridPos = { h: 8, w: 12, x: 12, y: 0 },
).addPanel(
    grafana.graphPanel.new(
        title='CPU usage',
        datasource='${DS_PROMETHEUS}',
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
            expr='100 - avg(irate(windows_cpu_time_total{job=~"$job",instance=~"$instance",mode="idle"}[5m]))*100',
            legendFormat='{{alias}}',
        )
    ),
    gridPos = { h: 8, w: 12, x: 0, y: 9 },
).addPanel(
    grafana.graphPanel.new(
        title='Disk Read/Write',
        datasource='${DS_PROMETHEUS}',
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
            expr='irate(windows_logical_disk_read_bytes_total{job=~"$job",instance=~"$instance",volume!~"HarddiskVolume.+"}[5m])',
            legendFormat='{{alias}}',
        )
    ),
    gridPos = { h: 8, w: 12, x: 12, y: 9 },
)