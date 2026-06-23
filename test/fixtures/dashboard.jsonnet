local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.target.prometheus;
local graphPanel = grafana.graphPanel;

dashboard.new(
  'SRE Overview',
  schemaVersion=26,
  tags=['sre', 'platform'],
  timezone='browser',
  refresh='1m',
)
.addRow(
  row.new(title='HTTP Traffic')
  .addPanel(
    graphPanel.new(
      'Request Rate',
      datasource='Prometheus',
      span=6,
    )
    .addTarget(
      prometheus.target(
        'sum(rate(http_requests_total[5m])) by (status_code)',
        legendFormat='{{status_code}}',
      )
    )
  )
)
