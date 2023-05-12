local grafana = import 'grafonnet/grafana.libsonnet';

grafana.dashboard.new(
  timezone='utc',
  title='Payment gateway (high-level)',
  uid='test',
)
.addPanel(
  grafana.text.new(
    content='Yippie',
    mode='markdown',
  ),
  gridPos={
    x: 0,
    y: 0,
    w: 24,
    h: 2,
  },
)