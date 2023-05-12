local grafana = import 'grafonnet/grafana.libsonnet';

grafana.dashboard.new(
    title='New Dashboard',
    editable=true,
    schemaVersion=21,
    time_from='now-5m'
).addInput(
    name='prometheus',
    label='Prometheus',
    type='datasource',
    pluginId='prometheus',
    pluginName='Prometheus',
    description='Choose your Data Source'
).addTemplate(
    grafana.template.custom(
        name='job',
        label='Job',
        query='label_values(windows_cs_hostname, job)',
        current='label_values(windows_cs_hostname, job)',
        hide='variable',
    )
)